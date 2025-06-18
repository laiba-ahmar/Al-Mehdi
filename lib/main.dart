import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // ✅ Import generated config
import 'Screens/StartingScreens/splash_screen.dart';

// ✅ Global theme notifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set persistence to LOCAL to maintain login state across page refreshes (web only)
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
    print("✅ Firebase initialized with persistence (web)");
  } else {
    print("✅ Firebase initialized (mobile)");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Al - Mehdi Online School',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              displayLarge: TextStyle(color: Colors.black),
              displayMedium: TextStyle(color: Colors.black),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.black,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.white,
            dividerTheme: DividerThemeData(color: Colors.grey),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: appGreen,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: appGreen,
              unselectedItemColor: Colors.black,
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
            ),
          ),
          darkTheme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            appBarTheme: AppBarTheme(
              backgroundColor: darkBackground,
              surfaceTintColor: Colors.transparent,
              foregroundColor: Colors.white,
            ),
            cardColor: darkBackground.withOpacity(0.95),
            shadowColor: Colors.white,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: darkBackground,
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
              displayLarge: TextStyle(color: Colors.white),
              displayMedium: TextStyle(color: Colors.white),
            ),
            dividerTheme: DividerThemeData(color: Colors.grey),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: appGreen,
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: darkBackground,
              selectedItemColor: appGreen,
              unselectedItemColor: Colors.white,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
            ),
          ),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
