import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:aspire_edge/routes/route_guard.dart';
// import 'package:google_fonts/google_fonts.dart';  // Uncomment if you want Google Fonts

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Enable offline persistence for Realtime Database on non-web platforms
  if (!kIsWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aspire Edge',
      debugShowCheckedModeBanner: false,

      // Apply your custom theme based on your template
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),

        // If you want to keep ColorScheme from your Firebase app, you can merge here:
        // colorScheme: ColorScheme.fromSeed(seedColor: blackberry),
        // useMaterial3: true,

        // If you want to use Google Fonts instead of Intel font, do this:
        // textTheme: GoogleFonts.emilysCandyTextTheme(),
      ),

      onGenerateRoute: guardedRoute, // keep your routing
      builder: (context, child) => ScrollConfiguration(
        behavior: NoScrollbarBehavior(),
        child: child!,
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);

// Custom ScrollBehavior to remove scrollbars (from your Firebase app)
class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // disables scrollbar
  }
}
