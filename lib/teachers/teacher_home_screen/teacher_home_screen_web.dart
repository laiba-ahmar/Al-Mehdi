import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants/colors.dart';
import '../teacher_attendance/teacher_attendance.dart';
import '../teacher_schedule_class/teacher_schedule_class.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';
import 'package:url_launcher/url_launcher.dart';

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
      final doc =
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'] ?? 'Teacher';
        });
      }
    }
  }

  String _parseTimeTo24Hour(String time) {
    final timeReg = RegExp(
      r'(\d{1,2}):(\d{2})\s*([AP]M)',
      caseSensitive: false,
    );
    final match = timeReg.firstMatch(time);
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      final minute = int.parse(match.group(2)!);
      final period = match.group(3)!.toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
    }
    return '00:00:00';
  }

  @override
  Widget build(BuildContext context) {
    final teacherUid = FirebaseAuth.instance.currentUser?.uid ?? 'no-room';
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Sidebar(selectedIndex: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 8, 32, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top bar
                  Row(
                    children: [
                      Text(
                        fullName != null
                            ? '👋 Welcome, $fullName!'
                            : '👋 Welcome, Teacher!',
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
                              builder: (context) => StudentNotificationScreen(),
                            ),
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
                        // Left column: Info and Attendance
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
                                  fullName != null
                                      ? 'Welcome back, $fullName! Your next class starts in 2 hours.'
                                      : 'Welcome back, Teacher! Your next class starts in 2 hours.',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            'Attendance Summary',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const TeacherAttendanceScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Mark",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '8 / 10 Classes Marked',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Keep up the great work! 🎉',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right column: Classes and Conversations
                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Upcoming Scheduled Classes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Fetch upcoming classes from Firestore
                                FutureBuilder<QuerySnapshot>(
                                  future:
                                      FirebaseFirestore.instance
                                          .collection('classes')
                                          .where(
                                            'teacherId',
                                            isEqualTo:
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                          )
                                          .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const Text('No upcoming classes');
                                    }
                                    final now = DateTime.now();
                                    final classes =
                                        snapshot.data!.docs.where((doc) {
                                          final data =
                                              doc.data()
                                                  as Map<String, dynamic>;
                                          final date = data['date'];
                                          final time = data['time'];
                                          DateTime? classDateTime;
                                          try {
                                            final parts = date.split('/');
                                            if (parts.length == 3) {
                                              final month = int.parse(parts[0]);
                                              final day = int.parse(parts[1]);
                                              final year = int.parse(parts[2]);
                                              final time24 = _parseTimeTo24Hour(
                                                time,
                                              );
                                              final timeParts = time24.split(
                                                ':',
                                              );
                                              final hour = int.parse(
                                                timeParts[0],
                                              );
                                              final minute = int.parse(
                                                timeParts[1],
                                              );
                                              classDateTime = DateTime(
                                                year,
                                                month,
                                                day,
                                                hour,
                                                minute,
                                              );
                                            }
                                          } catch (_) {
                                            classDateTime = null;
                                          }
                                          // Only show classes whose time is in the future (upcoming)
                                          return classDateTime != null &&
                                              (classDateTime.isAfter(now) ||
                                                  classDateTime
                                                      .isAtSameMomentAs(now));
                                        }).toList();

                                    // Sort by classDateTime ascending
                                    classes.sort((a, b) {
                                      DateTime getDateTime(
                                        QueryDocumentSnapshot doc,
                                      ) {
                                        final data =
                                            doc.data() as Map<String, dynamic>;
                                        final date = data['date'];
                                        final time = data['time'];
                                        final parts = date.split('/');
                                        if (parts.length == 3) {
                                          final month = int.parse(parts[0]);
                                          final day = int.parse(parts[1]);
                                          final year = int.parse(parts[2]);
                                          final time24 = _parseTimeTo24Hour(
                                            time,
                                          );
                                          final timeParts = time24.split(':');
                                          final hour = int.parse(timeParts[0]);
                                          final minute = int.parse(
                                            timeParts[1],
                                          );
                                          return DateTime(
                                            year,
                                            month,
                                            day,
                                            hour,
                                            minute,
                                          );
                                        }
                                        return DateTime(1970);
                                      }

                                      return getDateTime(
                                        a,
                                      ).compareTo(getDateTime(b));
                                    });

                                    if (classes.isEmpty) {
                                      return const Text('No upcoming classes');
                                    }
                                    return Column(
                                      children:
                                          classes.map((doc) {
                                            final data =
                                                doc.data()
                                                    as Map<String, dynamic>;
                                            final subject =
                                                data['subject'] ?? '';
                                            final classDate =
                                                data['date'] ?? '';
                                            final classTime =
                                                data['time'] ?? '';
                                            final jitsiRoom =
                                                data['jitsiRoom'] ?? '';
                                            final assignedStudentId =
                                                data['studentId'] ?? '';
                                            final teacherJoined =
                                                data['teacherJoined'] ?? false;

                                            // Parse classDateTime using the same logic as filtering
                                            final parts = classDate.split('/');
                                            DateTime? classDateTime;
                                            if (parts.length == 3) {
                                              final month = int.parse(parts[0]);
                                              final day = int.parse(parts[1]);
                                              final year = int.parse(parts[2]);
                                              final time24 = _parseTimeTo24Hour(
                                                classTime,
                                              );
                                              final timeParts = time24.split(
                                                ':',
                                              );
                                              final hour = int.parse(
                                                timeParts[0],
                                              );
                                              final minute = int.parse(
                                                timeParts[1],
                                              );
                                              classDateTime = DateTime(
                                                year,
                                                month,
                                                day,
                                                hour,
                                                minute,
                                              );
                                            }
                                            final canJoin =
                                                !teacherJoined &&
                                                classDateTime != null &&
                                                DateTime.now().isAfter(
                                                  classDateTime.subtract(
                                                    const Duration(minutes: 5),
                                                  ),
                                                );

                                            return FutureBuilder<
                                              DocumentSnapshot
                                            >(
                                              future:
                                                  FirebaseFirestore.instance
                                                      .collection('students')
                                                      .doc(assignedStudentId)
                                                      .get(),
                                              builder: (
                                                context,
                                                studentSnapshot,
                                              ) {
                                                String studentName = 'Student';
                                                if (studentSnapshot.hasData &&
                                                    studentSnapshot
                                                        .data!
                                                        .exists) {
                                                  studentName =
                                                      studentSnapshot
                                                          .data!['fullName'] ??
                                                      'Student';
                                                }
                                                return _WebClassCard(
                                                  title: subject,
                                                  time:
                                                      '$classDate at $classTime',
                                                  teacher: studentName,
                                                  text:
                                                      teacherJoined
                                                          ? 'Joined'
                                                          : 'Join Class',
                                                  roomName: jitsiRoom,
                                                  onJoin:
                                                      canJoin &&
                                                              jitsiRoom
                                                                  .isNotEmpty
                                                          ? () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                  'classes',
                                                                )
                                                                .doc(doc.id)
                                                                .update({
                                                                  'teacherJoined':
                                                                      true,
                                                                });
                                                            final url =
                                                                'https://meet.jit.si/$jitsiRoom';
                                                            await launchUrl(
                                                              Uri.parse(url),
                                                              mode:
                                                                  LaunchMode
                                                                      .externalApplication,
                                                            );
                                                          }
                                                          : null,
                                                );
                                              },
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 32),
                                const Text(
                                  'Recent Conversations',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Show recent conversations with students
                                FutureBuilder<QuerySnapshot>(
                                  future:
                                      FirebaseFirestore.instance
                                          .collection('students')
                                          .where(
                                            'assignedTeacherId',
                                            isEqualTo:
                                                FirebaseAuth
                                                    .instance
                                                    .currentUser!
                                                    .uid,
                                          )
                                          .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return const Text(
                                        'No conversations found',
                                      );
                                    }
                                    final students = snapshot.data!.docs;
                                    return Column(
                                      children:
                                          students.map((doc) {
                                            final studentName =
                                                doc['fullName'] ?? 'Student';
                                            return Column(
                                              children: [
                                                _WebConversationCard(
                                                  name: studentName,
                                                  message:
                                                      'Reminder: Assignment due tomorrow.',
                                                  time: '2 min ago',
                                                ),
                                                const SizedBox(height: 8),
                                              ],
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 32),
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
  final String roomName;
  final VoidCallback? onJoin;

  const _WebClassCard({
    required this.title,
    required this.time,
    required this.teacher,
    required this.text,
    required this.roomName,
    this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Theme.of(context).shadowColor,
      color: Theme.of(context).cardColor,
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  Widget joinButton = OutlinedButton(
                    onPressed: onJoin,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: appGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(text),
                  );

                  if (constraints.maxWidth > 400) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(time, style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(
                                teacher,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 80,
                            maxWidth: 120,
                          ),
                          child: joinButton,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(time, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(teacher, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 8),
                        SizedBox(width: double.infinity, child: joinButton),
                      ],
                    );
                  }
                },
              ),
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
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).shadowColor,
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
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
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
