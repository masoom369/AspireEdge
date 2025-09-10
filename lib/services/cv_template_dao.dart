import 'package:firebase_database/firebase_database.dart';
import '../models/cv_template.dart';

class CVTemplateDao {
  final _databaseRef = FirebaseDatabase.instance.ref("cv_templates");

  void saveCVTemplate(CVTemplate cvTemplate) {
    _databaseRef.push().set(cvTemplate.toJson());
  }

  Query getCVTemplateList() {
    return _databaseRef;
  }

  void deleteCVTemplate(String key) {
    _databaseRef.child(key).remove();
  }

  void updateCVTemplate(String key, CVTemplate cvTemplate) {
    _databaseRef.child(key).update(cvTemplate.toMap());
  }
}