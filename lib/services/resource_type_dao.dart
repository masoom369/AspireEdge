import 'package:firebase_database/firebase_database.dart';
import '../models/resource_type.dart';

class ResourceTypeDao {
  final _databaseRef = FirebaseDatabase.instance.ref("resource_types");

  ResourceTypeDao();

  void saveResourceType(ResourceType resourceType) {
    _databaseRef.push().set(resourceType.toJson());
  }

  Query getResourceTypeList() {
    return _databaseRef;
  }

  void deleteResourceType(String key) {
    _databaseRef.child(key).remove();
  }

  void updateResourceType(String key, ResourceType resourceType) {
    _databaseRef.child(key).update(resourceType.toJson());
  }
}