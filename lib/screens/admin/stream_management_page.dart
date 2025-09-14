import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StreamManagementPage extends StatefulWidget {
  const StreamManagementPage({super.key});

  @override
  State<StreamManagementPage> createState() => _StreamManagementPageState();
}

class _StreamManagementPageState extends State<StreamManagementPage> {
  final DatabaseReference _ref =
      FirebaseDatabase.instance.ref("stream_questions");

  void _addQuestion() {
    final newRef = _ref.push();
    newRef.set({
      "title": "Untitled Question",
      "type": "single",
      "options": {
        "0": {"text": "Option 1", "value": "science"},
        "1": {"text": "Option 2", "value": "commerce"},
      }
    });
  }

  void _editQuestionTitle(String id, String title) {
    _ref.child(id).update({"title": title});
  }

  void _editQuestionType(String id, String type) {
    _ref.child(id).update({"type": type});
  }

  void _deleteQuestion(String id) {
    _ref.child(id).remove();
  }

  Future<void> _addOption(String questionId) async {
    final snap = await _ref.child(questionId).child("options").get();
    Map<String, dynamic> options = {};

    if (snap.exists && snap.value != null) {
      if (snap.value is List) {
        final list = List.from(snap.value as List);
        for (int i = 0; i < list.length; i++) {
          if (list[i] != null) {
            options[i.toString()] = Map<String, dynamic>.from(list[i]);
          }
        }
      } else {
        options = Map<String, dynamic>.from(snap.value as Map);
      }
    }

    final newIndex = options.length.toString();
    options[newIndex] = {"text": "New Option", "value": "science"};

    await _ref.child(questionId).child("options").set(options);
  }

  Future<void> _editOption(
      String questionId, String optionKey, String newText, String newValue) async {
    await _ref
        .child(questionId)
        .child("options")
        .child(optionKey)
        .set({"text": newText, "value": newValue});
  }

  Future<void> _deleteOption(String questionId, String optionKey) async {
    await _ref.child(questionId).child("options").child(optionKey).remove();
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF8E2DE2); // same purple theme

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Stream Management"),
      body: StreamBuilder<DatabaseEvent>(
        stream: _ref.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(
              child: Text(
                "No questions added yet",
                style: TextStyle(fontFamily: "Poppins"),
              ),
            );
          }

          final Object? val = snapshot.data!.snapshot.value;
          Map<String, dynamic> rawValue = {};

          if (val is List) {
            for (int i = 0; i < val.length; i++) {
              if (val[i] != null) {
                rawValue[i.toString()] = Map<String, dynamic>.from(val[i]);
              }
            }
          } else if (val is Map) {
            rawValue = Map<String, dynamic>.from(val);
          }

          final questions = rawValue.entries.map((e) {
            final q = Map<String, dynamic>.from(e.value);
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
            return {
              "id": e.key,
              "title": q['title'],
              "type": q['type'] ?? "single",
              "options": options,
            };
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final q = questions[index];
              final options = q["options"] as Map<String, dynamic>;

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
                      TextFormField(
                        initialValue: q["title"],
                        decoration: const InputDecoration(
                          labelText: "Question Title",
                          border: OutlineInputBorder(),
                        ),
                        onFieldSubmitted: (v) {
                          if (v.trim().isNotEmpty) {
                            _editQuestionTitle(q["id"], v.trim());
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: q["type"],
                        decoration: const InputDecoration(
                          labelText: "Question Type",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: "single", child: Text("Single Choice")),
                          DropdownMenuItem(
                              value: "multiple", child: Text("Multiple Choice")),
                        ],
                        onChanged: (val) {
                          if (val != null) _editQuestionType(q["id"], val);
                        },
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: options.entries.map((entry) {
                          final optionKey = entry.key;
                          final opt = Map<String, dynamic>.from(entry.value);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue: opt['text'],
                                    decoration: const InputDecoration(
                                      labelText: "Option Text",
                                      border: OutlineInputBorder(),
                                    ),
                                    onFieldSubmitted: (v) {
                                      _editOption(
                                          q["id"], optionKey, v.trim(), opt['value']);
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    initialValue: opt['value'],
                                    decoration: const InputDecoration(
                                      labelText: "Option Value",
                                      border: OutlineInputBorder(),
                                    ),
                                    onFieldSubmitted: (v) {
                                      _editOption(
                                          q["id"], optionKey, opt['text'], v.trim());
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      onPressed: () =>
                                          _deleteOption(q["id"], optionKey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _addOption(q["id"]),
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Add Option",
                            style: TextStyle(fontFamily: "Poppins"),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteQuestion(q["id"]),
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

      // Floating button styled same as career page
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Add Question"),
        onPressed: _addQuestion,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // bottom navigation bar styled
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: 'Video'),
        ],
        currentIndex: 0,
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
