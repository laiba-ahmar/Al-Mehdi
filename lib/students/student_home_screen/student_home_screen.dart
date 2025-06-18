import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:al_mehdi_online_school/students/components/student_main_screen.dart';

// Conditional import
import 'student_home_screen_stub.dart'
    if (dart.library.html) 'student_home_screen_web.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return StudentHomeSreenWeb();
    } else {
      return StudentMainScreen();
    }
  }
}