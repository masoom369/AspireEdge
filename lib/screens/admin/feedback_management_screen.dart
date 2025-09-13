import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../models/feedback.dart';
import '../../services/feedback_dao.dart';

class ManageFeedbackPage extends StatefulWidget {
  const ManageFeedbackPage({super.key});

  @override
  State<ManageFeedbackPage> createState() => _ManageFeedbackPageState();
}

class _ManageFeedbackPageState extends State<ManageFeedbackPage>
    with SingleTickerProviderStateMixin {
  final FeedbackDao _feedbackDao = FeedbackDao();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage User Feedbacks",
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3D455B),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Pending"),
            Tab(text: "Resolved"),
          ],
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _feedbackDao.getFeedbackList().onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
                child: Text("Error loading feedbacks",
                    style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return _buildEmptyState();
          }

          final data =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          final feedbacks = data.entries
              .map((entry) =>
                  FeedbackModel.fromJson(Map<String, dynamic>.from(entry.value)))
              .toList()
            ..sort((a, b) => b.id.compareTo(a.id));

          // Separate pending and resolved feedbacks
          final pendingFeedbacks =
              feedbacks.where((f) => f.status != "resolved").toList();
          final resolvedFeedbacks =
              feedbacks.where((f) => f.status == "resolved").toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildFeedbackList(pendingFeedbacks),
              _buildFeedbackList(resolvedFeedbacks),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFeedbackList(List<FeedbackModel> feedbacks) {
    if (feedbacks.isEmpty) return _buildEmptyState();

    return ListView.builder(
      itemCount: feedbacks.length,
      itemBuilder: (context, index) {
        final item = feedbacks[index];
        return _buildFeedbackCard(item);
      },
    );
  }

  Widget _buildFeedbackCard(FeedbackModel item) {
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
          // Name + Email
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF3D455B),
                ),
              ),
              Text(
                item.email,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Subject
          Text(
            "Subject: ${item.subject}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),

          // Inquiry Type
          Text("Inquiry: ${item.inquiryType}",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),

          const SizedBox(height: 10),

          // Message
          Text(
            item.message,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),

          const SizedBox(height: 10),

          // Status
          Row(
            children: [
              const Text(
                "Status: ",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              Text(
                item.status == "resolved" ? "Resolved" : "Pending",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: item.status == "resolved"
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Admin Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (item.status != "resolved") ...[
                TextButton.icon(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  label: const Text("Mark Resolved"),
                  onPressed: () => _markAsResolved(item.id),
                ),
                const SizedBox(width: 8),
              ],
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text("Delete"),
                onPressed: () => _deleteFeedback(item.id),
              ),
            ],
          )
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

  void _markAsResolved(String id) async {
    await _feedbackDao.updateFeedback(id, {"status": "resolved"});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Feedback marked as resolved")),
    );
    setState(() {}); // refresh tabs automatically
  }

  void _deleteFeedback(String id) async {
     _feedbackDao.deleteFeedback(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Feedback deleted")),
    );
    setState(() {}); // refresh tabs automatically
  }
}