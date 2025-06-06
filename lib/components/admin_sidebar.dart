import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/attendance_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/chat_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/profile_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/schedule_class.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/colors.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Color(0xFFe5faf3),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          _SidebarItem(
            icon: Icons.home,
            label: 'Home',
            selected: selectedIndex == 0,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 3),
          _SidebarItem(
            icon: Iconsax.teacher,
            label: 'Classes',
            selected: selectedIndex == 1,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduleClass(),
                ),
              );
            },
          ),
          const SizedBox(height: 3),
          _SidebarItem(
            icon: Icons.bar_chart,
            label: 'Attendance',
            selected: selectedIndex == 2,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 3),
          _SidebarItem(
            icon: Icons.chat,
            label: 'Chat',
            selected: selectedIndex == 3,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 3),
          _SidebarItem(
            icon: Icons.settings,
            label: 'Settings',
            selected: selectedIndex == 4,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 3),
          _SidebarItem(
            icon: Iconsax.user,
            label: 'Profile',
            selected: selectedIndex == 5,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: selected ? appGreen : Colors.black),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? appGreen : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}