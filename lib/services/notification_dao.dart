import 'package:firebase_database/firebase_database.dart';
import '../models/notification.dart';

class NotificationDao {
  final _databaseRef = FirebaseDatabase.instance.ref("notifications");

  void saveNotification(Notification notification) {
    _databaseRef.push().set(notification.toJson());
  }

  Query getNotificationList() {
    return _databaseRef;
  }

  void deleteNotification(String key) {
    _databaseRef.child(key).remove();
  }

  void updateNotification(String key, Notification notification) {
    _databaseRef.child(key).update(notification.toJson());
  }
}