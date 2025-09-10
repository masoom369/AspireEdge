import 'package:firebase_database/firebase_database.dart';
import '../models/bookmark.dart';

class BookmarkDao {
  final _databaseRef = FirebaseDatabase.instance.ref("bookmarks");

  void saveBookmark(Bookmark bookmark) {
    _databaseRef.push().set(bookmark.toJson());
  }

  Query getBookmarkList() {
    return _databaseRef;
  }

  void deleteBookmark(String key) {
    _databaseRef.child(key).remove();
  }

  void updateBookmark(String key, Bookmark bookmark) {
    _databaseRef.child(key).update(bookmark.toMap());
  }
}