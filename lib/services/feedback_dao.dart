import 'package:firebase_database/firebase_database.dart';
import '../models/feedback.dart';

class FeedbackDao {
  final _databaseRef = FirebaseDatabase.instance.ref("feedbacks");

  FeedbackDao();


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


  Query getFeedbackList() {
    return _databaseRef;
  }


  void deleteFeedback(String key) {
    _databaseRef.child(key).remove();
  }


  Future<void> updateFeedback(String key, Map<String, dynamic> data) async {
    await _databaseRef.child(key).update(data);
  }
}

