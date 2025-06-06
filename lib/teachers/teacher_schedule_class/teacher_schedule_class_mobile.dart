import 'package:al_mehdi_online_school/teachers/teacher_schedule_class/widgets.dart';
import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../components/teacher_main_screen.dart';
import '../teacher_classes_screen/teacher_classes.dart';

class TeacherScheduleClassMobile extends StatelessWidget {
  const TeacherScheduleClassMobile({
    super.key,
  });

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
              Text("Let students know when you’ll be teaching next.", style: TextStyle(fontSize: 16, color: Colors.grey),),
              SizedBox(height: 20,),
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
                      SizedBox(height: 10),
                      Text("Subject", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                      SizedBox(height: 10),
                      DropdownField(label: 'Subject'),
                      SizedBox(height: 20),
                      Text("Student", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                      SizedBox(height: 10),
                      DropdownField(label: 'Student', options: ['Student 1', 'Student 2'],),
                      SizedBox(height: 20),
                      Text("Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                      SizedBox(height: 10),
                      TextFields(label: 'Select Date', icon: Icons.calendar_today, isDatePicker: true),
                      SizedBox(height: 20),
                      Text("Select Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                      SizedBox(height: 10),
                      TextFields(label: 'Select Time', icon: Icons.access_time, isTimePicker: true),
                      SizedBox(height: 20),
                      Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                      SizedBox(height: 10),
                      TextFields(label: 'Description', maxLines: 2,),
                      SizedBox(height: 40),
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
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: buildBottomNavigationBar(context, 1),
    );
  }
}