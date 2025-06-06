import 'package:al_mehdi_online_school/teachers/teacher_schedule_class/teacher_schedule_class_mobile.dart';
import 'package:al_mehdi_online_school/teachers/teacher_schedule_class/teacher_schedule_class_web.dart';
import 'package:flutter/material.dart';

class ScheduleClassesScreen extends StatelessWidget {
  const ScheduleClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          // Web/tablet layout
          return TeacherScheduleClassWeb();
        } else {
          // Mobile layout
          return TeacherScheduleClassMobile();
        }
      },
    );
  }
}
