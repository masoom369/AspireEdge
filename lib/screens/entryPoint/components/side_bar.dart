import 'package:aspire_edge/screens/entryPoint/components/info_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/services/user_dao.dart';
import '../../../models/menu.dart';
import '../../../utils/rive_utils.dart';
import 'side_menu.dart';

// ========= SIDEBAR WIDGET =========

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu? selectedSideMenu; // ✅ Nullable until initialized

  String? userName;
  String? userBio = "Loading...";
  String? userRole;
  bool _isLoading = true;

  final UserDao _userDao = UserDao();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final displayName =
          user.displayName ?? user.email?.split('@').first ?? "User";

      try {
        final dbUser = await _userDao.getUserById(user.uid);
        if (dbUser != null) {
          final tier = dbUser.tier ?? "Student";
          final role = dbUser.role ?? "User";
          setState(() {
            userName = displayName;
            userBio = tier;
            userRole = role;
            _isLoading = false;
            selectedSideMenu = _getSidebarMenus().first;
          });
          return;
        }
      } catch (e) {
        debugPrint("Error fetching user from DB: $e");
      }

      // Fallback if DB fails
      setState(() {
        userName = displayName;
        userBio = "Member";
        userRole = "User";
        _isLoading = false;
        selectedSideMenu = userSidebarMenus.first;
      });
    } else {
      // Guest
      setState(() {
        userName = "Guest";
        userBio = "Not logged in";
        userRole = null;
        _isLoading = false;
        selectedSideMenu = guestSidebarMenus.first;
      });
    }
  }

  List<Menu> _getSidebarMenus() {
    if (userRole == "Admin") {
      return adminSidebarMenus;
    } else if (userRole == null) {
      return guestSidebarMenus;
    } else {
      return userSidebarMenus;
    }
  }

  void _navigateToPage(BuildContext context, String title) {
    switch (title) {
      case "Home":
        Navigator.pushNamed(context, '/');
        break;
      case "Dashboard":
        Navigator.pushNamed(context, '/DashboardPage');
        break;
      case "Resources Management":
        Navigator.pushNamed(context, '/resources_management');
        break;
      case "Career Guidance":
        Navigator.pushNamed(context, '/CareerGuidancePage');
        break;
      case "Interview Prep":
        Navigator.pushNamed(context, '/InterviewPrepPage');
        break;
      case "CV Guidance":
        Navigator.pushNamed(context, '/CVGuidancePage');
        break;
      case "Career Bank":
        Navigator.pushNamed(context, '/CareerBankPage');
        break;
      case "Success Stories":
        Navigator.pushNamed(context, '/SuccessStoriesPage');
        break;
      case "Contact":
        Navigator.pushNamed(context, '/contact');
        break;
      case "Quiz Management":
        Navigator.pushNamed(context, '/quiz_management'); // ⚠️ Confirm this is correct
        break;
      case "Notifications":
        Navigator.pushNamed(context, '/ManagePushNotificationsPage');
        break;
      case "User Management":
        Navigator.pushNamed(context, '/user_management');
        break;
      case "Analytics":
        Navigator.pushNamed(context, '/analytics');
        break;
      case "Login":
        Navigator.pushNamed(context, '/login');
        break;
      case "Logout":
        Navigator.pushNamed(context, '/logout');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || selectedSideMenu == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 User Info Card
                InfoCard(
                  name: userName ?? "Unknown",
                  bio: userBio ?? "No bio",
                ),

                // 🧭 Browse Section
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                  child: Text(
                    "Browse".toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70),
                  ),
                ),

                // ✅ Single Dynamic Menu Section
                ..._getSidebarMenus().map(
                  (menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu!,
                    press: () {
                      RiveUtils.changeSMIBoolState(menu.rive.status!);
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      _navigateToPage(context, menu.title);
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(
                        artboard,
                        stateMachineName: menu.rive.stateMachineName,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // Add cleanup logic here if needed (e.g., stream subscriptions)
  }
}