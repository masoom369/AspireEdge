import 'package:firebase_database/firebase_database.dart';
import '../models/bookmark.dart';

class BookmarkDao {
  final _databaseRef = FirebaseDatabase.instance.ref("bookmarks");

  BookmarkDao();

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
    _databaseRef.child(key).update(bookmark.toJson());
  }

  // Get all bookmarks for a user
  Future<List<Bookmark>> getBookmarksByUser(String uuid) async {
    final snapshot = await _databaseRef.get();
    final List<Bookmark> bookmarks = [];
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        final bookmark = Map<String, dynamic>.from(value);
        if (bookmark['uuid'] == uuid) {
          bookmarks.add(Bookmark(
            uuid: bookmark['uuid'],
            resourceId: bookmark['resourceId'],
          ));
        }
      });
    }
    return bookmarks;
  }

  // Remove bookmark by user and resourceId
  Future<void> removeBookmark(String uuid, String resourceId) async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      for (final entry in data.entries) {
        final bookmark = Map<String, dynamic>.from(entry.value);
        if (bookmark['uuid'] == uuid && bookmark['resourceId'] == resourceId) {
          await _databaseRef.child(entry.key).remove();
          break;
        }
      }
    }
  }

  // Check if a resource is bookmarked by user
  Future<bool> isBookmarked(String uuid, String resourceId) async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      return data.values.any((value) {
        final bookmark = Map<String, dynamic>.from(value);
        return bookmark['uuid'] == uuid && bookmark['resourceId'] == resourceId;
      });
    }
    return false;
  }
}
