import 'package:al_mehdi_online_school/students/student_chat/student_chat_mobile.dart';
import 'package:al_mehdi_online_school/students/student_chat/student_chat_web.dart';
import 'package:flutter/material.dart';

class StudentChatScreen extends StatelessWidget {
  const StudentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return const StudentChatWebView();
        } else {
          return const StudentChatMobileView();
        }
      },
    );
  }
}
