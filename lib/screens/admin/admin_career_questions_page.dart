import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AdminCareerQuestionsPage extends StatefulWidget {
  const AdminCareerQuestionsPage({super.key});

  @override
  State<AdminCareerQuestionsPage> createState() =>
      _AdminCareerQuestionsPageState();
}

class _AdminCareerQuestionsPageState extends State<AdminCareerQuestionsPage> {
  final DatabaseReference _ref =
      FirebaseDatabase.instance.ref("career_questions");

  Future<void> _addQuestion() async {
    final snapshot = await _ref.get();
    if (snapshot.exists && snapshot.value != null) {
      final count = (snapshot.value as Map).length;
      if (count >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You can only add up to 10 questions."),
        ));
        return;
      }
    }

    final newRef = _ref.push();
    await newRef.set({
      "title": "Untitled Question",
      "options": {
        "0": {"text": "Option 1", "value": "Engineering & Technology"},
        "1": {"text": "Option 2", "value": "Medical & Healthcare"},
      }
    });
  }

  Future<void> _saveQuestionTitle(String id, String title) async {
    if (title.trim().isEmpty) return;
    await _ref.child(id).update({"title": title});
  }

  Future<void> _deleteQuestion(String id) async {
    await _ref.child(id).remove();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Question deleted")),
    );
  }

  Future<void> _addOption(String questionId) async {
    final snap = await _ref.child(questionId).child("options").get();
    Map<String, dynamic> options = {};

    if (snap.exists && snap.value != null) {
      if (snap.value is Map) {
        options = Map<String, dynamic>.from(snap.value as Map);
      } else if (snap.value is List) {
        final list = snap.value as List;
        for (int i = 0; i < list.length; i++) {
          if (list[i] != null) {
            options[i.toString()] = list[i];
          }
        }
      }
    }

    final newIndex = options.length.toString();
    options[newIndex] = {
      "text": "New Option",
      "value": "Engineering & Technology"
    };

    await _ref.child(questionId).child("options").set(options);
  }

  Future<void> _saveOption(
      String questionId, String optionKey, String text, String value) async {
    await _ref
        .child(questionId)
        .child("options")
        .child(optionKey)
        .set({"text": text, "value": value});
  }

  Future<void> _deleteOption(String questionId, String optionKey) async {
    await _ref.child(questionId).child("options").child(optionKey).remove();
  }

  Widget _buildStyledTextField(
      TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Poppins'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Poppins'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8E2DE2), width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Career Questions Management"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Add Question",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E2DE2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Colors.deepPurple.withOpacity(0.2),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<DatabaseEvent>(
              stream: _ref.onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.snapshot.value == null) {
                  return const Center(
                    child: Text(
                      "No questions added yet",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final rawValue = snapshot.data!.snapshot.value;

                Map<String, dynamic> data;
                try {
                  if (rawValue is Map) {
                    data = Map<String, dynamic>.from(
                        rawValue as Map<Object?, Object?>);
                  } else {
                    throw Exception("Invalid data format");
                  }
                } catch (e) {
                  return Center(child: Text("Error loading data: $e"));
                }

                final questions = data.entries.map((e) {
                  final q = e.value;
                  String title = "Untitled";
                  Map<String, dynamic> options = {};

                  if (q is Map) {
                    title = (q['title'] ?? "Untitled").toString();
                    final opt = q['options'];
                    if (opt is Map) {
                      options = Map<String, dynamic>.from(
                          opt as Map<Object?, Object?>);
                    } else if (opt is List) {
                      for (int i = 0; i < opt.length; i++) {
                        if (opt[i] != null) {
                          options[i.toString()] = opt[i];
                        }
                      }
                    }
                  }

                  return {
                    "id": e.key,
                    "title": title,
                    "options": options,
                  };
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    final options =
                        Map<String, dynamic>.from(q["options"] as Map);

                    final titleController =
                        TextEditingController(text: q["title"].toString());

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStyledTextField(
                                      titleController, "Question Title"),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.save,
                                      color: Color(0xFF5B6CF1)),
                                  onPressed: () => _saveQuestionTitle(
                                      q["id"].toString(),
                                      titleController.text.trim()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      _deleteQuestion(q["id"].toString()),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: options.entries.map((entry) {
                                final optionKey = entry.key.toString();
                                final opt = entry.value as Map;
                                final text =
                                    (opt['text'] ?? "Unknown").toString();
                                final value =
                                    (opt['value'] ?? "Unknown").toString();

                                final textController =
                                    TextEditingController(text: text);
                                final valueController =
                                    TextEditingController(text: value);

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildStyledTextField(
                                            textController, "Option Text"),
                                        const SizedBox(height: 8),
                                        _buildStyledTextField(
                                            valueController, "Career Path Value"),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.save,
                                                  color: Color(0xFF5B6CF1)),
                                              onPressed: () => _saveOption(
                                                  q["id"].toString(),
                                                  optionKey,
                                                  textController.text.trim(),
                                                  valueController.text.trim()),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.redAccent),
                                              onPressed: () => _deleteOption(
                                                  q["id"].toString(),
                                                  optionKey),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _addOption(q["id"].toString()),
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text(
                                  "Add Option",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8E2DE2),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
