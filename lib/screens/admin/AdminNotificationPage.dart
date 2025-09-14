import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  State<AdminNotificationPage> createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _db = FirebaseDatabase.instance.ref('notifications');

  // ⚠️ Keys (do not expose in production apps, better keep in backend)
  static const String oneSignalAppId = "bfd0fb79-5c68-441e-b78d-063271b0d492";
  static const String restApiKey =
      "os_v2_app_x7ipw6k4nbcb5n4nayzhdmgusk3pnxuqkegekl4a2gqvbzirikhvv54pqjenys5hceswwosb5dsgeppg7bdvofkdtbtf27zg5f4etbq";

  void _sendNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) return;

    // ✅ Save notification to Firebase
    final newRef = _db.push();
    await newRef.set({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

    // ✅ Send push notification via OneSignal
    final url = Uri.parse('https://onesignal.com/api/v1/notifications');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $restApiKey',
      },
      body: jsonEncode({
        'app_id': oneSignalAppId,
        'included_segments': ['All'], // sends to all subscribed users
        'headings': {'en': title},
        'contents': {'en': body},
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Notification sent successfully!")),
      );
      _titleController.clear();
      _bodyController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Failed: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Notifications")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: "Body"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendNotification,
              child: const Text("Send Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
