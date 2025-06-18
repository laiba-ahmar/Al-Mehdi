import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';
import '../teacher_schedule_class/teacher_schedule_class.dart';
import 'class_list.dart';
import 'package:url_launcher/url_launcher.dart';

class TeacherClassesWebView extends StatefulWidget {
  const TeacherClassesWebView({super.key});

  @override
  State<TeacherClassesWebView> createState() => _TeacherClassesWebViewState();
}

class _TeacherClassesWebViewState extends State<TeacherClassesWebView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Sidebar(selectedIndex: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Classes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
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
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 250,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Color(0xFFE5EAF1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _WebTab(
                              label: 'Upcoming',
                              selected: _tabController.index == 0,
                              onTap:
                                  () =>
                                      setState(() => _tabController.index = 0),
                            ),
                            _WebTab(
                              label: 'Completed',
                              selected: _tabController.index == 1,
                              onTap:
                                  () =>
                                      setState(() => _tabController.index = 1),
                            ),
                            _WebTab(
                              label: 'Missed',
                              selected: _tabController.index == 2,
                              onTap:
                                  () =>
                                      setState(() => _tabController.index = 2),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    _UpcomingClassesTab(),
                                    ClassesList(
                                      type: 'completed',
                                      queryBuilder:
                                          (userId) => FirebaseFirestore.instance
                                              .collection('classes')
                                              .where(
                                                'teacherId',
                                                isEqualTo: userId,
                                              )
                                              .where(
                                                'teacherJoined',
                                                isEqualTo: true,
                                              ),
                                    ),
                                    _MissedTeacherClassesWebTab(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appGreen,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const ScheduleClassesScreen(),
                                      ),
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Schedule a Class',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
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
        ],
      ),
    );
  }
}

class _WebTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _WebTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: selected ? 18 : 16,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: selected ? 40 : 0,
              decoration: BoxDecoration(
                color: selected ? appGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingClassesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('classes')
              .where('teacherId', isEqualTo: userId)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No upcoming classes',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
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
                  classDateTime = DateTime(year, month, day, hour, minute);
                }
              } catch (_) {
                classDateTime = null;
              }
              return classDateTime != null &&
                  (classDateTime.isAfter(now) ||
                      classDateTime.isAtSameMomentAs(now));
            }).toList();

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
          return Center(
            child: Text(
              'No upcoming classes',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        return ListView(
          children:
              classes.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? '';
                final classDate = data['date'] ?? '';
                final classTime = data['time'] ?? '';
                final jitsiRoom = data['jitsiRoom'] ?? '';
                final assignedStudentId = data['studentId'] ?? '';
                final teacherJoined = data['teacherJoined'] ?? false;

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
                final canJoin =
                    !teacherJoined &&
                    classDateTime != null &&
                    DateTime.now().isAfter(
                      classDateTime.subtract(const Duration(minutes: 5)),
                    );

                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('students')
                          .doc(assignedStudentId)
                          .get(),
                  builder: (context, studentSnapshot) {
                    String studentName = 'Student';
                    if (studentSnapshot.hasData &&
                        studentSnapshot.data!.exists) {
                      studentName =
                          studentSnapshot.data!['fullName'] ?? 'Student';
                    }
                    return Card(
                      elevation: 2,
                      shadowColor: Theme.of(context).shadowColor,
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                              child: Icon(Icons.class_, color: appGreen),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$classDate at $classTime',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    studentName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
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
                                            await FirebaseFirestore.instance
                                                .collection('classes')
                                                .doc(doc.id)
                                                .update({
                                                  'teacherJoined': true,
                                                });
                                            await launchUrl(
                                              Uri.parse(
                                                'https://meet.jit.si/$jitsiRoom',
                                              ),
                                            );
                                          }
                                          : null,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:
                                        canJoin
                                            ? appGreen
                                            : Colors.grey.shade300,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('Join'),
                                ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
        );
      },
    );
  }
}

// Helper function for time parsing (add this if not already present)
String _parseTimeTo24Hour(String time) {
  final timeRegExp = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false);
  final match = timeRegExp.firstMatch(time);
  if (match != null) {
    int hour = int.parse(match.group(1)!);
    final int minute = int.parse(match.group(2)!);
    final String period = match.group(3)!.toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  return time;
}

class _MissedTeacherClassesWebTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('classes')
              .where('teacherId', isEqualTo: userId)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No missed classes',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        final now = DateTime.now();
        final missedClasses =
            snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final date = data['date'];
              final time = data['time'];
              final teacherJoined = data['teacherJoined'] ?? false;
              final studentJoined = data['studentJoined'] ?? false;
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
              final isPast =
                  classDateTime != null && classDateTime.isBefore(now);
              return isPast &&
                  ((studentJoined == true && teacherJoined == false) ||
                      (studentJoined == false && teacherJoined == false));
            }).toList();

        if (missedClasses.isEmpty) {
          return Center(
            child: Text(
              'No missed classes',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }
        return ListView(
          children:
              missedClasses.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? '';
                final classDate = data['date'] ?? '';
                final classTime = data['time'] ?? '';
                final studentName = data['studentName'] ?? '';
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFe5faf3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subject: $subject',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Student: $studentName',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date/Time: $classDate / $classTime',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Missed',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
