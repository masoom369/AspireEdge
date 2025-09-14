import 'package:aspire_edge/screens/cv_guidance_page.dart';
import 'package:aspire_edge/screens/career_guidance_page.dart';
import 'package:aspire_edge/screens/interview_preparation_page.dart';
import 'package:aspire_edge/screens/notification_home_page.dart';
import 'package:aspire_edge/screens/stream_selector_screen.dart';
import 'package:aspire_edge/screens/write_testimonial_screen.dart';
import 'package:aspire_edge/screens/about_us.dart';
import 'package:aspire_edge/screens/admin/admin_notification_page.dart';
import 'package:aspire_edge/screens/admin/admin_career_questions_page.dart';
import 'package:aspire_edge/screens/admin/admin_stream_questions_page.dart';
import 'package:aspire_edge/screens/admin/career_bank_management_screen.dart';
import 'package:aspire_edge/screens/admin/feedback_management_screen.dart';
import 'package:aspire_edge/screens/admin/quiz_management_screen.dart';
import 'package:aspire_edge/screens/admin/resources_hub_management_screen.dart';
import 'package:aspire_edge/screens/admin/testimonial_management_screen.dart';
import 'package:aspire_edge/screens/admin/wishlist_management_screen.dart';
import 'package:aspire_edge/screens/bookmark_page.dart';
import 'package:aspire_edge/screens/dashboard_screen.dart';
import 'package:aspire_edge/screens/career_bank.dart';
import 'package:aspire_edge/screens/contact_us.dart';
import 'package:aspire_edge/screens/entryPoint/entry_point.dart';
import 'package:aspire_edge/screens/home_page.dart';
import 'package:aspire_edge/screens/logout_screen.dart';
import 'package:aspire_edge/screens/push_notification_screen.dart';
import 'package:aspire_edge/screens/resource_hub_screen.dart';
import 'package:aspire_edge/screens/wishlist.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/services/user_dao.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/screens/onboarding/onboarding_screen.dart';
import 'package:aspire_edge/screens/profile_screen.dart';


final Map<String, WidgetBuilder> publicRoutes = {
  '/auth': (context) => const OnboardingScreen(),
};
final AuthService _authService = AuthService();
final UserDao _userDao = UserDao();


final Map<String, WidgetBuilder> protectedRoutes = {
  '/contact': (context) => EntryPoint(child: const ContactUsPage()),
  '/bookmark': (context) => EntryPoint(child: const BookmarksPage()),
  '/wishlist': (context) => EntryPoint(child: const WishlistPage()),
  '/notification': (context) => EntryPoint(child: const NotificationHomePage()),
  '/notification_management': (context) =>
      EntryPoint(child: const AdminNotificationPage()),
  '/ResourcesHubPage': (context) => EntryPoint(child: ResourcesHubPage()),
  '/wishlist_management': (context) =>
      EntryPoint(child: const AdminWishlistPage()),
  '/about': (context) => EntryPoint(child: const AboutUsPage()),
  '/WriteTestimonialPage': (context) =>
      EntryPoint(child: const WriteTestimonialPage()),
  '/StreamSelectorPage': (context) =>
      EntryPoint(child: const StreamSelectorPage()),
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


final Map<String, WidgetBuilder> adminRoutes = {
  '/career_management': (context) => EntryPoint(child: CareerManagementPage()),
  '/quiz_management': (context) => EntryPoint(child: ManageQuizPage()),
  '/resources_management': (context) =>
      EntryPoint(child: ManageResourcesHubPage()),
  '/testimonials_management': (context) =>
      EntryPoint(child: ManageTestimonialsPage()),
  '/stream_questions_management': (context) =>
      EntryPoint(child: AdminStreamQuestionsPage()),
  '/career_questions_management': (context) =>
      EntryPoint(child: AdminCareerQuestionsPage()),
  '/feedback_management': (context) => EntryPoint(child: ManageFeedbackPage()),
};


final Map<String, WidgetBuilder> routes = {
  ...publicRoutes,
  ...protectedRoutes,
  ...adminRoutes,
};


const List<String> unprotectedRoutes = ['/auth'];


const List<String> protectedRoutesList = ['/profile', '/', '/logout'];


const List<String> adminOnlyRoutes = [
  '/quiz_management',
  '/resources_management',
  '/career_questions_management',
  '/testimonials_management',
  '/feedback_management',
  '/user_management',
  '/career_management',
  '/stream_questions_management',
];

