import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreamSelectorPage extends StatefulWidget {
  const StreamSelectorPage({Key? key}) : super(key: key);

  @override
  State<StreamSelectorPage> createState() => _StreamSelectorPageState();
}

class _StreamSelectorPageState extends State<StreamSelectorPage> {
  int currentStep = 0;
  List<String> selectedInterests = []; // For Step 1 (multiple)
  String? selectedStrength; // For Step 2 (single)
  String? selectedGoal; // For Step 3 (single)

  final List<Map<String, dynamic>> questions = [
    {
      'title': 'What are you most interested in?',
      'options': [
        {'text': 'Science & Technology', 'value': 'science'},
        {'text': 'Business & Economics', 'value': 'commerce'},
        {'text': 'Arts & Literature', 'value': 'arts'},
        {'text': 'Skills & Hands-on Work', 'value': 'vocational'},
      ],
      'type': 'multiple',
    },
    {
      'title': 'Which subject do you find easiest?',
      'options': [
        {'text': 'Mathematics', 'value': 'math'},
        {'text': 'Science', 'value': 'science'},
        {'text': 'Social Studies', 'value': 'social'},
        {'text': 'Languages', 'value': 'language'},
      ],
      'type': 'single',
    },
    {
      'title': 'What kind of future do you dream of?',
      'options': [
        {'text': 'Engineer or Doctor', 'value': 'technical'},
        {'text': 'Business Owner or Accountant', 'value': 'business'},
        {'text': 'Writer, Artist, or Teacher', 'value': 'creative'},
        {'text': 'Skilled Worker or Technician', 'value': 'vocational'},
      ],
      'type': 'single',
    },
  ];

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
        if (selectedInterests.contains(value)) {
          selectedInterests.remove(value);
        } else {
          selectedInterests.add(value);
        }
      } else if (type == 'single') {
        if (currentStep == 1) {
          selectedStrength = value;
        } else if (currentStep == 2) {
          selectedGoal = value;
        }
      }
    });
  }

  void _showResult() {
    String recommendedStream = _getRecommendedStream();

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
              color: Color(0xFF2D3748),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF8E2DE2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  recommendedStream,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8E2DE2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Based on your interests, strengths, and goals, we suggest this path.',
                style: GoogleFonts.poppins(color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8E2DE2),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  String _getRecommendedStream() {
    if (selectedInterests.contains('science') ||
        selectedStrength == 'math' ||
        selectedStrength == 'science' ||
        selectedGoal == 'technical') {
      return 'Science (PCM/PCB)';
    } else if (selectedInterests.contains('commerce') || selectedGoal == 'business') {
      return 'Commerce';
    } else if (selectedInterests.contains('arts') || selectedGoal == 'creative') {
      return 'Arts & Humanities';
    } else if (selectedInterests.contains('vocational') || selectedGoal == 'vocational') {
      return 'Vocational / Technical';
    } else {
      return 'Explore All Streams';
    }
  }

  void _resetQuiz() {
    setState(() {
      currentStep = 0;
      selectedInterests.clear();
      selectedStrength = null;
      selectedGoal = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentStep];
    final isMultiple = question['type'] == 'multiple';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF8E2DE2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Stream Selector',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Choose Your Academic Path',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Answer a few quick questions to find the best stream for you.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 30),

              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${currentStep + 1}/${questions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Color(0xFF8E2DE2),
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
                        color: Color(0xFF8E2DE2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Question Card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF8E2DE2).withOpacity(0.1),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: question['options'].length,
                          itemBuilder: (context, index) {
                            final option = question['options'][index];
                            bool isSelected;

                            if (isMultiple) {
                              isSelected = selectedInterests.contains(option['value']);
                            } else {
                              if (currentStep == 1) {
                                isSelected = selectedStrength == option['value'];
                              } else {
                                isSelected = selectedGoal == option['value'];
                              }
                            }

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () => _selectOption(option['value'], question['type']),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xFF8E2DE2)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected ? Colors.white : Color(0xFFE5E7EB),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.check_circle
                                            : (isMultiple ? Icons.circle_outlined : Icons.radio_button_unchecked),
                                        color: isSelected ? Colors.white : Color(0xFF8E2DE2),
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option['text'],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: isSelected ? Colors.white : Color(0xFF2D3748),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: _prevStep,
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    label: Text('Back', style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8E2DE2).withOpacity(0.8),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _nextStep,
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                    label: Text('Next', style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8E2DE2),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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