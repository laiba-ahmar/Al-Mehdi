import 'package:al_mehdi_online_school/teachers/components/teacher_main_screen.dart';
import 'package:al_mehdi_online_school/teachers/teacher_home_screen/teacher_home_screen_mobile.dart';
import 'package:al_mehdi_online_school/teachers/teacher_home_screen/teacher_home_screen_web.dart';
import 'package:flutter/material.dart';

class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Web/tablet layout
          return TeacherHomeScreenWeb();
        } else {
          // Mobile layout
          return TeacherMainScreen();
        }
      },
    );
  }

}