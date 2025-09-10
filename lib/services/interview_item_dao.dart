import 'package:firebase_database/firebase_database.dart';
import '../models/interview_item.dart';

class InterviewItemDao {
  final _databaseRef = FirebaseDatabase.instance.ref("interview_items");

  void saveInterviewItem(InterviewItem interviewItem) {
    _databaseRef.push().set(interviewItem.toJson());
  }

  Query getInterviewItemList() {
    return _databaseRef;
  }

  void deleteInterviewItem(String key) {
    _databaseRef.child(key).remove();
  }

  void updateInterviewItem(String key, InterviewItem interviewItem) {
    _databaseRef.child(key).update(interviewItem.toMap());
  }
}