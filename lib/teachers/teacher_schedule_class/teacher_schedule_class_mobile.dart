import 'package:al_mehdi_online_school/teachers/teacher_schedule_class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import '../../../constants/colors.dart';
import '../teacher_classes_screen/teacher_classes.dart';

class TeacherScheduleClassMobile extends StatefulWidget {
  const TeacherScheduleClassMobile({super.key});

  @override
  State<TeacherScheduleClassMobile> createState() => _TeacherScheduleClassMobileState();
}

class _TeacherScheduleClassMobileState extends State<TeacherScheduleClassMobile> {
  String? selectedSubject;
  String? selectedDate;
  String? selectedTime;
  String? description;

  final List<String> subjects = ['Math', 'Science', 'English'];

  void _onSubjectChanged(String? value) {
    setState(() {
      selectedSubject = value;
    });
  }

  void _onDateChanged(String? value) {
    setState(() {
      selectedDate = value;
    });
  }

  void _onTimeChanged(String? value) {
    setState(() {
      selectedTime = value;
    });
  }

  void _onDescriptionChanged(String? value) {
    setState(() {
      description = value;
    });
  }

  Future<void> _scheduleClass() async {
    if (selectedSubject == null ||
        selectedDate == null ||
        selectedTime == null ||
        description == null ||
        selectedSubject!.isEmpty ||
        selectedDate!.isEmpty ||
        selectedTime!.isEmpty ||
        description!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final teacherId = FirebaseAuth.instance.currentUser?.uid;
    if (teacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher not logged in')),
      );
      return;
    }

    // Fetch assignedStudentId and teacherName from teacher's document
    final teacherDoc = await FirebaseFirestore.instance.collection('teachers').doc(teacherId).get();
    final assignedStudentId = teacherDoc.data()?['assignedStudentId'];
    final teacherName = teacherDoc.data()?['fullName'] ?? 'Teacher';

    if (assignedStudentId == null || assignedStudentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No assigned student found for this teacher.')),
      );
      return;
    }

    // Fetch assigned student name
    String studentName = '';
    final studentDoc = await FirebaseFirestore.instance.collection('students').doc(assignedStudentId).get();
    studentName = studentDoc.data()?['fullName'] ?? '';

    final classData = {
      'subject': selectedSubject,
      'date': selectedDate,
      'time': selectedTime,
      'description': description,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'studentId': assignedStudentId,
      'studentName': studentName,
      'createdAt': FieldValue.serverTimestamp(),
      'jitsiRoom': '${teacherId}_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'upcoming', // For Firestore classes collection
    };

    // Save to new classes collection for tracking status
    await FirebaseFirestore.instance
        .collection('classes')
        .add(classData);

    // (Optional) Save to scheduled_classes collection if still needed
    await FirebaseFirestore.instance
        .collection('scheduled_classes')
        .add(classData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Class scheduled!')),
    );

    setState(() {
      selectedSubject = null;
      selectedDate = null;
      selectedTime = null;
      description = null;
    });

    // Optionally, navigate to classes screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const TeacherClassesScreen()));
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Schedule Class',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Let students know when you’ll be teaching next.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Card(
                color: appLightGreen,
                shadowColor: Theme.of(context).shadowColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Subject",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      DropdownField(
                        label: 'Subject',
                        options: subjects,
                        value: selectedSubject,
                        onChanged: _onSubjectChanged,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Date",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextFields(
                        label: 'Select Date',
                        icon: Icons.calendar_today,
                        isDatePicker: true,
                        value: selectedDate,
                        onChanged: _onDateChanged,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Select Time",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextFields(
                        label: 'Select Time',
                        icon: Icons.access_time,
                        isTimePicker: true,
                        value: selectedTime,
                        onChanged: _onTimeChanged,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Description",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      TextFields(
                        label: 'Description',
                        maxLines: 2,
                        value: description,
                        onChanged: _onDescriptionChanged,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _scheduleClass,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('Schedule Class', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Upcoming Scheduled Classes',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 8),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collectionGroup('scheduled_classes')
                    .where('assignedStudentId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                    final date = doc['date'];
                    final time = doc['time'];
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
                    return classDateTime != null && (classDateTime.isAfter(now) || classDateTime.isAtSameMomentAs(now));
                  }).toList();

                  // Sort by classDateTime ascending
                  classes.sort((a, b) {
                    DateTime getDateTime(QueryDocumentSnapshot doc) {
                      final date = doc['date'];
                      final time = doc['time'];
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
                      final canJoin = classDateTime != null && DateTime.now().isAfter(classDateTime.subtract(const Duration(minutes: 5)));
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(subject),
                          subtitle: Text('$classDate at $classTime\n$teacher'),
                          trailing: OutlinedButton(
                            onPressed: canJoin && jitsiRoom.isNotEmpty
                                ? () async {
                                    final options = JitsiMeetConferenceOptions(
                                      room: jitsiRoom,
                                      userInfo: JitsiMeetUserInfo(displayName: 'Student'),
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
            ],
          ),
        ),
      ),
    );
  }
}