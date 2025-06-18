import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

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
  String? assignedTeacherId;

  @override
  void initState() {
    super.initState();
    fetchStudentNameAndTeacher();
  }

  Future<void> fetchStudentNameAndTeacher() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          fullName = doc['fullName'] ?? 'Student';
          assignedTeacherId = doc['assignedTeacherId'];
        });
      }
    }
  }

  void joinJitsiMeeting() async {
    if (assignedTeacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No teacher assigned. Cannot join class.')),
      );
      return;
    }
    final options = JitsiMeetConferenceOptions(
      room: assignedTeacherId!, // Use the assigned teacher's UID as the room name
      userInfo: JitsiMeetUserInfo(
        displayName: fullName ?? 'Student',
      ),
      featureFlags: {
        "welcomepage.enabled": false,
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
      },
    );
    await JitsiMeet().join(options);
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
              const SizedBox(height: 12),
              const Text(
                'Your Upcoming Classes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('classes')
                    .where('studentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    // .where('status', isEqualTo: 'upcoming') // Remove this filter!
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No upcoming classes');
                  }
                  final now = DateTime.now();
                  final classes = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final date = data['date'];
                    final time = data['time'];
                    DateTime? classDateTime;
                    try {
                      final parts = date.split('/');
                      if (parts.length == 3) {
                        final month = int.parse(parts[0]);
                        final day = int.parse(parts[1]);
                        final year = int.parse(parts[2]);
                        final time24 = _parseTimeTo24Hour(time);
                        final timeParts = time24.split(':');
                        final hour = int.parse(timeParts[0]);
                        final minute = int.parse(timeParts[1]);
                        classDateTime = DateTime(year, month, day, hour, minute);
                      }
                    } catch (_) {
                      classDateTime = null;
                    }
                    return classDateTime != null &&
                        (classDateTime.isAfter(now) ||
                            classDateTime.isAtSameMomentAs(now));
                  }).toList();

                  // Sort by classDateTime ascending
                  classes.sort((a, b) {
                    DateTime getDateTime(QueryDocumentSnapshot doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final date = data['date'];
                      final time = data['time'];
                      final parts = date.split('/');
                      if (parts.length == 3) {
                        final month = int.parse(parts[0]);
                        final day = int.parse(parts[1]);
                        final year = int.parse(parts[2]);
                        final time24 = _parseTimeTo24Hour(time);
                        final timeParts = time24.split(':');
                        final hour = int.parse(timeParts[0]);
                        final minute = int.parse(timeParts[1]);
                        return DateTime(year, month, day, hour, minute);
                      }
                      return DateTime(1970);
                    }
                    return getDateTime(a).compareTo(getDateTime(b));
                  });

                  if (classes.isEmpty) {
                    return const Text('No upcoming classes');
                  }
                  return Column(
                    children: classes.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final subject = data['subject'] ?? '';
                      final classDate = data['date'] ?? '';
                      final classTime = data['time'] ?? '';
                      final teacher = data['teacherName'] ?? 'Teacher';
                      final jitsiRoom = data['jitsiRoom'] ?? '';
                      final studentJoined = data['studentJoined'] ?? false;

                      // Parse classDateTime for join logic
                      final parts = classDate.split('/');
                      DateTime? classDateTime;
                      if (parts.length == 3) {
                        final month = int.parse(parts[0]);
                        final day = int.parse(parts[1]);
                        final year = int.parse(parts[2]);
                        final time24 = _parseTimeTo24Hour(classTime);
                        final timeParts = time24.split(':');
                        final hour = int.parse(timeParts[0]);
                        final minute = int.parse(timeParts[1]);
                        classDateTime = DateTime(year, month, day, hour, minute);
                      }
                      final canJoin = !studentJoined &&
                          classDateTime != null &&
                          DateTime.now().isAfter(
                            classDateTime.subtract(const Duration(minutes: 5)),
                          );
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(subject),
                          subtitle: Text('$classDate at $classTime\n$teacher'),
                          trailing: studentJoined
                              ? const Text(
                                  'Joined',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: canJoin && jitsiRoom.isNotEmpty
                                      ? () async {
                                          // Only update studentJoined, not status
                                          await FirebaseFirestore.instance
                                              .collection('classes')
                                              .doc(doc.id)
                                              .update({'studentJoined': true});
                                          final options = JitsiMeetConferenceOptions(
                                            room: jitsiRoom,
                                            userInfo: JitsiMeetUserInfo(displayName: fullName ?? 'Student'),
                                            featureFlags: {
                                              "welcomepage.enabled": false,
                                              "startWithAudioMuted": false,
                                              "startWithVideoMuted": false,
                                            },
                                          );
                                          await JitsiMeet().join(options);
                                        }
                                      : null,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: canJoin ? appGreen : Colors.grey.shade300,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: joinJitsiMeeting,
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