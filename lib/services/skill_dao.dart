import 'package:firebase_database/firebase_database.dart';
import '../models/skill.dart';

class SkillDao {
  final _databaseRef = FirebaseDatabase.instance.ref("skills");

  void saveSkill(Skill skill) {
    _databaseRef.push().set(skill.toJson());
  }

  Query getSkillList() {
    return _databaseRef;
  }

  void deleteSkill(String key) {
    _databaseRef.child(key).remove();
  }

  void updateSkill(String key, Skill skill) {
    _databaseRef.child(key).update(skill.toMap());
  }
}