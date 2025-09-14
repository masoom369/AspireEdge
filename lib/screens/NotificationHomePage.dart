import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({super.key});

  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  final _db = FirebaseDatabase.instance.ref('notifications');
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();

    // ✅ Listen to Firebase notifications in realtime
    _db.onChildAdded.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      setState(() {
        notifications.insert(0, data);
      });

      // ❌ No local postNotification in new SDK
      // Instead, you would trigger push from your server/OneSignal dashboard
      // Here we just log or show in-app
      debugPrint("📩 Firebase notification: ${data['title']} - ${data['body']}");
    });

    // ✅ Listen to foreground OneSignal notifications
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault(); // stop auto-display
      event.notification.display(); // manually display

      final notif = {
        'title': event.notification.title ?? 'No Title',
        'body': event.notification.body ?? 'No Body',
      };

      setState(() {
        notifications.insert(0, notif);
      });
    });

    // ✅ Notification clicked
    OneSignal.Notifications.addClickListener((event) {
      debugPrint("👉 Notification opened: ${event.notification.jsonRepresentation()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: Column(
        children: [
          Expanded(
            child: notifications.isEmpty
                ? const Center(child: Text("No notifications yet"))
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return ListTile(
                        title: Text(item['title']),
                        subtitle: Text(item['body']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
