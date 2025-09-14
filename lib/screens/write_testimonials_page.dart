import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/testimonial.dart';
import '../utils/image_picker.dart'; // <-- Your helper for picking images

class WriteTestimonialsPage extends StatefulWidget {
  const WriteTestimonialsPage({Key? key}) : super(key: key);

  @override
  State<WriteTestimonialsPage> createState() => _WriteTestimonialsPageState();
}

class _WriteTestimonialsPageState extends State<WriteTestimonialsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _testimonialController = TextEditingController();
  String _selectedTier = 'Graduate'; // Default tier
  bool _isUploading = false;
  String? _imageBase64; // Store image as Base64

  final List<String> _tierOptions = ['Graduate', 'Student', 'Professional'];

  Future<void> _pickImage() async {
    final img = await ImagePickerUtils.pickImageBase64();
    if (img.isNotEmpty) {
      setState(() {
        _imageBase64 = img;
      });
    }
  }

  void _submitTestimonial() async {
    if (_nameController.text.trim().isEmpty ||
        _testimonialController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Please fill in all fields.'),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final ref = FirebaseDatabase.instance.ref("testimonials");


      final testimonial = Testimonial(
        id: "", // Firebase will generate key
        userName: _nameController.text.trim(),
        message: _testimonialController.text.trim(),
        rating: 0, // Default for now
        status: "pending", // Default until admin approves
        date: DateTime.now().toIso8601String(),
        image: _imageBase64,
        tier: _selectedTier,
      );

      await ref.push().set(testimonial.toMap());

      setState(() {
        _isUploading = false;
        _imageBase64 = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF8E2DE2),
          content: Text(
            '✅ Testimonial submitted successfully!',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
          ),
        ),
      );

      _nameController.clear();
      _testimonialController.clear();
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('❌ Failed to submit. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF8E2DE2)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Write a Testimonial',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2D3748),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Share Your Testimonial',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tell us how AspireEdge made an impact for you.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 30),


            Text(
              'Your Name *',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF8E2DE2), width: 2),
                ),
                hintText: 'Enter your full name',
                hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF9CA3AF)),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),


            Text(
              'Your Tier *',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedTier,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF8E2DE2)),
                style: TextStyle(fontFamily: 'Poppins'),
                items: _tierOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, style: TextStyle(fontFamily: 'Poppins')),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTier = newValue!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),


            Text(
              'Your Testimonial *',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _testimonialController,
              maxLines: 6,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFF8E2DE2), width: 2),
                ),
                hintText: 'Write your testimonial here...',
                hintStyle: TextStyle(fontFamily: 'Poppins', color: Color(0xFF9CA3AF)),
              ),
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            SizedBox(height: 20),


            Text(
              'Add a Photo (optional)',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _pickImage,
                  icon: Icon(Icons.image),
                  label: Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E2DE2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                if (_imageBase64 != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      UriData.parse('data:image/png;base64,$_imageBase64')
                          .contentAsBytes(),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 30),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTestimonial,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isUploading ? Colors.grey : Color(0xFF8E2DE2),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        '📤 Submit Testimonial',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _testimonialController.dispose();
    super.dispose();
  }
}

