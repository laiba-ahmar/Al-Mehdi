import 'package:al_mehdi_online_school/Screens/AdminDashboard/notification_screen.dart';
import 'package:al_mehdi_online_school/components/admin_sidebar.dart';
import 'package:al_mehdi_online_school/components/custom_bottom_nabigator.dart';
import 'package:flutter/material.dart';
import 'package:al_mehdi_online_school/constants/colors.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width >= 900;

    if (isWeb) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            AdminSidebar(selectedIndex: 2),
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
                          icon: const Icon(
                            Icons.notifications,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationScreen(),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildAttendanceCard(context),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildAttendanceCard(context),
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
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Attendance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildDropdown(context, "Student"),
                  const SizedBox(width: 20),
                  _buildDropdown(context, "Class"),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Student",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "May 6, 2025 · 9:00 AM",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildAttendanceCard(context),
            ],
          ),
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
      );
    }
  }
  Widget _buildDropdown(BuildContext context, String hint) {
    Color dropdownColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground// Dark theme: Red
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
            focusColor: Colors.transparent,
            dropdownColor: dropdownColor,
            isExpanded: true,
            hint: Text(hint),
            value: selectedValue,
            items: [
              DropdownMenuItem(value: 'Option 1', child: Text('Student 1')),
              DropdownMenuItem(value: 'Option 2', child: Text('Student 2')),
              DropdownMenuItem(value: 'Option 3', child: Text('Student 3')),
            ],
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              });
            },
            icon: const Icon(Icons.arrow_drop_down, color: appGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).shadowColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
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
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          _buildDropdown(context ,"Student"),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Student",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "May 6, 2025 · 9:00 AM",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _AttendanceCard extends StatefulWidget {
  final String subject;
  final String teacher;
  final String dateTime;

  const _AttendanceCard({
    required this.subject,
    required this.teacher,
    required this.dateTime,
  });

  @override
  State<_AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<_AttendanceCard> {
  bool isPresent = true;

  void togglePresence() {
    setState(() {
      isPresent = !isPresent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subject: ${widget.subject}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teacher: ${widget.teacher}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date/Time: ${widget.dateTime}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: togglePresence,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isPresent ? Colors.green : Colors.red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: isPresent ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPresent ? 'Present' : 'Absent',
                      style: TextStyle(
                        color: isPresent ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceToggle extends StatefulWidget {
  const AttendanceToggle({super.key});

  @override
  _AttendanceToggleState createState() => _AttendanceToggleState();
}

class _AttendanceToggleState extends State<AttendanceToggle> {
  bool isPresent = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPresent = !isPresent;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: isPresent ? Colors.green : Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 8,
              backgroundColor: isPresent ? Colors.green : Colors.red,
            ),
            SizedBox(width: 8),
            Text(
              isPresent ? 'Present' : 'Absent',
              style: TextStyle(
                color: isPresent ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

