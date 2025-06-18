import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

typedef QueryBuilder = Query Function(String userId);

class ClassesList extends StatelessWidget {
  final String type; // 'upcoming', 'completed', 'missed'
  final QueryBuilder? queryBuilder;
  const ClassesList({super.key, required this.type, this.queryBuilder});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    // Use custom queryBuilder if provided, otherwise fallback to old logic
    final Query classesQuery = queryBuilder != null
        ? queryBuilder!(userId!)
        : FirebaseFirestore.instance
            .collection('classes')
            .where('status', isEqualTo: type)
            .where('teacherId', isEqualTo: userId);

    return StreamBuilder<QuerySnapshot>(
      stream: classesQuery.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Text(
                'No $type classes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }
        final classes = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: classes.length,
          itemBuilder: (context, index) {
            final c = classes[index].data() as Map<String, dynamic>;
            final docId = classes[index].id;
            final subject = c['subject'] ?? '';
            final teacherName = c['teacherName'] ?? '';
            final studentName = c['studentName'] ?? '';
            final date = c['date'] ?? '';
            final time = c['time'] ?? '';
            final jitsiRoom = c['jitsiRoom'] ?? '';
            final teacherJoined = c['teacherJoined'] ?? false;

            // Show join button for upcoming classes, otherwise show joined label if joined
            bool showJoin = type == 'upcoming' && !teacherJoined;
            bool showJoinedLabel = type == 'upcoming' && teacherJoined;

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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Teacher: $teacherName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Student: $studentName',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: $date / $time',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  if (showJoin)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: OutlinedButton(
                        onPressed: jitsiRoom.isNotEmpty
                            ? () async {
                                // Only update teacherJoined, not status
                                await FirebaseFirestore.instance
                                    .collection('classes')
                                    .doc(docId)
                                    .update({'teacherJoined': true});
                                // Optionally, join the meeting here if needed
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: jitsiRoom.isNotEmpty ? Colors.green : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Join'),
                      ),
                    ),
                  if (showJoinedLabel)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Joined',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

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
          return const Text('No missed classes');
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
          return const Text('No missed classes');
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

// Parse time string to 24-hour format (e.g., "2:30 PM" -> "14:30")
String _parseTimeTo24Hour(String time) {
  try {
    final parts = time.split(' ');
    if (parts.length == 2) {
      final timeParts = parts[0].split(':');
      if (timeParts.length == 2) {
        int hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final isPm = parts[1].toUpperCase() == 'PM';
        if (isPm && hour != 12) {
          hour += 12;
        } else if (!isPm && hour == 12) {
          hour = 0;
        }
        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    }
  } catch (_) {}
  return time; // Return original time string if parsing fails
}