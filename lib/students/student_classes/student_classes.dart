import 'package:al_mehdi_online_school/students/student_classes/student_classes_mobile.dart';
import 'package:al_mehdi_online_school/students/student_classes/student_classes_web.dart';
import 'package:flutter/material.dart';

class StudentClassesScreen extends StatelessWidget {
  const StudentClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return const StudentClassesWebView();
        } else {
          return const StudentClassesMobileView();
        }
      },
    );
  }
}