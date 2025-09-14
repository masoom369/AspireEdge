import 'package:flutter/material.dart';

class MenuBtn extends StatefulWidget {
  const MenuBtn({super.key, required this.press, required this.isOpen});

  final VoidCallback press;
  final bool isOpen; // Whether the sidebar is open or not

  @override
  State<MenuBtn> createState() => _MenuBtnState();
}

class _MenuBtnState extends State<MenuBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (widget.isOpen) {
      _iconController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant MenuBtn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen) {
      _iconController.forward();
    } else {
      _iconController.reverse();
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: widget.press,
        child: Container(
          margin: const EdgeInsets.only(left: 12),
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _iconController,
              size: 28,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

