import 'package:flutter/material.dart';

class PushNotification {
  String title;
  String message;
  DateTime date;
  bool isActive;

  PushNotification({
    required this.title,
    required this.message,
    required this.date,
    this.isActive = true,
  });
}

class ManagePushNotificationsPage extends StatefulWidget {
  const ManagePushNotificationsPage({super.key});

  @override
  State<ManagePushNotificationsPage> createState() =>
      _ManagePushNotificationsPageState();
}

class _ManagePushNotificationsPageState
    extends State<ManagePushNotificationsPage> {
  final List<PushNotification> notifications = [
    PushNotification(
      title: "System Update",
      message: "A new system update will occur tonight at 2 AM.",
      date: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PushNotification(
      title: "Special Offer",
      message: "Get 20% off on premium plans this week!",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _openNotificationDialog({PushNotification? existing, int? index}) {
    final titleController =
        TextEditingController(text: existing?.title ?? "");
    final messageController =
        TextEditingController(text: existing?.message ?? "");
    bool isActive = existing?.isActive ?? true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          existing == null ? "Add Notification" : "Edit Notification",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D455B),
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text("Active"),
                  value: isActive,
                  onChanged: (val) => setState(() => isActive = val),
                  activeColor: const Color(0xFF3D455B),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child:
                const Text("Cancel", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D455B),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              final newNotification = PushNotification(
                title: titleController.text.isEmpty
                    ? "Untitled"
                    : titleController.text,
                message: messageController.text.isEmpty
                    ? "No message"
                    : messageController.text,
                date: DateTime.now(),
                isActive: isActive,
              );

              setState(() {
                if (existing == null) {
                  notifications.add(newNotification);
                } else {
                  notifications[index!] = newNotification;
                }
              });

              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNotification(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Notification"),
        content:
            const Text("Are you sure you want to delete this notification?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() => notifications.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(PushNotification n, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                n.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF3D455B),
                ),
              ),
              Text(
                "${n.date.day}/${n.date.month}/${n.date.year}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            n.message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),

          // Status + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("Status: ",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(
                    n.isActive ? "Active" : "Inactive",
                    style: TextStyle(
                      color: n.isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        _openNotificationDialog(existing: n, index: index),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text("Edit"),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => _deleteNotification(index),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.notifications_none,
              size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text("No notifications yet",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Manage Feedback", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3D455B),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Add button top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openNotificationDialog(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Add Notification",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D455B),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ),
          ),

          // List of notifications
          Expanded(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) =>
                        _buildNotificationCard(notifications[index], index),
                  ),
          ),
        ],
      ),
    );
  }
}
