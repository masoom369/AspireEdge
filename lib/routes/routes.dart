import 'package:aspire_edge/screens/admin/career_questions_management_page.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/screens/onboarding/onboarding_screen.dart';
import 'package:aspire_edge/screens/entryPoint/entry_point.dart';
import 'package:aspire_edge/screens/home_page.dart';
import 'package:aspire_edge/screens/about_us_page.dart';
import 'package:aspire_edge/screens/contact_us_page.dart';
import 'package:aspire_edge/screens/profile_page.dart';
import 'package:aspire_edge/screens/logout_page.dart';
import 'package:aspire_edge/screens/bookmark_page.dart';
import 'package:aspire_edge/screens/wishlist_page.dart';
import 'package:aspire_edge/screens/notification_home_page.dart';
import 'package:aspire_edge/screens/resources_hub_page.dart';
import 'package:aspire_edge/screens/write_testimonials_page.dart';
import 'package:aspire_edge/screens/stream_guidance_page.dart';
import 'package:aspire_edge/screens/career_guidance_page.dart';
import 'package:aspire_edge/screens/career_bank_page.dart';
import 'package:aspire_edge/screens/interview_preparation_page.dart';
import 'package:aspire_edge/screens/cv_guidance_page.dart';
import 'package:aspire_edge/screens/push_notification_screen.dart';
import 'package:aspire_edge/screens/dashboard_screen.dart';

// Admin pages
import 'package:aspire_edge/screens/admin/notification_management_page.dart';
import 'package:aspire_edge/screens/admin/career_management_page.dart';
import 'package:aspire_edge/screens/admin/stream_management_page.dart';
import 'package:aspire_edge/screens/admin/feedback_management_page.dart';
import 'package:aspire_edge/screens/admin/quiz_management_page.dart';
import 'package:aspire_edge/screens/admin/resources_management_page.dart';
import 'package:aspire_edge/screens/admin/testimonial_management_page.dart';
import 'package:aspire_edge/screens/admin/wishlist_management_page.dart';

import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/services/user_dao.dart';

final AuthService _authService = AuthService();
final UserDao _userDao = UserDao();

/// ==========================
/// PUBLIC ROUTES
/// ==========================
final Map<String, WidgetBuilder> publicRoutes = {
  '/auth': (context) => const OnboardingScreen(),
};

/// ==========================
/// PROTECTED ROUTES
/// ==========================
final Map<String, WidgetBuilder> protectedRoutes = {
  '/': (context) => EntryPoint(child: const HomePage()),
  '/about': (context) => EntryPoint(child: const AboutUsPage()),
  '/contact': (context) => EntryPoint(child: const ContactUsPage()),
  '/profile': (context) => EntryPoint(child: const ProfilePage()),
  '/logout': (context) => EntryPoint(child: const LogoutPage()),

  '/bookmark': (context) => EntryPoint(child: const BookmarksPage()),
  '/wishlist': (context) => EntryPoint(child: const WishlistPage()),
  '/notification': (context) => EntryPoint(child: const NotificationHomePage()),
  '/resources': (context) => EntryPoint(child: ResourcesHubPage()),

  '/write_testimonial': (context) =>
      EntryPoint(child: const WriteTestimonialsPage()),
  '/stream_guidance': (context) =>
      EntryPoint(child: const StreamGuidancePage()),
  '/career_guidance': (context) =>
      EntryPoint(child: const CareerGuidancePage()),
  '/career_bank': (context) => EntryPoint(child: CareerBankPage()),
  '/interview_preparation': (context) =>
      EntryPoint(child: const InterviewPrepPage()),
  '/cv_guidance': (context) => EntryPoint(child: const CVGuidancePage()),

  '/manage_push_notifications': (context) =>
      EntryPoint(child: const ManagePushNotificationsPage()),

  '/dashboard': (context) => FutureBuilder<String?>(
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

      final role = snapshot.data ?? "user";
      return EntryPoint(child: DashboardPage(role: role));
    },
  ),
};

/// ==========================
/// ADMIN ROUTES
/// ==========================
final Map<String, WidgetBuilder> adminRoutes = {
  '/career_questions_management': (context) =>
      EntryPoint(child: const CareerQuestionsPage()),
  '/notification_management': (context) =>
      EntryPoint(child: const NotificationManagementPage()),
  '/career_management': (context) => EntryPoint(child: CareerManagementPage()),
  '/stream_management': (context) =>
      EntryPoint(child: const StreamManagementPage()),
  '/feedback_management': (context) =>
      EntryPoint(child: const FeedbackManagementPage()),
  '/quiz_management': (context) => EntryPoint(child: QuizManagementPage()),
  '/resources_management': (context) =>
      EntryPoint(child: const ResourcesManagementPage()),
  '/testimonial_management': (context) =>
      EntryPoint(child: const TestimonialManagementPage()),
  '/wishlist_management': (context) =>
      EntryPoint(child: const WishlistManagementPage()),
};

/// ==========================
/// MERGED ROUTES
/// ==========================
final Map<String, WidgetBuilder> routes = {
  ...publicRoutes,
  ...protectedRoutes,
  ...adminRoutes,
};

/// ==========================
/// ROUTE ACCESS LISTS
/// ==========================
const List<String> unprotectedRoutes = ['/auth'];

const List<String> protectedRoutesList = [
  '/', // Home
  '/about',
  '/contact',
  '/profile',
  '/logout',

  '/bookmark',
  '/wishlist',
  '/notification',
  '/resources',

  '/write_testimonial',
  '/stream_guidance',
  '/career_guidance',
  '/career_bank',
  '/interview_preparation',
  '/cv_guidance',

  '/manage_push_notifications',
  '/dashboard',
];

const List<String> adminOnlyRoutes = [
  '/notification_management',
  '/career_management',
  '/career_questions_management',
  '/stream_management',
  '/feedback_management',
  '/quiz_management',
  '/resources_management',
  '/testimonial_management',
  '/wishlist_management',
];
