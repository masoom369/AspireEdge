import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:aspire_edge/services/auth_service.dart';
import 'package:aspire_edge/services/user_dao.dart';

Future<bool> _isAuthenticated() async {

  return AuthService().currentUser != null;
}


Future<String?> _getUserRole() async {
  final user = AuthService().currentUser;
  if (user == null) return null;

  return await UserDao().getUserRole(user.uid);
}

Route<dynamic>? guardedRoute(RouteSettings settings) {
  final String? name = settings.name;
  final builder = routes[name];


  if (builder == null) {
    return MaterialPageRoute(
      builder:
          (_) => const Scaffold(body: Center(child: Text('Unknown route'))),
    );
  }


  if (unprotectedRoutes.contains(name)) {
    return MaterialPageRoute(builder: builder);
  }


  if (adminOnlyRoutes.contains(name)) {
    return MaterialPageRoute(
      builder:
          (context) => FutureBuilder<bool>(
            future: _isAuthenticated(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.data!) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/auth');
                });
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return FutureBuilder<String?>(
                future: _getUserRole(),
                builder: (context, roleSnapshot) {
                  if (!roleSnapshot.hasData) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (roleSnapshot.data != 'admin') {

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed('/auth');
                    });
                    return const Scaffold(
                      body: Center(child: Text('Access denied: Admins only')),
                    );
                  }

                  return builder(context);
                },
              );
            },
          ),
    );
  }


  if (protectedRoutesList.contains(name)) {
    return MaterialPageRoute(
      builder:
          (context) => FutureBuilder<bool>(
            future: _isAuthenticated(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.data!) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/auth');
                });
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return builder(context);
            },
          ),
    );
  }


  return MaterialPageRoute(builder: builder);
}

