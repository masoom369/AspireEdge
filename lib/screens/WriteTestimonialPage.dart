import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteTestimonialPage extends StatefulWidget {
  const WriteTestimonialPage({Key? key}) : super(key: key);

  @override
  State<WriteTestimonialPage> createState() => _WriteTestimonialPageState();
}

class _WriteTestimonialPageState extends State<WriteTestimonialPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();
  String _selectedTier = 'Graduate'; // Default for graduates
  bool _isUploading = false;

  final List<String> _tierOptions = ['Graduate', 'Student', 'Professional'];

  void _submitTestimonial() {
    if (_nameController.text.trim().isEmpty || _storyController.text.trim().isEmpty) {
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

    // Simulate API call or database save
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF8E2DE2),
          content: Text(
            '✅ Testimonial submitted successfully!',
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
      );

      // Clear form
      _nameController.clear();
      _storyController.clear();
    });
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
          'Share Your Story',
          style: GoogleFonts.poppins(
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
              'Inspire Others with Your Success',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Share how AspireEdge helped you achieve your goals.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 30),

            // Name Field
            Text(
              'Your Name *',
              style: GoogleFonts.poppins(
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
                hintStyle: GoogleFonts.poppins(color: Color(0xFF9CA3AF)),
              ),
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 20),

            // Tier Dropdown
            Text(
              'Your Tier *',
              style: GoogleFonts.poppins(
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF8E2DE2)),
                style: GoogleFonts.poppins(),
                items: _tierOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, style: GoogleFonts.poppins()),
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

            // Story Field
            Text(
              'Your Success Story *',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _storyController,
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
                hintText: 'How did AspireEdge help you? What’s your success story?',
                hintStyle: GoogleFonts.poppins(color: Color(0xFF9CA3AF)),
              ),
              style: GoogleFonts.poppins(),
            ),
            SizedBox(height: 20),

            // Optional: Upload Photo
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFE5E7EB)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.image, color: Color(0xFF8E2DE2), size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Upload Photo (Optional)',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.add_a_photo, color: Color(0xFF8E2DE2)),
                    onPressed: () {
                      // TODO: Implement image picker
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Image picker not implemented yet')),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTestimonial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isUploading ? Colors.grey : Color(0xFF8E2DE2),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isUploading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        '📤 Submit Testimonial',
                        style: GoogleFonts.poppins(
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
    _storyController.dispose();
    super.dispose();
  }
}