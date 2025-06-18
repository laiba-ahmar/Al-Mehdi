import 'package:al_mehdi_online_school/teachers/teacher_schedule_class/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants/colors.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';
import '../teacher_classes_screen/teacher_classes.dart';

class TeacherScheduleClassWeb extends StatefulWidget {
  const TeacherScheduleClassWeb({super.key});

  @override
  State<TeacherScheduleClassWeb> createState() => _TeacherScheduleClassWebState();
}

class _TeacherScheduleClassWebState extends State<TeacherScheduleClassWeb> {
  String? selectedSubject;
  String? selectedDate;
  String? selectedTime;
  String? description;
  String? assignedStudentId; // <-- Add this line

  final List<String> subjects = ['Math', 'Science', 'English'];

  final _formKey = GlobalKey<FormState>();

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

    // Fetch teacher info and assigned student
    final teacherDoc = await FirebaseFirestore.instance.collection('teachers').doc(teacherId).get();
    final assignedStudentId = teacherDoc.data()?['assignedStudentId'];
    final teacherName = teacherDoc.data()?['fullName'] ?? 'Teacher';

    // Fetch assigned student name if available
    String studentName = '';
    if (assignedStudentId != null && assignedStudentId.isNotEmpty) {
      final studentDoc = await FirebaseFirestore.instance.collection('students').doc(assignedStudentId).get();
      studentName = studentDoc.data()?['fullName'] ?? '';
    }

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
                            MaterialPageRoute(builder: (context) => StudentNotificationScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Schedule a Class', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('Let students know when you\'ll be teaching next.'),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFe5faf3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Subject", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          const SizedBox(height: 10,),
                                          DropdownField(
                                            label: 'Subject',
                                            options: subjects,
                                            value: selectedSubject,
                                            onChanged: _onSubjectChanged,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Select Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFields(
                                            label: 'Select Date',
                                            icon: Icons.calendar_today,
                                            isDatePicker: true,
                                            value: selectedDate,
                                            onChanged: _onDateChanged,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFields(
                                            label: 'Select Time',
                                            icon: Icons.access_time,
                                            isTimePicker: true,
                                            value: selectedTime,
                                            onChanged: _onTimeChanged,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          const SizedBox(height: 10,),
                                          TextFields(
                                            label: 'Description',
                                            maxLines: 2,
                                            value: description,
                                            onChanged: _onDescriptionChanged,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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