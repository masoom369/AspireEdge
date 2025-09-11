import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CareerGuidancePage extends StatefulWidget {
  const CareerGuidancePage({Key? key}) : super(key: key);

  @override
  State<CareerGuidancePage> createState() => _CareerGuidancePageState();
}

class _CareerGuidancePageState extends State<CareerGuidancePage> {
  int currentStep = 0;
  List<String> selectedInterests = []; // For Step 1 (multiple)
  List<String> selectedStrengths = []; // For Step 2 (multiple)
  List<String> selectedGoals = []; // For Step 3 (multiple)

  final List<Map<String, dynamic>> questions = [
    {
      'title': 'What is your primary field of interest?',
      'options': [
        {'text': 'Science & Technology', 'value': 'science'},
        {'text': 'Business & Economics', 'value': 'commerce'},
        {'text': 'Arts & Literature', 'value': 'arts'},
        {'text': 'Skilled Professions & Vocational Work', 'value': 'vocational'},
      ],
      'type': 'multiple',
    },
    {
      'title': 'Which of the following best describes your strengths?',
      'options': [
        {'text': 'Problem Solving & Analytical Thinking', 'value': 'technical'},
        {'text': 'Leadership & Decision Making', 'value': 'business'},
        {'text': 'Creativity & Artistic Expression', 'value': 'creative'},
        {'text': 'Hands-On & Practical Work', 'value': 'vocational'},
      ],
      'type': 'multiple',
    },
    {
      'title': 'What type of career would you like to pursue?',
      'options': [
        {'text': 'Engineer, Doctor, or Researcher', 'value': 'technical'},
        {'text': 'Business Owner, Manager, or Consultant', 'value': 'business'},
        {'text': 'Artist, Designer, or Teacher', 'value': 'creative'},
        {'text': 'Skilled Worker, Mechanic, or Technician', 'value': 'vocational'},
      ],
      'type': 'multiple',
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
        // Handle multiple selections by toggling the selection
        if (currentStep == 0) {
          if (selectedInterests.contains(value)) {
            selectedInterests.remove(value);
          } else {
            selectedInterests.add(value);
          }
        } else if (currentStep == 1) {
          if (selectedStrengths.contains(value)) {
            selectedStrengths.remove(value);
          } else {
            selectedStrengths.add(value);
          }
        } else if (currentStep == 2) {
          if (selectedGoals.contains(value)) {
            selectedGoals.remove(value);
          } else {
            selectedGoals.add(value);
          }
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
            '🎯 Recommended Career Path',
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
                  'Explore This Path',
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
        selectedStrengths.contains('technical') ||
        selectedGoals.contains('technical')) {
      return 'Science or Engineering';
    } else if (selectedInterests.contains('commerce') ||
        selectedGoals.contains('business')) {
      return 'Business & Economics';
    } else if (selectedInterests.contains('arts') ||
        selectedGoals.contains('creative')) {
      return 'Arts & Literature';
    } else if (selectedInterests.contains('vocational') ||
        selectedGoals.contains('vocational')) {
      return 'Vocational Careers';
    } else {
      return 'Explore Various Fields';
    }
  }

  void _resetQuiz() {
    setState(() {
      currentStep = 0;
      selectedInterests.clear();
      selectedStrengths.clear();
      selectedGoals.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentStep];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF8E2DE2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Career Path Selector',
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
                'Find the Best Career Path for You',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Answer these questions to help guide your future career.',
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
                            bool isSelected = currentStep == 0
                                ? selectedInterests.contains(option['value'])
                                : currentStep == 1
                                    ? selectedStrengths.contains(option['value'])
                                    : selectedGoals.contains(option['value']);

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
                                            : Icons.radio_button_unchecked,
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
