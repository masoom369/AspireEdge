import 'package:firebase_database/firebase_database.dart';
import '../models/industry.dart';

class IndustryDao {
  final _databaseRef = FirebaseDatabase.instance.ref("industries");

  void saveIndustry(Industry industry) {
    _databaseRef.push().set(industry.toJson());
  }

  Query getIndustryList() {
    return _databaseRef;
  }

  void deleteIndustry(String key) {
    _databaseRef.child(key).remove();
  }

  void updateIndustry(String key, Industry industry) {
    _databaseRef.child(key).update(industry.toMap());
  }
}