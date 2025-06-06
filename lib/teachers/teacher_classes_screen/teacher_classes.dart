import 'package:al_mehdi_online_school/teachers/teacher_classes_screen/teacher_classes_mobile.dart';
import 'package:al_mehdi_online_school/teachers/teacher_classes_screen/teacher_classes_web.dart';
import 'package:flutter/material.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return const TeacherClassesWebView();
        } else {
          return const TeacherClassesMobileView();
        }
      },
    );
  }
}
