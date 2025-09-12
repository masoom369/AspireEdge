import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4B0082), // Purple
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              tooltip: "Logout",
              onPressed: _logout,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
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
