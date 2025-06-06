import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../constants/colors.dart';
import '../class_join.dart';
import '../components/student_navbar.dart';
import '../student_attendance/student_attendance.dart';
import '../student_notifications/student_notifications.dart';

class StudentHomeScreenMobile extends StatefulWidget {
  const StudentHomeScreenMobile({super.key});

  @override
  State<StudentHomeScreenMobile> createState() => _StudentHomeScreenMobileState();
}

class _StudentHomeScreenMobileState extends State<StudentHomeScreenMobile> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    fetchStudentName();
  }

  Future<void> fetchStudentName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'] ?? 'Student';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  fullName != null ? '👋 Welcome, $fullName!' : '👋 Welcome, Student!',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StudentNotificationScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _InfoCard(
                icon: Iconsax.teacher,
                title: 'Upcoming Class',
                subtitle: 'Math with Miss Mahreen - 10:00 AM',
                buttonText: 'Join',
                onButtonPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ConnectingToClassScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _InfoCard(
                icon: Icons.chat,
                title: 'Recent Chats',
                subtitle: '2 new messages',
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StudentAttendanceScreen()),
                  );
                },
                child: _InfoCard(
                  icon: Icons.bar_chart,
                  title: 'Attendance',
                  subtitleWidget: Row(
                    children: const [
                      Text('Today: Present', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 6),
                      Icon(Icons.circle, color: appGreen, size: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ConnectingToClassScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Join Class',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const _InfoCard({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).shadowColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFe5faf3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, color: appGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  subtitleWidget ??
                      (subtitle != null
                          ? Text(subtitle!, style: const TextStyle(fontSize: 14))
                          : const SizedBox()),
                  if (buttonText != null && onButtonPressed != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: onButtonPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 0,
                        ),
                        child: Text(
                          buttonText!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
