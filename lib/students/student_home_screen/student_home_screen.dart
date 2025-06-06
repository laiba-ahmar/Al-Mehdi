import 'package:al_mehdi_online_school/students/components/student_main_screen.dart';
import 'package:al_mehdi_online_school/students/student_home_screen/student_home_screen_web.dart';
import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Web/tablet layout
          return StudentHomeSreenWeb();
        } else {
          // Mobile layout
          return StudentMainScreen();
        }
      },
    );
  }
}