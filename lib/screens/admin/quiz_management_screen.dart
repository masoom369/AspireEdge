import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/material.dart';

class QuizQuestion {
  String question;
  List<String> options;
  int correctAnswerIndex;
  int score;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.score,
  });
}

class ManageQuizPage extends StatefulWidget {
  @override
  _ManageQuizPageState createState() => _ManageQuizPageState();
}

class _ManageQuizPageState extends State<ManageQuizPage> {
  List<QuizQuestion> quizQuestions = [
    QuizQuestion(
      question: "What is Flutter?",
      options: ["Framework", "Library", "Language", "IDE"],
      correctAnswerIndex: 0,
      score: 10,
    ),
  ];

  void _openQuestionDialog({QuizQuestion? question, int? index}) {
    final questionController = TextEditingController(text: question?.question ?? "");
    final optionControllers = List.generate(
      4,
      (i) => TextEditingController(
        text: question != null && i < question.options.length ? question.options[i] : "",
      ),
    );
    final scoreController =
        TextEditingController(text: question?.score.toString() ?? "10");

    int correctIndex = question?.correctAnswerIndex ?? 0;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            question == null ? "Add Question" : "Edit Question",
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D455B)),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(questionController, "Question"),
                SizedBox(height: 12),
                ...List.generate(4, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(child: _buildTextField(optionControllers[i], "Option ${i + 1}")),
                        Radio<int>(
                          value: i,
                          groupValue: correctIndex,
                          onChanged: (value) {
                            setDialogState(() {
                              correctIndex = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 12),
                _buildTextField(scoreController, "Score", keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[700])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3D455B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final newQuestion = QuizQuestion(
                  question: questionController.text,
                  options: optionControllers.map((c) => c.text).toList(),
                  correctAnswerIndex: correctIndex,
                  score: int.tryParse(scoreController.text) ?? 10,
                );

                setState(() {
                  if (question == null) {
                    quizQuestions.add(newQuestion);
                  } else {
                    quizQuestions[index!] = newQuestion;
                  }
                });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _deleteQuestion(int index) {
    setState(() {
      quizQuestions.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
            appBar: CustomAppBar(title:"Quiz Management"),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openQuestionDialog(),
                icon: Icon(Icons.add),
                label: Text("Add Question"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3D455B),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: quizQuestions.length,
              itemBuilder: (context, index) {
                final q = quizQuestions[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(q.question,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF3D455B))),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: q.options
                              .asMap()
                              .entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          entry.key == q.correctAnswerIndex
                                              ? Icons.check_circle
                                              : Icons.circle_outlined,
                                          color: entry.key == q.correctAnswerIndex
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 18,
                                        ),
                                        SizedBox(width: 8),
                                        Text(entry.value),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 8),
                        Text("Score: ${q.score}", style: TextStyle(color: Colors.black87)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () => _openQuestionDialog(question: q, index: index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteQuestion(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

