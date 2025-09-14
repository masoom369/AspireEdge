import 'package:firebase_database/firebase_database.dart';
import '../models/wishlist_item.dart';

class WishlistItemDao {
  final _databaseRef = FirebaseDatabase.instance.ref("wishlist_items");

  WishlistItemDao();

  void saveWishlistItem(WishlistItem wishlistItem) {
    _databaseRef.push().set(wishlistItem.toJson());
  }

  Query getWishlistItemList() {
    return _databaseRef;
  }

  void deleteWishlistItem(String key) {
    _databaseRef.child(key).remove();
  }

  void updateWishlistItem(String key, WishlistItem wishlistItem) {
    _databaseRef.child(key).update(wishlistItem.toJson());
  }
}
