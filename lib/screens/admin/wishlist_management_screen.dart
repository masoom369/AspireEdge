import 'package:flutter/material.dart';
import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aspire_edge/models/wishlist_item.dart';
import 'package:aspire_edge/services/wishlist_item_dao.dart';

class AdminWishlistPage extends StatefulWidget {
  const AdminWishlistPage({super.key});

  @override
  State<AdminWishlistPage> createState() => _AdminWishlistPageState();
}

class _AdminWishlistPageState extends State<AdminWishlistPage> {
  final WishlistItemDao _dao = WishlistItemDao();

  void _deleteItem(String key) {
    _dao.deleteWishlistItem(key);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Wishlist item deleted"),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
       appBar: CustomAppBar(title:"Wishlist Management"),     body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: _dao.getWishlistItemList().onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(
                child: Text(
                  "No wishlist items available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            final itemsMap = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
            final items = itemsMap.entries.map((e) {
              final json = Map<String, dynamic>.from(e.value);
              return {'key': e.key, 'item': WishlistItem.fromJson(json)};
            }).toList();

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = items[index];
                final key = entry['key'] as String;
                final item = entry['item'] as WishlistItem;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF764BA2), Color(0xFF667EEA)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(Icons.favorite, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _deleteItem(key),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Category: ${item.category}",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

