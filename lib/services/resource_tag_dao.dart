import 'package:firebase_database/firebase_database.dart';
import '../models/resource_tag.dart';

class ResourceTagDao {
  final _databaseRef = FirebaseDatabase.instance.ref("resource_tags");

  void saveResourceTag(ResourceTag resourceTag) {
    _databaseRef.push().set(resourceTag.toJson());
  }

  Query getResourceTagList() {
    return _databaseRef;
  }

  void deleteResourceTag(String key) {
    _databaseRef.child(key).remove();
  }

  void updateResourceTag(String key, ResourceTag resourceTag) {
    _databaseRef.child(key).update(resourceTag.toMap());
  }
}