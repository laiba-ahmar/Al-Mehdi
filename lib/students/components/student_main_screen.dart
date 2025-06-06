import 'package:al_mehdi_online_school/students/components/student_navbar.dart';
import 'package:flutter/material.dart';
import '../student_chat/student_chat.dart';
import '../student_classes/student_classes.dart';
import '../student_home_screen/student_home_screen_mobile.dart';
import '../student_profile/student_profile.dart';
import '../student_settings/student_settings.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    StudentHomeScreenMobile(),
    StudentClassesScreen(),
    StudentChatScreen(),
    StudentSettingsScreen(),
    StudentProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0; // Navigate to Home instead of exiting
          });
          return false; // Prevent the app from closing
        }
        return true; // Exit the app if already on Home
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: StudentNavbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
