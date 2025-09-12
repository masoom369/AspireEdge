import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aspire_edge/models/wishlist_item.dart';
import 'package:aspire_edge/services/wishlist_item_dao.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  WishlistPageState createState() => WishlistPageState();
}

class WishlistPageState extends State<WishlistPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Select category';
  final WishlistItemDao _dao = WishlistItemDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: "Wishlist",
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in to view your wishlist.'));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildWishlistForm(),
          const SizedBox(height: 24),
          _buildWishlistList(user.uid),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        children: [
     
    
          Text(
            'Tell us what you want to see in the future! Share your ideas, and we\'ll consider them for upcoming updates and resources.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.favorite, color: Color(0xFF667EEA), size: 20),
                SizedBox(width: 8),
                Text(
                  'Send Your Wishlist',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Fill out the form below to let us know what resources you need in the future',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            _buildCategoryDropdown(),

            const SizedBox(height: 20),
            _buildTextField("Title *", _titleController, "e.g. Flutter UI Kit, SEO eBook"),

            const SizedBox(height: 20),
            _buildTextField("Description *", _descriptionController,
                "Tell us more about what you need...", maxLines: 4),

            const SizedBox(height: 24),
            _buildSendButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF667EEA)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = [
      'Select category',
      'Blog',
      'eBook',
      'Video',
      'Gallery',
      'Other'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value == 'Select category' ? Colors.grey[400] : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate() && _selectedCategory != 'Select category') {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              final item = WishlistItem(
                userId: user.uid,
                category: _selectedCategory,
                title: _titleController.text,
                description: _descriptionController.text,
              );
              _dao.saveWishlistItem(item);
              _titleController.clear();
              _descriptionController.clear();
              setState(() {
                _selectedCategory = 'Select category';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wishlist submitted successfully!'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User not logged in'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please complete all required fields'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.send, size: 18),
            SizedBox(width: 8),
            Text('Submit Wishlist', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistList(String userId) {
    return StreamBuilder(
      stream: _dao.getWishlistItemList().orderByChild('userId').equalTo(userId).onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const Center(child: Text('No wishlist items found.'));
        }
        final itemsMap = Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final items = itemsMap.entries.map((e) {
          final json = Map<String, dynamic>.from(e.value);
          return WishlistItem.fromJson(json);
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(item.title),
                subtitle: Text('${item.description}\nCategory: ${item.category}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
