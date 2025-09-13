import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class StreamSelectorPage extends StatefulWidget {
  const StreamSelectorPage({Key? key}) : super(key: key);

  @override
  State<StreamSelectorPage> createState() => _StreamSelectorPageState();
}

class _StreamSelectorPageState extends State<StreamSelectorPage> {
  int currentStep = 0;
  List<String> selectedAnswers = [];

  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuestionsFromDB();
  }

  /// ---------------- FETCH QUESTIONS FROM FIREBASE ----------------
  Future<void> fetchQuestionsFromDB() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref("stream_questions");

    final snapshot = await ref.get();
    if (snapshot.exists) {
      Map<String, dynamic> rawValue = {};

      if (snapshot.value is List) {
        // Firebase returned a List
        final list = List.from(snapshot.value as List);
        for (int i = 0; i < list.length; i++) {
          if (list[i] != null) {
            rawValue[i.toString()] = Map<String, dynamic>.from(list[i]);
          }
        }
      } else if (snapshot.value is Map) {
        // Firebase returned a Map
        rawValue = Map<String, dynamic>.from(snapshot.value as Map);
      }

      List<Map<String, dynamic>> loadedQuestions = [];
      rawValue.forEach((key, value) {
        final q = Map<String, dynamic>.from(value);
        Map<String, dynamic> options = {};

        if (q['options'] != null) {
          if (q['options'] is List) {
            final list = List.from(q['options']);
            for (int i = 0; i < list.length; i++) {
              if (list[i] != null) {
                options[i.toString()] = Map<String, dynamic>.from(list[i]);
              }
            }
          } else {
            options = Map<String, dynamic>.from(q['options']);
          }
        }

        loadedQuestions.add({
          "title": q["title"],
          "type": q["type"],
          "options": options, // Always a map
        });
      });

      setState(() {
        questions = loadedQuestions;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// ---------------------- AI LOGIC ----------------------
  Map<String, dynamic> recommendStreamChat(List<String> answers) {
    Map<String, double> scores = {
      "Science": 0,
      "Commerce": 0,
      "Arts": 0,
      "Design": 0,
      "Vocational": 0,
    };

    List<String> scienceKeywords = [
      "math", "experiment", "physics", "chemistry",
      "laboratory", "logical", "technology", "science_skill"
    ];
    List<String> commerceKeywords = [
      "business", "finance", "accounts", "numbers",
      "economics", "manage", "commerce_skill", "entrepreneur"
    ];
    List<String> artsKeywords = [
      "history", "literature", "debate", "music",
      "creative", "writing", "communication", "arts_skill"
    ];
    List<String> designKeywords = [
      "design", "art", "ui", "ux", "creative",
      "graphics", "visual"
    ];
    List<String> vocationalKeywords = [
      "hands-on", "practical", "field", "agriculture",
      "workshop", "vocational_skill", "practical_worker"
    ];

    for (String ans in answers) {
      String a = ans.toLowerCase();

      for (var k in scienceKeywords) {
        if (a.contains(k)) scores["Science"] = scores["Science"]! + 2;
      }
      for (var k in commerceKeywords) {
        if (a.contains(k)) scores["Commerce"] = scores["Commerce"]! + 2;
      }
      for (var k in artsKeywords) {
        if (a.contains(k)) scores["Arts"] = scores["Arts"]! + 2;
      }
      for (var k in designKeywords) {
        if (a.contains(k)) scores["Design"] = scores["Design"]! + 2;
      }
      for (var k in vocationalKeywords) {
        if (a.contains(k)) scores["Vocational"] = scores["Vocational"]! + 2;
      }

      if (a.contains("yes") || a.contains("often") || a.contains("love")) {
        scores["Science"] = scores["Science"]! + 0.1;
        scores["Commerce"] = scores["Commerce"]! + 0.1;
        scores["Arts"] = scores["Arts"]! + 0.1;
      }
    }

    var sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    String best = sorted.isNotEmpty ? sorted.first.key : "Science";
    String explanation =
        "Based on your answers, $best is the most aligned stream. Scores: $scores";

    return {
      "recommended_stream": best,
      "scores": scores,
      "explanation": explanation,
    };
  }

  /// ---------------------- REALTIME DATABASE SAVE ----------------------
  Future<void> saveResultToRealtimeDB(
      String stream, Map<String, double> scores) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference dbRef =
          FirebaseDatabase.instance.ref("stream_results/${user.uid}");
      await dbRef.set({
        "recommended_stream": stream,
        "scores": scores,
        "timestamp": DateTime.now().toIso8601String(),
      });
    }
  }

  /// ---------------------- FLOW ----------------------
  void _nextStep() {
    if (currentStep < questions.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      _showResult();
    }
  }

  void _prevStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _selectOption(String value, String type) {
    setState(() {
      if (type == 'multiple') {
        if (selectedAnswers.contains(value)) {
          selectedAnswers.remove(value);
        } else {
          selectedAnswers.add(value);
        }
      } else if (type == 'single') {
        selectedAnswers.removeWhere((ans) => questions[currentStep]['options']
            .values
            .map((opt) => opt['value'])
            .contains(ans));
        selectedAnswers.add(value);
      }
    });
  }

  void _showResult() {
    var result = recommendStreamChat(selectedAnswers);
    String recommendedStream = result["recommended_stream"];
    Map<String, double> scores = Map<String, double>.from(result["scores"]);

    saveResultToRealtimeDB(recommendedStream, scores);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '🎯 Recommended Stream',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF8E2DE2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendedStream,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF8E2DE2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                result["explanation"],
                style: GoogleFonts.poppins(color: const Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E2DE2),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Explore This Stream',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetQuiz() {
    setState(() {
      currentStep = 0;
      selectedAnswers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            "No questions found in Firebase",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      );
    }

    final question = questions[currentStep];
    final isMultiple = question['type'] == 'multiple';

    return Scaffold(
    appBar: CustomAppBar(title: "Stream Selector"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Choose Your Academic Path',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Answer ${questions.length} questions to find the best stream for you.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 30),

              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currentStep + 1}/${questions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFF8E2DE2),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Container(
                      width: ((currentStep + 1) / questions.length) * 200,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E2DE2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Question Card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8E2DE2).withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          children: question['options'].entries.map<Widget>((entry) {
                            final option = entry.value;
                            bool isSelected =
                                selectedAnswers.contains(option['value']);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _selectOption(
                                    option['value'], question['type']),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF8E2DE2)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFFE5E7EB),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : (isMultiple
                                                ? Icons.circle_outlined
                                                : Icons.radio_button_unchecked),
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF8E2DE2),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option['text'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF2D3748),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _prevStep,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    label: Text('Back',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF8E2DE2).withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _nextStep,
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text('Next',
                        style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E2DE2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}