// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'onboarding_screen.dart'; // Import your onboarding screen
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _dotController;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Start dot animation
//     _dotController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     )..repeat(reverse: true);
//
//     _animation = Tween<double>(
//       begin: 0,
//       end: 8,
//     ).animate(CurvedAnimation(parent: _dotController, curve: Curves.easeInOut));
//
//     // Wait 3 seconds, then navigate
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const OnboardingScreen()),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _dotController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Logo
//             Image.asset(
//               'assets/images/Logo.png',
//               width: 300,
//               height: 300,
//
//             ),
//             const SizedBox(height: 24),
//             // Wobbling dots
//             AnimatedBuilder(
//               animation: _animation,
//               builder: (context, child) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(3, (index) {
//                     return Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       width: 10,
//                       height: 10,
//                       transform: Matrix4.translationValues(
//                         0,
//                         _animation.value * (index % 2 == 0 ? 1 : -1),
//                         0,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         shape: BoxShape.circle,
//                       ),
//                     );
//                   }),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // Import your onboarding screen

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

    // Start dot animation
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(parent: _dotController, curve: Curves.easeInOut));

    // Wait 3 seconds, then navigate
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  ? 'assets/logo/LogoDark.1.png'  // Add this asset for dark mode
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
