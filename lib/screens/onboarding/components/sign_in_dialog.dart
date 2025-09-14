import 'package:flutter/material.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

void showCustomDialog(BuildContext context, {required ValueChanged onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 520,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                clipBehavior: Clip.none,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 34,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Log in to continue your career journey",
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        const SignInForm(),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Close SignIn dialog
                            showSignUpDialog(context, onValue: (_) {});
                          },
                          child: const Text(
                            "Not registered? Create an account",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: FadeTransition(opacity: anim, child: child),
      );
    },
  ).then(onValue);
}


void showSignUpDialog(BuildContext context, {required ValueChanged onValue}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          height: 650,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 30),
                blurRadius: 60,
              ),
              const BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 30),
                blurRadius: 60,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Create Your Account",
                      style: TextStyle(
                        fontSize: 34,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Start exploring careers tailored just for you",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    RegisterForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      final tween = Tween(begin: const Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: FadeTransition(opacity: anim, child: child),
      );
    },
  ).then(onValue);
}

