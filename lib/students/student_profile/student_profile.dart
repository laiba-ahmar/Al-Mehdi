import 'package:al_mehdi_online_school/students/student_profile/student_profile_mobile.dart';
import 'package:al_mehdi_online_school/students/student_profile/student_profile_web.dart';
import 'package:flutter/material.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Desktop Layout
          return StudentProfileWeb();
        } else {
          // Mobile Layout
          return StudentProfileMobile();
        }
      },
    );
  }
}