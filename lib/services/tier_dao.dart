import 'package:firebase_database/firebase_database.dart';
import '/models/tier.dart';

class TierDao {
  final _databaseRef = FirebaseDatabase.instance.ref("tiers");

  void saveTier(Tier tier) {
    _databaseRef.push().set(tier.toJson());
  }

  Query getTierList() {
    return _databaseRef;
  }

  void deleteTier(String key) {
    _databaseRef.child(key).remove();
  }

  void updateTier(String key, Tier tier) {
    _databaseRef.child(key).update(tier.toMap());
  }
}