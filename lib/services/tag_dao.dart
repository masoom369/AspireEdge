import 'package:firebase_database/firebase_database.dart';
import '../models/tag.dart';

class TagDao {
  final _databaseRef = FirebaseDatabase.instance.ref("tags");

  void saveTag(Tag tag) {
    _databaseRef.push().set(tag.toJson());
  }

  Query getTagList() {
    return _databaseRef;
  }

  void deleteTag(String key) {
    _databaseRef.child(key).remove();
  }

  void updateTag(String key, Tag tag) {
    _databaseRef.child(key).update(tag.toMap());
  }
}