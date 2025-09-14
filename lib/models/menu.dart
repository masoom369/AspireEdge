import 'package:flutter/material.dart';

class Menu {
  final String title;
  final IconData icon; // Change this to use an IconData instead of RiveModel

  Menu({required this.title, required this.icon});
}

// ========= ROLE-BASED MENUS =========

List<Menu> adminSidebarMenus = [
  Menu(title: "Home", icon: Icons.home),
  Menu(title: "About Us", icon: Icons.info),
  Menu(title: "Contact Us", icon: Icons.contact_mail),
  Menu(title: "Notification", icon: Icons.notifications),
  Menu(title: "Notification Management", icon: Icons.notifications),
  Menu(title: "Feedback Management", icon: Icons.feedback),
  Menu(title: "Quiz Management", icon: Icons.quiz),
  Menu(title: "Wishlist Management", icon: Icons.favorite_border),
  Menu(title: "Resources Management", icon: Icons.book),
  Menu(title: "Testimonial Management", icon: Icons.star_border),
  Menu(title: "Stream Management", icon: Icons.live_tv),
  Menu(title: "Career Management", icon: Icons.work),
  Menu(title: "Write Testimonials", icon: Icons.rate_review),
  Menu(title: "Resources Hub", icon: Icons.menu_book),
  Menu(title: "Career Bank", icon: Icons.business_center),
  Menu(title: "Interview Preparation", icon: Icons.school),
  Menu(title: "Career Guidance", icon: Icons.person_search),
  Menu(title: "Stream Guidance", icon: Icons.lightbulb),
  Menu(title: "CV Guidance", icon: Icons.insert_drive_file),
  Menu(title: "BookMark", icon: Icons.bookmark_border),
  Menu(title: "Wishlist", icon: Icons.favorite),
  Menu(title: "Logout", icon: Icons.exit_to_app),
];

// 👤 USER MENUS
// USER MENUS
List<Menu> userSidebarMenus = [
  Menu(title: "Home", icon: Icons.home),
  Menu(title: "About Us", icon: Icons.info),
  Menu(title: "Contact Us", icon: Icons.contact_mail),
  Menu(title: "Profile", icon: Icons.person),
  Menu(title: "Resources Hub", icon: Icons.menu_book),
  Menu(title: "Career Bank", icon: Icons.business_center),
  Menu(title: "Interview Preparation", icon: Icons.school),
  Menu(title: "Career Guidance", icon: Icons.person_search),
  Menu(title: "Stream Guidance", icon: Icons.lightbulb),
  Menu(title: "CV Guidance", icon: Icons.insert_drive_file),
  Menu(title: "BookMark", icon: Icons.bookmark_border),
  Menu(title: "Wishlist", icon: Icons.favorite),
  Menu(title: "Logout", icon: Icons.exit_to_app),
];

// GUEST MENUS
List<Menu> guestSidebarMenus = [
  Menu(title: "Home", icon: Icons.home),
  Menu(title: "Contact", icon: Icons.contact_mail),
  Menu(title: "Login", icon: Icons.login),
];

// BOTTOM NAV ITEMS
List<Menu> bottomNavItems = [
  Menu(title: "Home", icon: Icons.home),
  Menu(title: "Search", icon: Icons.search),
  Menu(title: "Profile", icon: Icons.person),
  Menu(title: "Notifications", icon: Icons.notifications),
  Menu(title: "Contact", icon: Icons.contact_mail),
];
