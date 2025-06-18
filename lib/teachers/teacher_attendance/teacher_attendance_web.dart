import 'package:al_mehdi_online_school/teachers/teacher_attendance/widget.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/sidebar.dart';

class TeacherAttendanceWebView extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const TeacherAttendanceWebView({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          Sidebar(selectedIndex: 2),
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
                        'Attendance Report',
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
                _buildFilterRow(context),
                _buildHeader(),
                _buildAttendanceCard(context),
                const SizedBox(height: 10),
                _buildAttendanceCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          _buildDropdown(context, "Student"),
          const SizedBox(width: 20),
          _buildDropdown(context, "Class"),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: TextField(
              cursorColor: appGreen,
              decoration: InputDecoration(
                hintText: 'Search...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400, // Grey outline color
                    width: 0.5, // Adjust thickness as needed
                  ), // No focus border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400, // Grey outline color
                    width: 1.0, // Adjust thickness as needed
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String hint) {
    Color dropdownColor =
        Theme.of(context).brightness == Brightness.dark
            ? darkBackground // Dark theme: Red
            : appLightGreen; // Light theme: Green
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: dropdownColor,
            focusColor: Colors.transparent,
            isExpanded: true,
            hint: Text(hint),
            value: selectedValue,
            items: [
              DropdownMenuItem(value: 'Option 1', child: Text('Student 1')),
              DropdownMenuItem(value: 'Option 2', child: Text('Student 2')),
              DropdownMenuItem(value: 'Option 3', child: Text('Student 3')),
            ],
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down, color: appGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Student",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text("May 6, 2025 · 9:00 AM", style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Theme.of(context).cardColor,
        shadowColor: Theme.of(context).shadowColor,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Subject: Maths',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Teacher: Laiba',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date/Time: 01-05-2025',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),
              AttendanceToggle(),
            ],
          ),
        ),
      ),
    );
  }
}
