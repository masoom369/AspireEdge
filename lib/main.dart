import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:aspire_edge/routes/route_guard.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  if (!kIsWeb) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  }


  if (!kIsWeb) {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("bfd0fb79-5c68-441e-b78d-063271b0d492");


    OneSignal.Notifications.requestPermission(true);


    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
     // debugPrint("Foreground Notification: ${event.notification.jsonRepresentation()}");
    });


    // Commented out to fix MissingPluginException for OneSignal#addNativeClickListener
    // OneSignal.Notifications.addClickListener((event) {
    //   debugPrint("Notification opened: ${event.notification.jsonRepresentation()}");
    // });
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
      onGenerateRoute: guardedRoute,
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
      ),
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

class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // disables scrollbar
  }
}

