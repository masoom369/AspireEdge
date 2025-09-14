import 'package:aspire_edge/screens/entryPoint/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/feedback.dart';
import '../services/feedback_dao.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  ContactUsPageState createState() => ContactUsPageState();
}

class ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedInquiryType = 'Select inquiry type';

  final FeedbackDao _feedbackDao = FeedbackDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Contact Us"),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildContactForm(),
          const SizedBox(height: 20),
          _buildLocations(),
          const SizedBox(height: 24),
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
          const Text(
            'Get in Touch',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'We\'re here to help you succeed. Reach out to our team for support, questions, or to learn more about AspireEdge.',
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

  Widget _buildContactForm() {
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
                Icon(Icons.send, color: Color(0xFF667EEA), size: 20),
                SizedBox(width: 8),
                Text(
                  'Send us a Message',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildTextField("Name *", _nameController, "Your full name")),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField("Email *", _emailController, "your@email.com")),
              ],
            ),

            const SizedBox(height: 20),
            _buildDropdown(),

            const SizedBox(height: 20),
            _buildTextField("Subject *", _subjectController, "Brief summary of your inquiry"),

            const SizedBox(height: 20),
            _buildTextField("Message *", _messageController, "Please provide details...", maxLines: 4),

            const SizedBox(height: 24),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700])),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.isEmpty) return "$label is required";
            return null;
          },
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

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Inquiry Type',
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
              value: _selectedInquiryType,
              isExpanded: true,
              items: [
                'Select inquiry type',
                'General Inquiry',
                'Technical Support',
                'Career Guidance',
                'Partnership',
                'Other'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                        fontSize: 16,
                        color: value == 'Select inquiry type' ? Colors.grey[400] : Colors.black,
                      )),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedInquiryType = newValue!;
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
        onPressed: _handleSubmit,
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
            Text('Send Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedInquiryType == 'Select inquiry type') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an inquiry type")),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      final feedback = FeedbackModel(
        id: '', // will be set in DAO
        userId: user?.uid ?? 'anonymous',
        name: _nameController.text,
        email: _emailController.text,
        subject: _subjectController.text,
        inquiryType: _selectedInquiryType,
        message: _messageController.text,
      );

      _feedbackDao.saveFeedback(feedback);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message sent successfully!"), backgroundColor: Colors.green),
      );

      _formKey.currentState!.reset();
      setState(() {
        _selectedInquiryType = 'Select inquiry type';
      });
    }
  }

  Widget _buildLocations() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on, color: Color(0xFF667EEA), size: 20),
              SizedBox(width: 8),
              Text(
                'Our Locations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchURL('https://maps.google.com'); // replace with real location
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.location_on, color: Color(0xFF667EEA), size: 30),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Click to view our location on Google Maps',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
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

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

