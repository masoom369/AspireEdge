import 'package:firebase_database/firebase_database.dart';
import '../models/push_token.dart';

class PushTokenDao {
  final _databaseRef = FirebaseDatabase.instance.ref("push_tokens");

  PushTokenDao();

  void savePushToken(PushToken pushToken) {
    _databaseRef.push().set(pushToken.toJson());
  }

  Query getPushTokenList() {
    return _databaseRef;
  }

  void deletePushToken(String key) {
    _databaseRef.child(key).remove();
  }

  void updatePushToken(String key, PushToken pushToken) {
    _databaseRef.child(key).update(pushToken.toJson());
  }
}