import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/profile_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/settings_screen.dart';
import 'package:flutter/material.dart';
import '../../../components/custom_bottom_nabigator.dart';
import '../admin_home_screen.dart';
import 'attendance_screen.dart';
import 'chat_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    MobileVersion(),
    ChatScreen(),
    AttendanceScreen(),
    ProfileScreen(),
    SettingsScreen(),
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
            _selectedIndex = 0; // Navigate back to Home
          });
          return false; // Prevent exiting the app
        }
        return true; // Exit app if already on Home
      },
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: Navbar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

