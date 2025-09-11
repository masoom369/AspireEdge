import 'package:flutter/material.dart';

class FeedbackItem {
  final String userName;
  final String feedbackText;
  final DateTime date;
  bool resolved;
  String? response;

  FeedbackItem({
    required this.userName,
    required this.feedbackText,
    required this.date,
    this.resolved = false,
    this.response,
  });
}

class ManageFeedbackPage extends StatefulWidget {
  const ManageFeedbackPage({super.key});

  @override
  State<ManageFeedbackPage> createState() => _ManageFeedbackPageState();
}

class _ManageFeedbackPageState extends State<ManageFeedbackPage> {
  final List<FeedbackItem> feedbackList = [
    FeedbackItem(
      userName: "Ali Khan",
      feedbackText: "Great app, but could use dark mode.",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    FeedbackItem(
      userName: "Sara Ahmed",
      feedbackText: "I found a bug in quiz section.",
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    FeedbackItem(
      userName: "John Doe",
      feedbackText: "Loving the smooth UI. Keep it up!",
      date: DateTime.now().subtract(const Duration(days: 5)),
      resolved: true,
      response: "Thank you John for your kind words!",
    ),
  ];

  void _respondToFeedback(FeedbackItem item) {
    final responseController = TextEditingController(text: item.response);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Respond to Feedback",
          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3D455B)),
        ),
        content: TextField(
          controller: responseController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "Type your response here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("Cancel", style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D455B),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            onPressed: () {
              setState(() {
                item.response = responseController.text;
                item.resolved = true;
              });
              Navigator.pop(context);
            },
            child: const Text("Send", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleResolved(FeedbackItem item) {
    setState(() => item.resolved = !item.resolved);
  }

  Widget _buildFeedbackCard(FeedbackItem item) {
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
          // User + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF3D455B),
                ),
              ),
              Text(
                "${item.date.day}/${item.date.month}/${item.date.year}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Feedback text
          Text(
            item.feedbackText,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          if (item.response != null && item.response!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.reply, size: 18, color: Color(0xFF3D455B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.response!,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF3D455B)),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _respondToFeedback(item),
                icon: const Icon(Icons.reply, color: Color(0xFF3D455B)),
                label: const Text("Respond", style: TextStyle(color: Color(0xFF3D455B))),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _toggleResolved(item),
                icon: Icon(
                  item.resolved ? Icons.check_circle : Icons.pending,
                  color: item.resolved ? Colors.green : Colors.grey.shade700,
                ),
                label: Text(item.resolved ? "Resolved" : "Mark Resolved"),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: item.resolved ? Colors.green : Colors.grey.shade400),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  foregroundColor: item.resolved ? Colors.green : Colors.grey.shade700,
                ),
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
          Icon(Icons.feedback_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text(
            "No feedback available",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
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
      body: feedbackList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: feedbackList.length,
              itemBuilder: (context, index) => _buildFeedbackCard(feedbackList[index]),
            ),
    );
  }
}
