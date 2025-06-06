import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/notification_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/attendance_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/chat_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/profile_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/settings_screen.dart';
import 'package:al_mehdi_online_school/components/admin_sidebar.dart';
import 'package:al_mehdi_online_school/components/custom_bottom_nabigator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../active_class_screen.dart';

class ScheduleClass extends StatefulWidget {
  const ScheduleClass({super.key});

  @override
  State<ScheduleClass> createState() => _ScheduleClassState();
}

class _ScheduleClassState extends State<ScheduleClass> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth >= 900;

    if (isWeb) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            // Sidebar
            AdminSidebar(selectedIndex: 1),
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
                              MaterialPageRoute(builder: (context) => NotificationScreen()),
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
                                            builder: (context) => const ActiveClassScreen(),
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
    } else {
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
                                  builder: (context) => const ActiveClassScreen(),
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
      );
    }
  }
}


class TextFields extends StatelessWidget {
  final String label;
  final int maxLines;
  final IconData? icon;
  final bool isDatePicker;
  final bool isTimePicker;
  final TextEditingController? controller;

  const TextFields({super.key,
    required this.label,
    this.maxLines = 1,
    this.icon,
    this.isDatePicker = false,
    this.isTimePicker = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController internalController = controller ?? TextEditingController();

    return GestureDetector(
      onTap: (isDatePicker || isTimePicker)
          ? () async {
        FocusScope.of(context).unfocus(); // Hide keyboard

        if (isDatePicker) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: appGreen, // Header and buttons
                    onPrimary: Color(0xFFe5faf3),
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green, // Button text color
                    ),
                  ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFFe5faf3)),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            internalController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
          }
        }

        if (isTimePicker) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: appGreen, // Header and buttons
                    onPrimary: Color(0xFFe5faf3),
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            final now = DateTime.now();
            final time = DateTime(
              now.year,
              now.month,
              now.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            internalController.text = DateFormat('hh:mm a').format(time);
          }
        }
      }
          : null,
      child: AbsorbPointer(
        absorbing: isDatePicker || isTimePicker,
        child: TextField(
          cursorColor: appGreen,
          controller: internalController,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15, color: Colors.black ),
          decoration: InputDecoration(
            label: Text(label, style: TextStyle(fontSize: 15, color: Colors.black),),
            floatingLabelStyle: TextStyle(color: appGreen),
            prefixIcon: icon != null ? Icon(icon, color: appGreen) : null,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: appGreen),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final List<String> options;

  const DropdownField({super.key, required this.label, this.options = const ['Math', 'Science', 'English']});

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(
      dropdownColor: appLightGreen,
      icon: Icon(Icons.arrow_drop_down, color: appGreen,),
      value: null,
      hint: Text(label, style:  TextStyle(fontSize: 15, color: Colors.black),),
      style: TextStyle(color: Colors.black),
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 15),))).toList(),
      onChanged: (val) {},
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: appGreen),
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
  }
}
