import 'dart:math';
import 'package:flutter/material.dart';
import 'package:aspire_edge/constants.dart';
import '../../models/menu.dart';
import 'components/btm_nav_item.dart';
import 'components/menu_btn.dart';
import 'components/side_bar.dart';

class EntryPoint extends StatefulWidget {
  final Widget child;
  const EntryPoint({super.key, required this.child});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;
  Menu selectedBottonNav = bottomNavItems.first;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          setState(() {});
        });

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [

          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideBar(),
          ),


          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                1 * animation.value - 30 * (animation.value) * pi / 180,
              ),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: widget.child, // Use the passed child
                ),
              ),
            ),
          ),


          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              isOpen: isSideBarOpen,
              press: () {
                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(() {
                  isSideBarOpen = !isSideBarOpen;
                });
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: Transform.translate(
        offset: Offset(0, 100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 12,
              top: 12,
              right: 12,
              bottom: 12,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor2.withOpacity(0.3),
                  offset: const Offset(0, 20),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(bottomNavItems.length, (index) {
                  Menu navBar = bottomNavItems[index];
                  return BtmNavItem(
                    navBar: navBar,
                    press: () {
                      updateSelectedBtmNav(navBar);

                      switch (navBar.title) {
                        case "Home":
                          Navigator.pushNamed(context, '/');
                          break;
                        case "Search":
                          Navigator.pushNamed(context, '/ResourcesHubPage');
                          break;
                        case "Profile":
                          Navigator.pushNamed(context, '/profile');
                          break;
                        case "Notifications":
                          Navigator.pushNamed(context, '/BookmarksPage');
                          break;
                        case "Contact":
                          Navigator.pushNamed(context, '/contact');
                          break;
                        default:
                          break;
                      }
                    },
                    selectedNav: selectedBottonNav,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

