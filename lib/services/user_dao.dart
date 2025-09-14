import 'package:firebase_database/firebase_database.dart';
import 'package:aspire_edge/models/user.dart';

class UserDao {
  UserDao();
  final _databaseRef = FirebaseDatabase.instance.ref("users");

  void saveUser(User user) {
    _databaseRef.child(user.uuid).set(user.toJson());
  }

  Query getUserList() {
    return _databaseRef;
  }

  void deleteUser(String key) {
    _databaseRef.child(key).remove();
  }

  void updateUser(String key, User user) {
    _databaseRef.child(key).update(user.toJson());
  }

  Future<String?> getUserRole(String uid) async {
    final snapshot = await _databaseRef
        .orderByChild('uuid')
        .equalTo(uid)
        .limitToFirst(1)
        .get();

    if (snapshot.exists && snapshot.children.isNotEmpty) {
      final userData = snapshot.children.first.value as Map<dynamic, dynamic>?;
      if (userData != null && userData['role'] is String) {
        return userData['role'] as String;
      }
    }
    return null;
  }

  Future<User?> getUserById(String uid) async {
    final snapshot = await _databaseRef
        .orderByChild('uuid')
        .equalTo(uid)
        .limitToFirst(1)
        .get();

    if (snapshot.exists && snapshot.children.isNotEmpty) {
      final userData = snapshot.children.first.value as Map<dynamic, dynamic>?;
      if (userData != null) {
        return User.fromJson(Map<String, dynamic>.from(userData)); // ✅ Safe cast
      }
    }
    return null;
  }
}

