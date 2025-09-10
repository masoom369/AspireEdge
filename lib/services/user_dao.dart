import 'package:firebase_database/firebase_database.dart';
import '/models/user.dart';

class UserDao {
  final _databaseRef = FirebaseDatabase.instance.ref("users");

  void saveUser(User user) {
    _databaseRef.push().set(user.toJson());
  }

  Query getUserList() {
    return _databaseRef;
  }

  void deleteUser(String key) {
    _databaseRef.child(key).remove();
  }

  void updateUser(String key, User user) {
    _databaseRef.child(key).update(user.toMap());
  }
}