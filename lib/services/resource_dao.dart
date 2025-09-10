import 'package:firebase_database/firebase_database.dart';
import '../models/resource.dart';

class ResourceDao {
  final _databaseRef = FirebaseDatabase.instance.ref("resources");

  void saveResource(Resource resource) {
    _databaseRef.push().set(resource.toJson());
  }

  Query getResourceList() {
    return _databaseRef;
  }

  void deleteResource(String key) {
    _databaseRef.child(key).remove();
  }

  void updateResource(String key, Resource resource) {
    _databaseRef.child(key).update(resource.toMap());
  }
}