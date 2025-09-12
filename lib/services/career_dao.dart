import 'package:firebase_database/firebase_database.dart';
import '../models/career.dart';

class CareerDao {
  final _databaseRef = FirebaseDatabase.instance.ref("careers");

  // Add constructor if needed
  CareerDao();

  // Save a Career object to Firebase
  void saveCareer(Career career) {
    _databaseRef.push().set(career.toJson());
  }

  // Get a list of careers from Firebase
  Query getCareerList() {
    return _databaseRef;
  }

  // Delete a Career from Firebase using its key
  void deleteCareer(String key) {
    _databaseRef.child(key).remove();
  }

  // Update a Career in Firebase
  void updateCareer(String key, Career career) {
    _databaseRef.child(key).update(career.toJson());
  }

  // Convert a snapshot from Firebase to a Career object
  Career fromSnapshot(DataSnapshot snapshot) {
    final json = snapshot.value as Map<dynamic, dynamic>;
    return Career.fromJson(json.cast<String, dynamic>());
  }

  // Convert a list of snapshots to a list of Career objects
  List<Career> careerListFromSnapshot(List<DataSnapshot> snapshotList) {
    return snapshotList.map((snapshot) {
      return fromSnapshot(snapshot);
    }).toList();
  }
}
