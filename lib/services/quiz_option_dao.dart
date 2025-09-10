import 'package:firebase_database/firebase_database.dart';
import '../models/quiz_option.dart';

class QuizOptionDao {
  final _databaseRef = FirebaseDatabase.instance.ref("quiz_options");

  void saveQuizOption(QuizOption quizOption) {
    _databaseRef.push().set(quizOption.toJson());
  }

  Query getQuizOptionList() {
    return _databaseRef;
  }

  void deleteQuizOption(String key) {
    _databaseRef.child(key).remove();
  }

  void updateQuizOption(String key, QuizOption quizOption) {
    _databaseRef.child(key).update(quizOption.toMap());
  }
}