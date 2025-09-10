import 'package:firebase_database/firebase_database.dart';
import '../models/quiz_question.dart';

class QuizQuestionDao {
  final _databaseRef = FirebaseDatabase.instance.ref("quiz_questions");

  void saveQuizQuestion(QuizQuestion quizQuestion) {
    _databaseRef.push().set(quizQuestion.toJson());
  }

  Query getQuizQuestionList() {
    return _databaseRef;
  }

  void deleteQuizQuestion(String key) {
    _databaseRef.child(key).remove();
  }

  void updateQuizQuestion(String key, QuizQuestion quizQuestion) {
    _databaseRef.child(key).update(quizQuestion.toMap());
  }
}