import 'package:firebase_database/firebase_database.dart';
import '../models/career.dart';

class CareerDao {
  final _databaseRef = FirebaseDatabase.instance.ref("careers");


  CareerDao();


  void saveCareer(Career career) {
    _databaseRef.push().set(career.toJson());
  }


  Query getCareerList() {
    return _databaseRef;
  }


  void deleteCareer(String key) {
    _databaseRef.child(key).remove();
  }


  void updateCareer(String key, Career career) {
    _databaseRef.child(key).update(career.toJson());
  }


  Career fromSnapshot(DataSnapshot snapshot) {
    final json = snapshot.value as Map<dynamic, dynamic>;
    return Career.fromJson(json.cast<String, dynamic>());
  }


  List<Career> careerListFromSnapshot(List<DataSnapshot> snapshotList) {
    return snapshotList.map((snapshot) {
      return fromSnapshot(snapshot);
    }).toList();
  }
}

