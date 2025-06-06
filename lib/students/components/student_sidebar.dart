import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/colors.dart';
import '../student_attendance/student_attendance.dart';
import '../student_chat/student_chat.dart';
import '../student_classes/student_classes.dart';
import '../student_home_screen/student_home_screen.dart';
import '../student_profile/student_profile.dart';
import '../student_settings/student_settings.dart';

class StudentSidebar extends StatelessWidget {
  final int selectedIndex;

  const StudentSidebar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: appLightGreen,
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
                  builder: (context) => const StudentHomeScreen(),
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
                  builder: (context) => const StudentClassesScreen(),
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
                  builder: (context) => const StudentAttendanceScreen(),
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
                  builder: (context) => const StudentChatScreen(),
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
                  builder: (context) => const StudentSettingsScreen(),
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
                  builder: (context) => StudentProfileScreen(),
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
