import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';

class UserNotificationPage extends StatefulWidget {
  const UserNotificationPage({super.key});

  @override
  State<UserNotificationPage> createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  List<Map<String, String>> notifications = [
    {
      "title": "Admission Approved",
      "description": "Your admission has been approved successfully!"
    },
    {
      "title": "Document Reminder",
      "description": "Please upload your ID proof before the deadline."
    },
    {
      "title": "Fee Payment",
      "description": "Your payment receipt has been received and verified."
    },
  ];

  void _logout() {
    // Here you can clear session, tokens, or navigate to login screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logged out successfully"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:CustomAppBar(
        title: "Notification Center",
    
     
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: const Color(0xFF1B263B), // Dark card
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 24,
                child: Icon(
                  Icons.notifications,
                  color: Colors.purple.shade700,
                  size: 28,
                ),
              ),
              title: Text(
                notification["title"]!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                notification["description"]!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade300,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                onPressed: () {
                  setState(() {
                    notifications.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Notification removed"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
