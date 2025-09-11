import 'package:firebase_database/firebase_database.dart';
import '../models/quiz_attempt.dart';

class QuizAttemptDao {
  final _databaseRef = FirebaseDatabase.instance.ref("quiz_attempts");

  QuizAttemptDao();

  void saveQuizAttempt(QuizAttempt quizAttempt) {
    _databaseRef.push().set(quizAttempt.toJson());
  }

  Query getQuizAttemptList() {
    return _databaseRef;
  }

  void deleteQuizAttempt(String key) {
    _databaseRef.child(key).remove();
  }

  void updateQuizAttempt(String key, QuizAttempt quizAttempt) {
    _databaseRef.child(key).update(quizAttempt.toJson());
  }
}