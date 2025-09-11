import 'package:firebase_database/firebase_database.dart';
import '../models/office_location.dart';

class OfficeLocationDao {
  OfficeLocationDao();

  final _databaseRef = FirebaseDatabase.instance.ref("office_locations");

  void saveOfficeLocation(OfficeLocation officeLocation) {
    _databaseRef.push().set(officeLocation.toJson());
  }

  Query getOfficeLocationList() {
    return _databaseRef;
  }

  void deleteOfficeLocation(String key) {
    _databaseRef.child(key).remove();
  }

  void updateOfficeLocation(String key, OfficeLocation officeLocation) {
    _databaseRef.child(key).update(officeLocation.toJson());
  }
}