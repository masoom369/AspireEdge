import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 45.0), 
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8E2DE2),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.logout,
            color: Color(0xFF8E2DE2),
            size: 26,
          ),
          onPressed: () {
            // 👇 Navigate to LogoutPage
            Navigator.pushNamed(context, '/logout');
          },
        ),
      ],
    );
  }
}
