import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../student_notifications/student_notifications.dart';
import '../components/student_main_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Helper function to open URLs in a platform-agnostic way
Future<void> _openUrl(String url) async {
  if (kIsWeb) {
    // For web, use url_launcher
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    // For mobile, use url_launcher
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class StudentClassesMobileView extends StatelessWidget {
  const StudentClassesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Classes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3, color: appGreen),
                  insets: const EdgeInsets.symmetric(horizontal: 16),
                ),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Missed'),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: TabBarView(
            children: [
              _UpcomingClassesMobileTab(),
              _CompletedClassesMobileTab(),
              _MissedClassesMobileTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// UPCOMING TAB
class _UpcomingClassesMobileTab extends StatelessWidget {
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
          return const Text('No upcoming classes');
        }
        return ListView(
          shrinkWrap: true,
          children:
              classes.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final subject = data['subject'] ?? '';
                final classDate = data['date'] ?? '';
                final classTime = data['time'] ?? '';
                final jitsiRoom = data['jitsiRoom'] ?? '';
                final studentJoined = data['studentJoined'] ?? false;

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

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(subject),
                    subtitle: Text('$classDate at $classTime'),
                    trailing:
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
                                        await FirebaseFirestore.instance
                                            .collection('classes')
                                            .doc(doc.id)
                                            .update({'studentJoined': true});
                                        await _openUrl(
                                          'https://meet.jit.si/$jitsiRoom',
                                        );
                                      }
                                      : null,
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    canJoin ? appGreen : Colors.grey.shade300,
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
    );
  }
}

// COMPLETED TAB
class _CompletedClassesMobileTab extends StatelessWidget {
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
class _MissedClassesMobileTab extends StatelessWidget {
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

// Dummy ClassesList for demonstration (replace with your actual implementation)
class ClassesList extends StatelessWidget {
  final String type;
  final Query Function(String userId)? queryBuilder;
  const ClassesList({super.key, required this.type, this.queryBuilder});
  @override
  Widget build(BuildContext context) {
    // Your implementation here
    return Container();
  }
}
