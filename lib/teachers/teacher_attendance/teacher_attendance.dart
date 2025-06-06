import 'package:al_mehdi_online_school/teachers/teacher_attendance/teacher_attendance_mobile.dart';
import 'package:al_mehdi_online_school/teachers/teacher_attendance/teacher_attendance_web.dart';
import 'package:flutter/material.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {

  String? selectedValue;

  @override
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return TeacherAttendanceWebView(selectedValue: selectedValue, onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          });
        } else {
          return TeacherAttendanceMobileView(selectedValue: selectedValue, onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          });
        }
      },
    );
  }

}