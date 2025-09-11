import 'package:aspire_edge/screens/entryPoint/entry_point.dart';
import 'package:aspire_edge/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:aspire_edge/screens/onboding/onboding_screen.dart';
import 'package:aspire_edge/screens/profile_screen.dart';

// Public routes (no authentication required)
final Map<String, WidgetBuilder> publicRoutes = {
  '/auth': (context) => const OnbodingScreen(),
  '/': (context) => EntryPoint(child: const HomePage()),
};

// Protected routes (authentication required)
final Map<String, WidgetBuilder> protectedRoutes = {
  '/profile': (context) => EntryPoint(child: const ProfileScreen()),
};

// Admin routes (admin access required)
final Map<String, WidgetBuilder> adminRoutes = {

};

// Combined routes map
final Map<String, WidgetBuilder> routes = {
  ...publicRoutes,
  ...protectedRoutes,
  ...adminRoutes,
};

// List of routes that do NOT require authentication
const List<String> unprotectedRoutes = [
  '/',
  '/auth',
  '/contact-us',
  '/about-us',
  '/search',
  '/faq',
  '/book-detail',
];

// List of routes that DO require authentication
const List<String> protectedRoutesList = [
  '/logout',
  '/cart',
  '/wishlist',
  '/order',
  '/profile',
];

// List of routes that ONLY admin users can access
const List<String> adminOnlyRoutes = [
  '/manage-books',
  '/manage-categories',
  '/manage-orders',
  '/manage-contact-us',
];
