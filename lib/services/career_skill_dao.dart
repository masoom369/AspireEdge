import 'package:firebase_database/firebase_database.dart';
import '../models/career_skill.dart';

class CareerSkillDao {
  final _databaseRef = FirebaseDatabase.instance.ref("career_skills");

  // Add constructor if needed
  CareerSkillDao();

  void saveCareerSkill(CareerSkill careerSkill) {
    _databaseRef.push().set(careerSkill.toJson());
  }

  Query getCareerSkillList() {
    return _databaseRef;
  }

  void deleteCareerSkill(String key) {
    _databaseRef.child(key).remove();
  }

  void updateCareerSkill(String key, CareerSkill careerSkill) {
    _databaseRef.child(key).update(careerSkill.toJson());
  }
}