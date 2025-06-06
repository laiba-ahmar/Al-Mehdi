import 'package:al_mehdi_online_school/teachers/teacher_settings/teacher_settings_mobile.dart';
import 'package:al_mehdi_online_school/teachers/teacher_settings/teacher_settings_web.dart';
import 'package:flutter/material.dart';

class TeacherSettingsScreen extends StatelessWidget {
  const TeacherSettingsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Desktop Layout
          return TeacherSettingsScreenWeb();
        } else {
          // Mobile Layout
          return TeacherSettingsScreenMobile();
        }
      },
    );
  }
}

