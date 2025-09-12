import 'package:aspire_edge/screens/CV_Guidance_Page.dart';
import 'package:aspire_edge/screens/Career_Guidance_Page.dart';
import 'package:aspire_edge/screens/Interview_Preparation_Page.dart';
import 'package:aspire_edge/screens/Stream_Selector_Screen.dart';
import 'package:aspire_edge/screens/Success_Stories_Screen.dart';
import 'package:aspire_edge/screens/Write_Testimonial_Screen.dart';
import 'package:aspire_edge/screens/admin/career_bank_management_screen.dart';
import 'package:aspire_edge/screens/admin/feedback_management_screen.dart';
import 'package:aspire_edge/screens/admin/quiz_management_screen.dart';
import 'package:aspire_edge/screens/admin/resources_hub_management_screen.dart';
import 'package:aspire_edge/screens/admin/testimonial_management_screen.dart';
import 'package:aspire_edge/screens/admin/user_management_screen.dart';
import 'package:aspire_edge/screens/dashboard_screen.dart';
import 'package:aspire_edge/screens/career_bank.dart';
import 'package:aspire_edge/screens/contact_us.dart';
import 'package:aspire_edge/screens/entryPoint/entry_point.dart';
import 'package:aspire_edge/screens/home_page.dart';
import 'package:aspire_edge/screens/logout_screen.dart';
import 'package:aspire_edge/screens/push_notification_screen.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/services/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/screens/onboding/onboding_screen.dart';
import 'package:aspire_edge/screens/profile_screen.dart';

// Public routes (no authentication required)
final Map<String, WidgetBuilder> publicRoutes = {
  '/auth': (context) => const OnbodingScreen(),
};
final AuthService _authService = AuthService();
final UserDao _userDao = UserDao();

// Protected routes (authentication required)
final Map<String, WidgetBuilder> protectedRoutes = {
  '/contact': (context) => EntryPoint(child: const ContactUsPage()),
  '/about': (context) => EntryPoint(child: const ContactUsPage()),
  '/success': (context) => EntryPoint(child: const SuccessStoriesPage()),
  '/WriteTestimonialPage': (context) =>
      EntryPoint(child: const WriteTestimonialPage()),
  '/StreamSelectorPage': (context) =>
      EntryPoint(child: const StreamSelectorPage()),
  '/SuccessStoriesPage': (context) =>
      EntryPoint(child: const SuccessStoriesPage()),
  '/ManagePushNotificationsPage': (context) =>
      EntryPoint(child: const ManagePushNotificationsPage()),
  '/CareerGuidancePage': (context) =>
      EntryPoint(child: const CareerGuidancePage()),
  '/InterviewPrepPage': (context) =>
      EntryPoint(child: const InterviewPrepPage()),
  '/CareerBankPage': (context) => EntryPoint(child: CareerBankPage()),
  '/CVGuidancePage': (context) => EntryPoint(child: const CVGuidancePage()),
  '/profile': (context) => EntryPoint(child: const ProfileScreen()),
  '/logout': (context) => EntryPoint(child: const LogoutPage()),
  '/': (context) => EntryPoint(child: const HomePage()),
  '/DashboardPage': (context) => FutureBuilder<String?>(
    future: _userDao.getUserRole(_authService.currentUser!.uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      if (snapshot.hasError || !snapshot.hasData) {
        return const Scaffold(
          body: Center(child: Text("Unable to load user role")),
        );
      }

      final role = snapshot.data ?? "user"; // default if null
      return EntryPoint(child: DashboardPage(role: role));
    },
  ),
};

// Admin routes (admin access required)
final Map<String, WidgetBuilder> adminRoutes = {
  '/career_management': (context) => EntryPoint(child: CareerManagementPage()),
  '/quiz_management': (context) => EntryPoint(child: ManageQuizPage()),
  '/resources_management': (context) =>
      EntryPoint(child: ManageResourcesHubPage()),
  '/testimonials_management': (context) =>
      EntryPoint(child: ManageTestimonialsPage()),
  '/feedback_management': (context) => EntryPoint(child: ManageFeedbackPage()),
  '/user_management': (context) => EntryPoint(child: AdminUserManagementPage()),
};

// Combined routes map
final Map<String, WidgetBuilder> routes = {
  ...publicRoutes,
  ...protectedRoutes,
  ...adminRoutes,
};

// List of routes that do NOT require authentication
const List<String> unprotectedRoutes = [
  '/auth',
];

// List of routes that DO require authentication
const List<String> protectedRoutesList = ['/profile', '/', '/logout'];

// List of routes that ONLY admin users can access
const List<String> adminOnlyRoutes = [
  '/quiz_management',
  '/resources_management',
  '/testimonials_management',
  '/feedback_management',
  '/user_management',
  '/career_management',
];
