import 'package:firebase_database/firebase_database.dart';
import '../models/quiz.dart';

class QuizDao {
  final _databaseRef = FirebaseDatabase.instance.ref("quizzes");

  QuizDao();

  void saveQuiz(Quiz quiz) {
    _databaseRef.push().set(quiz.toJson());
  }

  Query getQuizList() {
    return _databaseRef;
  }

  void deleteQuiz(String key) {
    _databaseRef.child(key).remove();
  }

  void updateQuiz(String key, Quiz quiz) {
    _databaseRef.child(key).update(quiz.toJson());
  }
}