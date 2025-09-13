import 'package:firebase_database/firebase_database.dart';
import '../models/feedback.dart';

class FeedbackDao {
  final _databaseRef = FirebaseDatabase.instance.ref("feedbacks");

  FeedbackDao();

  /// Save new feedback
  void saveFeedback(FeedbackModel feedback) {
    final newRef = _databaseRef.push();
    feedback = FeedbackModel(
      id: newRef.key!,
      userId: feedback.userId,
      name: feedback.name,
      email: feedback.email,
      subject: feedback.subject,
      inquiryType: feedback.inquiryType,
      message: feedback.message,
      status: feedback.status,
      reply: feedback.reply,
    );
    newRef.set(feedback.toJson());
  }

  /// Get all feedbacks
  Query getFeedbackList() {
    return _databaseRef;
  }

  /// Delete feedback by key
  void deleteFeedback(String key) {
    _databaseRef.child(key).remove();
  }

  /// Update feedback (partial update using Map)
  Future<void> updateFeedback(String key, Map<String, dynamic> data) async {
    await _databaseRef.child(key).update(data);
  }
}
