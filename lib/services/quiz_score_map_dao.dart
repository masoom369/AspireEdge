import 'package:firebase_database/firebase_database.dart';
import '../models/quiz_score_map.dart';

class QuizScoreMapDao {
  final _databaseRef = FirebaseDatabase.instance.ref("quiz_score_maps");

  void saveQuizScoreMap(QuizScoreMap quizScoreMap) {
    _databaseRef.push().set(quizScoreMap.toJson());
  }

  Query getQuizScoreMapList() {
    return _databaseRef;
  }

  void deleteQuizScoreMap(String key) {
    _databaseRef.child(key).remove();
  }

  void updateQuizScoreMap(String key, QuizScoreMap quizScoreMap) {
    _databaseRef.child(key).update(quizScoreMap.toMap());
  }
}