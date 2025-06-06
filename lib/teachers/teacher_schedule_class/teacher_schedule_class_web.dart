import 'package:al_mehdi_online_school/teachers/teacher_schedule_class/widgets.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';
import '../teacher_classes_screen/teacher_classes.dart';

class TeacherScheduleClassWeb extends StatelessWidget {
  const TeacherScheduleClassWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Sidebar
          Sidebar(selectedIndex: 1),
          // Main content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
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
                        icon: const Icon(
                          Icons.notifications,
                        ),
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
                            color: Color(0xFFe5faf3),
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Subject", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          SizedBox(height: 10,),
                                          DropdownField(label: 'Subject'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Student", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          SizedBox(height: 10,),
                                          DropdownField(label: 'Student', options: ['Student 1', 'Student 2']),
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Select Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          SizedBox(height: 10,),
                                          TextFields(label: 'Select Date', icon: Icons.calendar_today, isDatePicker: true),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          SizedBox(height: 10,),
                                          TextFields(label: 'Select Time', icon: Icons.access_time, isTimePicker: true),
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                                          ),
                                          SizedBox(height: 10,),
                                          TextFields(label: 'Description', maxLines: 2,),
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const TeacherClassesScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: const Text('Schedule Class', style: TextStyle(fontSize: 16)),
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