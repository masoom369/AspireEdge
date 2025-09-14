
import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CareerGuidancePage extends StatefulWidget {
  const CareerGuidancePage({super.key});

  @override
  State<CareerGuidancePage> createState() => _CareerGuidancePageState();
}

class _CareerGuidancePageState extends State<CareerGuidancePage> {
  int currentQuestionIndex = 0;
  late List<String?> answers;
  bool isSaving = false;

  List<Map<String, dynamic>> questions = [];

  final List<String> careerPaths = [
    "Engineering & Technology",
    "Medical & Healthcare",
    "Business & Management",
    "Arts & Media",
    "Skilled Trades / Vocational",
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final ref = FirebaseDatabase.instance.ref("career_questions");
    final snapshot = await ref.get();
    if (snapshot.exists && snapshot.value != null) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      final loadedQuestions = data.entries.map((e) {
        final q = Map<String, dynamic>.from(e.value);


        Map<String, dynamic> optsMap = {};
        if (q["options"] is Map) {
          optsMap = Map<String, dynamic>.from(q["options"]);
        } else if (q["options"] is List) {

          final list = q["options"] as List;
          for (int i = 0; i < list.length; i++) {
            optsMap[i.toString()] = list[i];
          }
        }

        final optsList = optsMap.entries.map((entry) {
          final opt = Map<String, dynamic>.from(entry.value);
          return {
            "text": opt["text"] ?? "",
            "value": opt["value"] ?? "",
          };
        }).toList();

        return {
          "id": e.key,
          "title": q["title"] ?? "",
          "options": optsList,
        };
      }).toList();

      setState(() {
        questions = loadedQuestions;
        answers = List<String?>.filled(questions.length, null);
      });
    }
  }

  Future<User?> _ensureUser() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) return user;
    try {
      final cred = await FirebaseAuth.instance.signInAnonymously();
      return cred.user;
    } catch (_) {
      return null;
    }
  }

  void _selectOption(String value) {
    setState(() {
      answers[currentQuestionIndex] = value;
    });
  }

  void _previous() {
    if (currentQuestionIndex == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() => currentQuestionIndex--);
  }

  void _next() {
    if (answers[currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an option to continue.")));
      return;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() => currentQuestionIndex++);
    } else {
      _submit();
    }
  }

  Map<String, int> _calculateScores() {
    final Map<String, int> scores = {for (var p in careerPaths) p: 0};
    for (final a in answers) {
      if (a != null && scores.containsKey(a)) {
        scores[a] = scores[a]! + 1;
      }
    }
    return scores;
  }

  String _getRecommendedCareer(Map<String, int> scores) {
    String best = careerPaths.first;
    int max = -1;
    scores.forEach((k, v) {
      if (v > max) {
        max = v;
        best = k;
      }
    });
    return best;
  }

  Future<void> _submit() async {
    if (answers.any((a) => a == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please answer all questions.")));
      return;
    }

    setState(() => isSaving = true);
    final scores = _calculateScores();
    final recommended = _getRecommendedCareer(scores);

    final user = await _ensureUser();
    if (user == null) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Unable to sign in. Check network / Firebase setup.")));
      return;
    }

    try {
      final ref = FirebaseDatabase.instance.ref('career_results/${user.uid}');
      await ref.push().set({
        'career_path': recommended,
        'scores': scores.entries
            .map((e) => {'path': e.key, 'score': e.value})
            .toList(),
        'answers': answers,
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() => isSaving = false);
      _showResultDialog(recommended);
    } catch (e) {
      setState(() => isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save result: $e")));
    }
  }

  void _showResultDialog(String recommended) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text('🎯 Recommended Career Path',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF8E2DE2).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(recommended,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8E2DE2))),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Close',
                  style:
                      TextStyle(fontFamily: 'Poppins', color: const Color(0xFF8E2DE2))),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    final question = questions[currentQuestionIndex];
    final selectedValue = answers[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
         appBar: CustomAppBar(title: "Career Guidance"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(question['title'],
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: (question['options'] as List).length,
                  itemBuilder: (context, index) {
                    final opt = (question['options'] as List)[index];
                    final value = opt['value'] as String;
                    final text = opt['text'] as String;
                    final isSelected = selectedValue == value;

                    return InkWell(
                      onTap: () => _selectOption(value),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF8E2DE2)
                              : Colors.white,
                          border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black87),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: _previous, child: const Text("Back")),
                  ElevatedButton(
                      onPressed: (answers[currentQuestionIndex] != null &&
                              !isSaving)
                          ? _next
                          : null,
                      child: Text(currentQuestionIndex < questions.length - 1
                          ? "Next"
                          : "Submit")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

