import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../constants/colors.dart';
import '../class_join.dart';
import '../components/student_sidebar.dart';
import '../student_attendance/student_attendance.dart';
import '../student_notifications/student_notifications.dart';
import 'dart:html' as html;

class StudentHomeSreenWeb extends StatefulWidget {
  const StudentHomeSreenWeb({super.key});

  @override
  State<StudentHomeSreenWeb> createState() => _StudentHomeSreenWebState();
}

class _StudentHomeSreenWebState extends State<StudentHomeSreenWeb> {
  String? fullName;
  String? assignedTeacherId;

  @override
  void initState() {
    super.initState();

    // Debug: Print all scheduled_classes docs
    FirebaseFirestore.instance.collectionGroup('scheduled_classes').get().then((
      snapshot,
    ) {
      print('Total scheduled_classes docs: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print(doc.data());
      }
    });

    fetchStudentNameAndTeacher();
  }

  Future<void> fetchStudentNameAndTeacher() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'] ?? 'Student';
          assignedTeacherId = doc['assignedTeacherId'];
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
          StudentSidebar(selectedIndex: 0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        fullName != null
                            ? '👋 Welcome, $fullName!'
                            : '👋 Welcome, Student!',
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
                                      : 'Welcome back, Student! Your next class starts in 2 hours.',
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
                                                        const StudentAttendanceScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Details",
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
                                      '9 / 10 Classes Attended',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Great progress this week! 🎉',
                                      style: TextStyle(fontSize: 14),
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
                              children: [
                                // ...existing code...
                                const SizedBox(height: 32),
                                const Text(
                                  'Your Upcoming Classes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder<QuerySnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('classes')
                                      .where('studentId',
                                          isEqualTo:
                                              FirebaseAuth.instance
                                                  .currentUser!.uid)
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
                                    final classes = snapshot.data!.docs.where((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
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
                                      return classDateTime != null &&
                                          (classDateTime.isAfter(now) ||
                                              classDateTime.isAtSameMomentAs(
                                                  now));
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
                                            final teacher =
                                                data['teacherName'] ??
                                                'Teacher';
                                            final jitsiRoom =
                                                data['jitsiRoom'] ?? '';
                                            final studentJoined =
                                                data['studentJoined'] ??
                                                false;

                                            // Parse classDateTime for join logic
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
                                                !studentJoined &&
                                                classDateTime != null &&
                                                DateTime.now().isAfter(
                                                  classDateTime.subtract(
                                                    const Duration(minutes: 5),
                                                  ),
                                                );
                                            return Card(
                                              color: Colors.white,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 6,
                                                  ),
                                              child: ListTile(
                                                title: Text(subject),
                                                subtitle: Text(
                                                  '$classDate at $classTime\n$teacher',
                                                ),
                                                trailing: studentJoined
                                                    ? const Text(
                                                        'Joined',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )
                                                    : OutlinedButton(
                                                        onPressed:
                                                            canJoin && jitsiRoom
                                                                    .isNotEmpty
                                                                ? () async {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                          'classes',
                                                                        )
                                                                        .doc(doc.id)
                                                                        .update({
                                                                          'studentJoined':
                                                                              true,
                                                                        });
                                                                    final url =
                                                                        'https://meet.jit.si/$jitsiRoom';
                                                                    html.window.open(
                                                                      url,
                                                                      '_blank',
                                                                    );
                                                                  }
                                                                : null,
                                                        style: OutlinedButton.styleFrom(
                                                          backgroundColor:
                                                              canJoin
                                                                  ? appGreen
                                                                  : Colors
                                                                      .grey
                                                                      .shade300,
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(16),
                                                          ),
                                                        ),
                                                        child: const Text('Join'),
                                                      ),
                                              ),
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                                // ...do not show completed and missed classes here...
                                // ...existing code...
                                const SizedBox(height: 32),
                                const Text(
                                  'Recent Conversations',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                FutureBuilder<DocumentSnapshot>(
                                  future:
                                      FirebaseFirestore.instance
                                          .collection('students')
                                          .doc(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          )
                                          .get(),
                                  builder: (context, studentSnapshot) {
                                    if (studentSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (studentSnapshot.hasError ||
                                        !studentSnapshot.hasData ||
                                        !studentSnapshot.data!.exists) {
                                      return const Text('Student not found');
                                    }
                                    final assignedTeacherId =
                                        studentSnapshot
                                            .data!['assignedTeacherId'];
                                    if (assignedTeacherId == null) {
                                      return const Text('No teacher assigned');
                                    }
                                    return FutureBuilder<QuerySnapshot>(
                                      future:
                                          FirebaseFirestore.instance
                                              .collection('teachers')
                                              .where(
                                                'assignedStudentId',
                                                isEqualTo:
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                              )
                                              .get(),
                                      builder: (context, teacherSnapshot) {
                                        if (teacherSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }
                                        if (teacherSnapshot.hasError ||
                                            !teacherSnapshot.hasData) {
                                          return const Text(
                                            'No conversations found',
                                          );
                                        }
                                        final teachers =
                                            teacherSnapshot.data!.docs;
                                        if (teachers.isEmpty) {
                                          return const Text(
                                            'No teachers found',
                                          );
                                        }
                                        return Column(
                                          children:
                                              teachers.map((doc) {
                                                final teacherName =
                                                    doc['fullName'] ??
                                                    'Teacher';
                                                return Column(
                                                  children: [
                                                    _WebConversationCard(
                                                      name: teacherName,
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
                                    );
                                  },
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
  final String roomName;

  const _WebClassCard({
    required this.title,
    required this.time,
    required this.teacher,
    required this.text,
    required this.roomName,
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
                    onPressed:
                        roomName == 'no-room'
                            ? null
                            : () {
                              final url = 'https://meet.jit.si/$roomName';
                              html.window.open(url, '_blank');
                            },
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

String _parseTimeTo24Hour(String time) {
  final timeReg = RegExp(r'(\d{1,2}):(\d{2})\s*([AP]M)', caseSensitive: false);
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
