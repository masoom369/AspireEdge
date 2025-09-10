import 'package:firebase_database/firebase_database.dart';
import '../models/quiz_answer.dart';

class QuizAnswerDao {
  final _databaseRef = FirebaseDatabase.instance.ref("quiz_answers");

  void saveQuizAnswer(QuizAnswer quizAnswer) {
    _databaseRef.push().set(quizAnswer.toJson());
  }

  Query getQuizAnswerList() {
    return _databaseRef;
  }

  void deleteQuizAnswer(String key) {
    _databaseRef.child(key).remove();
  }

  void updateQuizAnswer(String key, QuizAnswer quizAnswer) {
    _databaseRef.child(key).update(quizAnswer.toMap());
  }
}