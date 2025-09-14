import 'package:flutter/material.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/services/user_dao.dart';
import 'package:aspire_edge/models/user.dart' as user_model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aspire_edge/services/validate.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();


  String? selectedTier = "";

  bool _isLoading = false;
  String? _error;


  Future<void> _saveUserToPrefs(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
  }


  Future<void> signUp(BuildContext context) async {
    setState(() {
      _error = null;
    });

    if (_formKey.currentState?.validate() ?? false) {

      if (_nameController.text.trim().isEmpty ||
          _emailController.text.trim().isEmpty ||
          _passwordController.text.isEmpty ||
          selectedTier == null ||
          selectedTier == "") {
        setState(() => _error = "All fields are required");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_error!)));
        return;
      }

      setState(() => _isLoading = true);

      try {
        final firebaseUser = await AuthService().register(
          _emailController.text.trim(),
          _passwordController.text,
          _nameController.text.trim(),
        );

        if (firebaseUser != null) {
          final userObj = user_model.User(
            uuid: firebaseUser.uid,
            role: 'user',
            tier: selectedTier!,
            username: _nameController.text.trim(),
          );


          final userDao = UserDao();
          userDao.saveUser(userObj);

          await _saveUserToPrefs(firebaseUser.uid);

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() => _error = e.message ?? "Registration failed");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_error!)));
      } catch (e) {
        setState(() => _error = "An unexpected error occurred");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_error!)));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
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
              controller: _nameController,
              validator: validateName,
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
              controller: _emailController,
              validator: validateEmail,
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
              controller: _passwordController,
              obscureText: true,
              validator: validatePass,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "******",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Text(
            "Select Your Tier",
            style: TextStyle(color: Colors.black54),
          ),
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
                if (value == null || value == "") {
                  return "Please select a tier";
                }
                return null;
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                  value: "",
                  child: Text("Please select a tier"),
                ),
                DropdownMenuItem(value: "Student", child: Text("Student")),
                DropdownMenuItem(
                  value: "UnderGraduate",
                  child: Text("UnderGraduate"),
                ),
                DropdownMenuItem(
                  value: "PostGraduate",
                  child: Text("PostGraduate"),
                ),
                DropdownMenuItem(
                  value: "Professional",
                  child: Text("Professional"),
                ),
              ],
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: _isLoading ? null : () => signUp(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF77D8E),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Sign Up"),
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

