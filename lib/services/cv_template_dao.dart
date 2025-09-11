import 'package:firebase_database/firebase_database.dart';
import '../models/cv_template.dart';

class CvTemplateDao {
  final _databaseRef = FirebaseDatabase.instance.ref("cv_templates");

  CvTemplateDao();

  void saveCvTemplate(CvTemplate cvTemplate) {
    _databaseRef.child(cvTemplate.id).set(cvTemplate.toJson());
  }

  Query getCvTemplateList() {
    return _databaseRef;
  }

  void deleteCvTemplate(String id) {
    _databaseRef.child(id).remove();
  }

  void updateCvTemplate(String id, CvTemplate cvTemplate) {
    _databaseRef.child(id).update(cvTemplate.toJson()); // ✅ Fixed here
  }
}
