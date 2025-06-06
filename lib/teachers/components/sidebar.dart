import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/colors.dart';
import '../teacher_attendance/teacher_attendance.dart';
import '../teacher_chat/teacher_chat.dart';
import '../teacher_classes_screen/teacher_classes.dart';
import '../teacher_home_screen/teacher_home_screen.dart';
import '../teacher_profile/teacher_profile.dart';
import '../teacher_settings/teacher_settings.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;

  const Sidebar({
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
                  builder: (context) => const TeacherHomeScreen(),
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
                  builder: (context) => const TeacherClassesScreen(),
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
                  builder: (context) => const TeacherAttendanceScreen(),
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
                  builder: (context) => const TeacherChatScreen(),
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
                  builder: (context) => const TeacherSettingsScreen(),
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
                  builder: (context) => TeacherProfileScreen(),
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