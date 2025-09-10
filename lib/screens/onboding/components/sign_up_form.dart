import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/screens/entryPoint/entry_point.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedTier;

  void signUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Optional: Show success SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account Created Successfully!")),
      );

      // Navigate to EntryPoint (home screen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EntryPoint()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Full Name", style: TextStyle(color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter your name";
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "John Doe",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Text("Email Address", style: TextStyle(color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter your email";
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "example@domain.com",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Text("Password", style: TextStyle(color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) return "Enter password";
                return null;
              },
              decoration: const InputDecoration(
                hintText: "********",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Text("Confirm Password", style: TextStyle(color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: TextFormField(
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) return "Re-enter password";
                return null;
              },
              decoration: const InputDecoration(
                hintText: "********",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Text("Select Your Tier", style: TextStyle(color: Colors.black54)),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: DropdownButtonFormField<String>(
              value: selectedTier,
              onChanged: (value) {
                setState(() {
                  selectedTier = value;
                });
              },
              validator: (value) {
                if (value == null) return "Please select a tier";
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Student", child: Text("Student")),
                DropdownMenuItem(value: "Graduate", child: Text("Graduate")),
                DropdownMenuItem(value: "Professional", child: Text("Professional")),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: () {
                signUp(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF77D8E),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text("Sign Up"),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Join AspireEdge and unlock tools, resources, and personalized guidance to achieve your career goals.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
