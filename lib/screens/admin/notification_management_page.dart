import 'package:aspire_edge/screens/admin/custom_appbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationManagementPage extends StatefulWidget {
  const NotificationManagementPage({super.key});

  @override
  State<NotificationManagementPage> createState() =>
      _NotificationManagementPageState();
}

class _NotificationManagementPageState
    extends State<NotificationManagementPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _db = FirebaseDatabase.instance.ref('notifications');

  static const String oneSignalAppId = "bfd0fb79-5c68-441e-b78d-063271b0d492";
  static const String restApiKey =
      "os_v2_app_x7ipw6k4nbcb5n4nayzhdmgusk3pnxuqkegekl4a2gqvbzirikhvv54pqjenys5hceswwosb5dsgeppg7bdvofkdtbtf27zg5f4etbq";

  void _sendNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) return;

    final newRef = _db.push();
    await newRef.set({
      'title': title,
      'body': body,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });

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
      appBar: CustomAppBar(title: "Notification Management"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Notification",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              style: const TextStyle(fontFamily: 'Poppins'),
              decoration: InputDecoration(
                labelText: "Title",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF8E2DE2), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              style: const TextStyle(fontFamily: 'Poppins'),
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Body",
                labelStyle: const TextStyle(fontFamily: 'Poppins'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF5B6CF1), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendNotification,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF8E2DE2),
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  elevation: 6,
                ),
                child: const Text(
                  "Send Notification",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
