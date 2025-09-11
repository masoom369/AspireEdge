import 'package:firebase_database/firebase_database.dart';
import '../models/education_path.dart';

class EducationPathDao {
  final _databaseRef = FirebaseDatabase.instance.ref("education_paths");

  // Add constructor if needed
  EducationPathDao();

  void saveEducationPath(EducationPath educationPath) {
    _databaseRef.push().set(educationPath.toJson());
  }

  Query getEducationPathList() {
    return _databaseRef;
  }

  void deleteEducationPath(String key) {
    _databaseRef.child(key).remove();
  }

  void updateEducationPath(String key, EducationPath educationPath) {
    _databaseRef.child(key).update(educationPath.toJson());
  }
}