// admin_career_questions_page.dart
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

  /// Add a new blank question
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

  /// Save edited question title
  Future<void> _saveQuestionTitle(String id, String title) async {
    if (title.trim().isEmpty) return;
    await _ref.child(id).update({"title": title});
  }

  /// Delete a whole question
  Future<void> _deleteQuestion(String id) async {
    await _ref.child(id).remove();
  }

  /// Add new option
  Future<void> _addOption(String questionId) async {
    final snap = await _ref.child(questionId).child("options").get();
    Map<String, dynamic> options = {};

    if (snap.exists && snap.value != null) {
      if (snap.value is Map) {
        options = Map<String, dynamic>.from(snap.value as Map);
      } else if (snap.value is List) {
        final list = snap.value as List;
        for (int i = 0; i < list.length; i++) {
          options[i.toString()] = list[i];
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

  /// Save option changes
  Future<void> _saveOption(
      String questionId, String optionKey, String text, String value) async {
    await _ref
        .child(questionId)
        .child("options")
        .child(optionKey)
        .set({"text": text, "value": value});
  }

  /// Delete option
  Future<void> _deleteOption(String questionId, String optionKey) async {
    await _ref.child(questionId).child("options").child(optionKey).remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Career Questions"),
        actions: [
          ElevatedButton.icon(
            onPressed: _addQuestion,
            icon: const Icon(Icons.add),
            label: const Text("Add Question"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _ref.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No questions added yet"));
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
                  options[i.toString()] = opt[i];
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
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final options =
                  Map<String, dynamic>.from(q["options"] as Map);

              final titleController =
                  TextEditingController(text: q["title"].toString());

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Title
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: "Question Title",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _saveQuestionTitle(
                                q["id"].toString(),
                                titleController.text.trim()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text("Save"),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteQuestion(q["id"].toString()),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Options
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

                          return ListTile(
                            title: TextField(
                              controller: textController,
                              decoration: const InputDecoration(
                                labelText: "Option Text",
                              ),
                            ),
                            subtitle: TextField(
                              controller: valueController,
                              decoration: const InputDecoration(
                                labelText: "Career Path Value",
                              ),
                            ),
                            trailing: Wrap(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.save,
                                      color: Colors.green),
                                  onPressed: () => _saveOption(
                                      q["id"].toString(),
                                      optionKey,
                                      textController.text.trim(),
                                      valueController.text.trim()),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _deleteOption(
                                      q["id"].toString(), optionKey),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      // Add Option Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => _addOption(q["id"].toString()),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Option"),
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
    );
  }
}
