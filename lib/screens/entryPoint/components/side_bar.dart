import 'package:aspire_edge/screens/entryPoint/components/info_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/services/user_dao.dart';
import '../../../models/menu.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? userName;
  String? userBio = "Loading...";
  String? userRole;
  bool _isLoading = true;
  Menu? selectedSideMenu;

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

      setState(() {
        userName = displayName;
        userBio = "Member";
        userRole = "User";
        _isLoading = false;
        selectedSideMenu = _getSidebarMenus().first;
      });
    } else {
      setState(() {
        userName = "Guest";
        userBio = "Not logged in";
        userRole = null;
        _isLoading = false;
        selectedSideMenu = _getSidebarMenus().first;
      });
    }
  }

  List<Menu> _getSidebarMenus() {
    if (userRole == "admin") {
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
      case "Manage Testimonials":
        Navigator.pushNamed(context, '/testimonials_management');
        break;
      case "Dashboard":
        Navigator.pushNamed(context, '/DashboardPage');
        break;
      case "Resources Management":
        Navigator.pushNamed(context, '/resources_management');
        break;
      case "Stream selector":
        Navigator.pushNamed(context, '/StreamSelectorPage');
        break;
      case "Career Guidance":
        Navigator.pushNamed(context, '/CareerGuidancePage');
        break;
      case "Manage Career Questions":
        Navigator.pushNamed(context, '/career_questions_management');
        break;
      case "Manage Stream Questions":
        Navigator.pushNamed(context, '/stream_questions_management');
        break;
      case "Testemonials":
        Navigator.pushNamed(context, '/WriteTestimonialPage');
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
        Navigator.pushNamed(context, '/quiz_management');
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
      default:
        debugPrint("Unknown menu title: $title");
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
                InfoCard(
                  name: userName ?? "Unknown",
                  bio: userBio ?? "No bio",
                ),
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
                ..._getSidebarMenus().map(
                  (menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu!,
                    press: () {
                      setState(() {
                        selectedSideMenu = menu;
                      });
                      _navigateToPage(context, menu.title);
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
  }
}
