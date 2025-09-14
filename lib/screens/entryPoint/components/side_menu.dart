import 'package:flutter/material.dart';
import '../../../models/menu.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
    required this.menu,
    required this.press,
    required this.selectedMenu,
  });

  final Menu menu;
  final VoidCallback press;
  final Menu selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 24),
          child: Divider(color: Colors.white24, height: 1),
        ),
        Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              width: selectedMenu == menu ? 288 : 0,
              height: 56,
              left: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF8E2DE2),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            ListTile(
              onTap: press,
              leading: Icon(
                menu.icon,
                size: 20,
                color: Colors.white,
              ),
              title: Text(
                menu.title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

