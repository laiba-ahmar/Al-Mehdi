import 'package:al_mehdi_online_school/teachers/components/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../student_notifications/student_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class StudentClassesWebView extends StatefulWidget {
  const StudentClassesWebView({super.key});

  @override
  State<StudentClassesWebView> createState() => _StudentClassesWebViewState();
}

class _StudentClassesWebViewState extends State<StudentClassesWebView>
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
                // Header
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
                      // Vertical Tab Bar
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
                      // Tab Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 24,
                          ),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              _UpcomingStudentClassesTab(),
                              _CompletedStudentClassesTab(),
                              _MissedStudentClassesTab(),
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

// UPCOMING TAB
class _UpcomingStudentClassesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('classes')
              .where('studentId', isEqualTo: userId)
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
                  classDateTime = DateTime(year, month, day, hour, minute);
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
        return ListView(
          children:
              classes.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? '';
                final classDate = data['date'] ?? '';
                final classTime = data['time'] ?? '';
                final jitsiRoom = data['jitsiRoom'] ?? '';
                final assignedTeacherId = data['teacherId'] ?? '';
                final studentJoined = data['studentJoined'] ?? false;

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
                  classDateTime = DateTime(year, month, day, hour, minute);
                }
                final canJoin =
                    !studentJoined &&
                    classDateTime != null &&
                    DateTime.now().isAfter(
                      classDateTime.subtract(const Duration(minutes: 5)),
                    );

                return FutureBuilder<DocumentSnapshot>(
                  future:
                      FirebaseFirestore.instance
                          .collection('teachers')
                          .doc(assignedTeacherId)
                          .get(),
                  builder: (context, teacherSnapshot) {
                    String teacherName = 'Teacher';
                    if (teacherSnapshot.hasData &&
                        teacherSnapshot.data!.exists) {
                      teacherName =
                          teacherSnapshot.data!['fullName'] ?? 'Teacher';
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
                                    teacherName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            studentJoined
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
                                            // Only update studentJoined, not status
                                            await FirebaseFirestore.instance
                                                .collection('classes')
                                                .doc(doc.id)
                                                .update({
                                                  'studentJoined': true,
                                                });
                                            // Open Jitsi meeting
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

// COMPLETED TAB
class _CompletedStudentClassesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('classes')
              .where('studentId', isEqualTo: userId)
              .where('studentJoined', isEqualTo: true)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No completed classes');
        }
        final now = DateTime.now();
        final completedClasses =
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
              // Completed if joined and class is in the past
              return classDateTime != null && classDateTime.isBefore(now);
            }).toList();

        if (completedClasses.isEmpty) {
          return const Text('No completed classes');
        }
        return ListView(
          children:
              completedClasses.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? '';
                final classDate = data['date'] ?? '';
                final classTime = data['time'] ?? '';
                final teacherName = data['teacherName'] ?? '';
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
                        'Teacher: $teacherName',
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
                        'Completed',
                        style: TextStyle(
                          color: Colors.green,
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

// MISSED TAB
class _MissedStudentClassesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('classes')
              .where('studentId', isEqualTo: userId)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No missed classes');
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
              // Missed if:
              // 1. Teacher joined but student didn't, and class is in the past
              // 2. Neither joined and class is in the past
              final isPast =
                  classDateTime != null && classDateTime.isBefore(now);
              return isPast &&
                  ((teacherJoined == true && studentJoined == false) ||
                      (teacherJoined == false && studentJoined == false));
            }).toList();

        if (missedClasses.isEmpty) {
          return const Text('No missed classes');
        }
        return ListView(
          children:
              missedClasses.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? '';
                final classDate = data['date'] ?? '';
                final classTime = data['time'] ?? '';
                final teacherName = data['teacherName'] ?? '';
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
                        'Teacher: $teacherName',
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

// Helper function for time parsing
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
