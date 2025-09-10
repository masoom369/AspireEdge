import 'package:firebase_database/firebase_database.dart';
import '../models/media.dart';

class MediaDao {
  final _databaseRef = FirebaseDatabase.instance.ref("media");

  void saveMedia(Media media) {
    _databaseRef.push().set(media.toJson());
  }

  Query getMediaList() {
    return _databaseRef;
  }

  void deleteMedia(String key) {
    _databaseRef.child(key).remove();
  }

  void updateMedia(String key, Media media) {
    _databaseRef.child(key).update(media.toMap());
  }
}