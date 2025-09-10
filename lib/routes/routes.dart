import 'package:flutter/material.dart';
import 'package:bookstore_app/screens/contact_us_page.dart';
import 'package:bookstore_app/screens/home_page.dart';
import 'package:bookstore_app/screens/auth_page.dart';
import 'package:bookstore_app/pages/auth/logout.dart';
import 'package:bookstore_app/screens/about_us_page.dart';
import 'package:bookstore_app/screens/faq_page.dart';
import 'package:bookstore_app/screens/search_page.dart';
import 'package:bookstore_app/screens/manage_book_page.dart';
import 'package:bookstore_app/screens/cart_page.dart';
import 'package:bookstore_app/screens/wish_page.dart';
import 'package:bookstore_app/screens/order_page.dart';
import 'package:bookstore_app/screens/profile_page.dart';
import 'package:bookstore_app/screens/book_detail_page.dart';
import 'package:bookstore_app/screens/manage_category_page.dart';
import 'package:bookstore_app/screens/manage_order_page.dart';
import 'package:bookstore_app/screens/manage_contact_us_page.dart';

// Public routes (no authentication required)
final Map<String, WidgetBuilder> publicRoutes = {
  '/': (context) => const HomePage(),
  '/auth': (context) => const AuthPage(),
  '/contact-us': (context) => const ContactUsPage(),
  '/about-us': (context) => const AboutUsPage(),
  '/faq': (context) => const FAQPage(),
  '/search': (context) => const SearchPage(),
  '/book-detail':
      (context) => BookDetailPage(
        bookKey:
            (ModalRoute.of(context)?.settings.arguments as Map?)?['bookKey'] ??
            '',
      ),
};

// Protected routes (authentication required)
final Map<String, WidgetBuilder> protectedRoutes = {
  '/logout': (context) => const Logout(),
  '/cart': (context) => const CartPage(),
  '/wishlist': (context) => const WishPage(),
  '/order': (context) => const OrderPage(),
  '/profile': (context) => const ProfilePage(),
};

// Admin routes (admin access required)
final Map<String, WidgetBuilder> adminRoutes = {
  '/manage-categories': (context) => const ManageCategoryPage(),
  '/manage-orders': (context) => const ManageOrderPage(),
  '/manage-books': (context) => const ManageBookPage(),
  '/manage-contact-us': (context) => const ManageContactUsPage(),
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
