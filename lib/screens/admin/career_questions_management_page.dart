
import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CareerQuestionsPage extends StatefulWidget {
  const CareerQuestionsPage({super.key});

  @override
  State<CareerQuestionsPage> createState() =>
      _CareerQuestionsPageState();
}

class _CareerQuestionsPageState extends State<CareerQuestionsPage> {
  final DatabaseReference _ref =
      FirebaseDatabase.instance.ref("career_questions");

  Future<void> _saveQuestionTitle(String id, String title) async {
    if (title.trim().isEmpty) return;
    await _ref.child(id).update({"title": title});
  }


  Future<void> _deleteQuestion(String id) async {
    await _ref.child(id).remove();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: CustomAppBar(title:"Career Questions Management"),
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

