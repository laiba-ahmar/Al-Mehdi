import 'package:al_mehdi_online_school/teachers/teacher_profile/teacher_profile_mobile.dart';
import 'package:al_mehdi_online_school/teachers/teacher_profile/teacher_profile_web.dart';
import 'package:flutter/material.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Desktop Layout
          return TeacherProfileWeb();
        } else {
          // Mobile Layout
          return TeacherProfileMobile();
        }
      },
    );
  }
}

