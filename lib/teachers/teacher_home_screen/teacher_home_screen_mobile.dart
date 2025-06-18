import 'package:al_mehdi_online_school/teachers/teacher_classes_screen/teacher_classes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants/colors.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../teacher_schedule_class/teacher_schedule_class.dart';
import '../teacher_attendance/teacher_attendance.dart';
import '../teacher_settings/teacher_settings.dart';
import '../teacher_profile/teacher_profile.dart';
import '../teacher_chat/teacher_chat.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class TeacherHomeScreenMobile extends StatefulWidget {
  const TeacherHomeScreenMobile({super.key});

  @override
  State<TeacherHomeScreenMobile> createState() =>
      _TeacherHomeScreenMobileState();
}

class _TeacherHomeScreenMobileState extends State<TeacherHomeScreenMobile> {
  String? fullName;
  int _selectedIndex = 0;

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

  void joinJitsiMeeting(String room) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not found.')));
      return;
    }
    final options = JitsiMeetConferenceOptions(
      room: room,
      userInfo: JitsiMeetUserInfo(displayName: fullName ?? 'Teacher'),
      featureFlags: {
        "welcomepage.enabled": false,
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
      },
    );
    await JitsiMeet().join(options);
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _HomeTab(fullName: fullName, joinJitsiMeeting: joinJitsiMeeting);
      case 1:
        return const TeacherClassesScreen();
      case 2:
        return const TeacherChatScreen();
      case 3:
        return const TeacherSettingsScreen();
      case 4:
        return const TeacherProfileScreen();
      default:
        return _HomeTab(fullName: fullName, joinJitsiMeeting: joinJitsiMeeting);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Classes'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final String? fullName;
  final void Function(String) joinJitsiMeeting;

  const _HomeTab({required this.fullName, required this.joinJitsiMeeting});

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        fullName != null
                            ? '👋 Welcome, $fullName!'
                            : '👋 Welcome, Teacher!',
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
                        MaterialPageRoute(
                          builder: (_) => StudentNotificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFe5faf3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  fullName != null
                      ? 'Welcome back, $fullName! Your next class starts soon.'
                      : 'Welcome back, Teacher! Your next class starts soon.',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              // Attendance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              const SizedBox(height: 24),
              // Upcoming Scheduled Classes
              const Text(
                'Upcoming Scheduled Classes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('classes')
                        .where(
                          'teacherId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                        )
                        // .where('teacherJoined', isEqualTo: false) // Remove this filter!
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text('No upcoming classes');
                  }
                  final now = DateTime.now();
                  final classes =
                      snapshot.data!.docs.where((doc) {
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
                    children:
                        classes.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final classDate = data['date'] ?? '';
                          final classTime = data['time'] ?? '';
                          final subject = data['subject'] ?? '';
                          final jitsiRoom = data['jitsiRoom'] ?? '';
                          final teacherJoined = data['teacherJoined'] ?? false;

                          // Parse classDateTime using the same logic as filtering
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

                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(subject),
                              subtitle: Text('$classDate at $classTime'),
                              trailing:
                                  teacherJoined
                                      ? const Text(
                                        'Joined',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                      : OutlinedButton(
                                        onPressed:
                                            canJoin && jitsiRoom.isNotEmpty
                                                ? () async {
                                                  // Only update teacherJoined, not status
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('classes')
                                                      .doc(doc.id)
                                                      .update({
                                                        'teacherJoined': true,
                                                      });
                                                  // Optionally, join the meeting
                                                  joinJitsiMeeting(jitsiRoom);
                                                }
                                                : null,
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              canJoin
                                                  ? appGreen
                                                  : Colors.grey.shade300,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ScheduleClassesScreen()),
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
                  'Schedule Class',
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
