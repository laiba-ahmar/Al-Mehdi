import 'dart:async';
import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Auth Screens/Main_page.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    print("🚀 Splash screen initialized");

    // Start dot animation
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(parent: _dotController, curve: Curves.easeInOut));

    // Always wait 3 seconds before checking authentication and navigating
    Timer(const Duration(seconds: 3), () {
      print("⏰ 3 seconds elapsed, checking auth...");
      _checkAuthAndNavigate();
    });
  }

  void _checkAuthAndNavigate() {
    // Check authentication status after the 3-second delay
    final user = FirebaseAuth.instance.currentUser;
    print("🔐 Auth check - User: ${user?.uid ?? 'null'}");

    if (user != null) {
      // User is logged in, navigate to main app
      print("✅ User logged in, navigating to MainPage");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      // User is not logged in, navigate to onboarding
      print("❌ User not logged in, navigating to OnboardingScreen");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("🎨 Splash screen building...");

    // Detect if in dark mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use different logos for dark and light mode if available
            Image.asset(
              isDarkMode
                  ? 'assets/logo/LogoDark.1.png' // Add this asset for dark mode
                  : 'assets/images/Logo.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 24),
            // Wobbling dots
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      transform: Matrix4.translationValues(
                        0,
                        _animation.value * (index % 2 == 0 ? 1 : -1),
                        0,
                      ),
                      decoration: BoxDecoration(
                        color: appGreen,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
