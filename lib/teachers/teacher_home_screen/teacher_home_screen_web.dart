import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../constants/colors.dart';
import '../../students/class_join.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';
import '../teacher_attendance/teacher_attendance.dart';

class TeacherHomeScreenWeb extends StatefulWidget {
  const TeacherHomeScreenWeb({super.key});

  @override
  State<TeacherHomeScreenWeb> createState() => _TeacherHomeScreenWebState();
}

class _TeacherHomeScreenWebState extends State<TeacherHomeScreenWeb> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    fetchTeacherName();
  }

  Future<void> fetchTeacherName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          fullName = doc.data()?['fullName'] ?? 'Teacher';
        });
      } else {
        setState(() {
          fullName = 'Teacher';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Sidebar(selectedIndex: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Welcome, ${fullName ?? "..."}!',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentNotificationScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFe5faf3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Welcome back, ${fullName ?? "Teacher"}! Your next class starts in 2 hours.',
                                  style: const TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mark Attendance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    _WebClassCard(
                                      title: 'Math - Algebra Basics',
                                      time: '10:00 AM - 11:00 AM',
                                      teacher: 'Daniel',
                                      text: 'Mark',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Today's Classes",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(height: 12),
                                _WebClassCard(
                                  title: 'Math - Algebra Basics',
                                  time: '10:00 AM - 11:00 AM',
                                  teacher: 'Mr. Daniel',
                                  text: 'Join Class',
                                ),
                                SizedBox(height: 12),
                                _WebClassCard(
                                  title: 'Science - Biology Basics',
                                  time: '11:30 AM - 12:30 PM',
                                  teacher: 'Ms. Emily',
                                  text: 'Join Class',
                                ),
                                SizedBox(height: 32),
                                Text(
                                  'Recent Conversations',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                SizedBox(height: 12),
                                _WebConversationCard(
                                  name: 'Miss Sarah',
                                  message: 'Reminder: Assignment due tomorrow.',
                                  time: '2 min ago',
                                ),
                                SizedBox(height: 8),
                                _WebConversationCard(
                                  name: 'Mr. John',
                                  message: 'Your feedback is due this week!',
                                  time: '5 min ago',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebClassCard extends StatelessWidget {
  final String title;
  final String time;
  final String teacher;
  final String text;

  const _WebClassCard({
    required this.title,
    required this.time,
    required this.teacher,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
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
              child: Icon(Iconsax.teacher, color: appGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(time, style: const TextStyle(fontSize: 14)),
                  Text(teacher, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                if (text == 'Mark') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TeacherAttendanceScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ConnectingToClassScreen()),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: appGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(text),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebConversationCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;

  const _WebConversationCard({
    required this.name,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFe5faf3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Iconsax.user, color: appGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(message, style: const TextStyle(fontSize: 14)),
                  Text(time, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
