import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Image;

import 'components/animated_btn.dart';
import 'components/sign_in_dialog.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;
  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <  500;

    return Scaffold(
      body: Stack(
        children: [

          Positioned(
            width: size.width * 1.7,
            left: size.width * 0.1,
            bottom: size.height * 0.1,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: size.height,
            width: size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.1),

                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Career Passport – Explore, Plan, and Achieve",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 28 : 55,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Text(
                            "Navigate your future with personalized career guidance, self-assessment tools, and expert resources designed for students, graduates, and professionals.",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),

                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.06),
                      child: AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;

                          Future.delayed(
                            const Duration(milliseconds: 800),
                            () {
                              setState(() {
                                isShowSignInDialog = true;
                              });
                              if (!context.mounted) return;
                              showCustomDialog(
                                context,
                                onValue: (_) {},
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

