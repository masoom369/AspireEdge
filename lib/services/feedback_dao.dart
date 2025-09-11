import 'package:firebase_database/firebase_database.dart';
import '../models/feedback.dart';

class FeedbackDao {
  final _databaseRef = FirebaseDatabase.instance.ref("feedbacks");

  // Add constructor if needed
  FeedbackDao();

  void saveFeedback(Feedback feedback) {
    _databaseRef.push().set(feedback.toJson());
  }

  Query getFeedbackList() {
    return _databaseRef;
  }

  void deleteFeedback(String key) {
    _databaseRef.child(key).remove();
  }

  void updateFeedback(String key, Feedback feedback) {
    _databaseRef.child(key).update(feedback.toJson());
  }
}