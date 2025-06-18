import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../components/teacher_main_screen.dart';
import '../teacher_schedule_class/teacher_schedule_class.dart';
import 'class_list.dart';

class TeacherClassesMobileView extends StatelessWidget {
  const TeacherClassesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Classes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
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
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    // Upcoming: show all future classes for this teacher (regardless of teacherJoined)
                    _UpcomingClassesMobileTab(),
                    // Completed: teacherJoined == true
                    ClassesList(
                      type: 'completed',
                      queryBuilder: (userId) => FirebaseFirestore.instance
                          .collection('classes')
                          .where('teacherId', isEqualTo: userId)
                          .where('teacherJoined', isEqualTo: true),
                    ),
                    // Missed: 
                    // 1. studentJoined == true && teacherJoined == false (student joined, teacher didn't)
                    // 2. studentJoined == false && teacherJoined == false && class time is in the past (neither joined)
                    _MissedTeacherClassesMobileTab(),
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
                      MaterialPageRoute(builder: (context) => const ScheduleClassesScreen()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Schedule a Class', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: buildBottomNavigationBar(context, 1),
      ),
    );
  }
}

// Update the join logic in _UpcomingClassesMobileTab:
class _UpcomingClassesMobileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('classes')
          .where('teacherId', isEqualTo: userId)
          .get(), // <-- No teacherJoined filter!
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No upcoming classes', style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
          );
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
          // Only show classes whose time is in the future (upcoming)
          return classDateTime != null &&
              (classDateTime.isAfter(now) || classDateTime.isAtSameMomentAs(now));
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
          return Center(
            child: Text('No upcoming classes', style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
          );
        }
        return ListView(
          shrinkWrap: true,
          children: classes.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final subject = data['subject'] ?? '';
            final classDate = data['date'] ?? '';
            final classTime = data['time'] ?? '';
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
              classDateTime = DateTime(year, month, day, hour, minute);
            }
            final canJoin =
                !teacherJoined &&
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
                trailing: teacherJoined
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
                                // Only update teacherJoined, not status
                                await FirebaseFirestore.instance
                                    .collection('classes')
                                    .doc(doc.id)
                                    .update({'teacherJoined': true});
                                // Optionally, join the meeting
                                // You can call your joinJitsiMeeting(jitsiRoom) here if needed
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
    );
  }
}

// Add this widget at the end of the file:
class _MissedTeacherClassesMobileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('classes')
          .where('teacherId', isEqualTo: userId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No missed classes', style: TextStyle(
            color: Colors.grey[600],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),));
        }
        final now = DateTime.now();
        final missedClasses = snapshot.data!.docs.where((doc) {
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
          // 1. Student joined but teacher didn't, and class is in the past
          // 2. Neither joined and class is in the past
          final isPast = classDateTime != null && classDateTime.isBefore(now);
          return isPast &&
              (
                (studentJoined == true && teacherJoined == false) ||
                (studentJoined == false && teacherJoined == false)
              );
        }).toList();

        if (missedClasses.isEmpty) {
          return Center(
            child: Text('No missed classes', style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),),
          );
        }
        return ListView(
          children: missedClasses.map((doc) {
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

// Helper function for time parsing (add this if not already present)
String _parseTimeTo24Hour(String time) {
  // Example: "10:00 AM" -> "10:00", "2:30 PM" -> "14:30"
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
