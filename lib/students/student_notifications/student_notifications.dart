import 'package:al_mehdi_online_school/students/student_notifications/student_notifications_mobile.dart';
import 'package:al_mehdi_online_school/students/student_notifications/student_notifications_web.dart';
import 'package:flutter/material.dart';

class StudentNotificationScreen extends StatefulWidget {
  const StudentNotificationScreen({super.key});

  @override
  State<StudentNotificationScreen> createState() => _StudentNotificationScreenState();
}

class _StudentNotificationScreenState extends State<StudentNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return const StudentNotificationWebView();
          } else {
            return const StudentNotificationMobileView();
          }
        }
    );
  }
}
