import 'package:firebase_database/firebase_database.dart';
import '../models/notification_target.dart';

class NotificationTargetDao {
  final _databaseRef = FirebaseDatabase.instance.ref("notification_targets");

  void saveNotificationTarget(NotificationTarget notificationTarget) {
    _databaseRef.push().set(notificationTarget.toJson());
  }

  Query getNotificationTargetList() {
    return _databaseRef;
  }

  void deleteNotificationTarget(String key) {
    _databaseRef.child(key).remove();
  }

  void updateNotificationTarget(String key, NotificationTarget notificationTarget) {
    _databaseRef.child(key).update(notificationTarget.toMap());
  }
}