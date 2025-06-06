// import 'package:flutter/material.dart';
// import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_mian_screen.dart';
// import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/chat_screen.dart';
// import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/attendance_screen.dart';
// import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/profile_screen.dart';
// import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/settings_screen.dart';
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//
//   const CustomBottomNavigationBar({super.key, required this.currentIndex});
//
//   void _onTap(BuildContext context, int index) {
//     if (index == currentIndex) return; // already on this screen
//
//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminHomeScreen()));
//         break;
//       case 1:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
//         break;
//       case 2:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AttendanceScreen()));
//         break;
//       case 3:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
//         break;
//       case 4:
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex, // Highlights the selected item
//       type: BottomNavigationBarType.fixed,
//       showSelectedLabels: true,
//       showUnselectedLabels: true,
//       selectedLabelStyle: const TextStyle(fontSize: 12),
//       unselectedLabelStyle: const TextStyle(fontSize: 12),
//       selectedIconTheme: const IconThemeData(size: 24),
//       unselectedIconTheme: const IconThemeData(size: 24),
//       onTap: (index) => _onTap(context, index),
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
//         BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Attendance'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      selectedIconTheme: const IconThemeData(size: 24),
      unselectedIconTheme: const IconThemeData(size: 24),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Attendance'),
        BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}

