import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../constants/colors.dart';
import '../components/student_sidebar.dart';
import '../student_notifications/student_notifications.dart';

class StudentAttendanceWebView extends StatefulWidget {
  const StudentAttendanceWebView({super.key});

  @override
  State<StudentAttendanceWebView> createState() => _StudentAttendanceWebViewState();
}

class _StudentAttendanceWebViewState extends State<StudentAttendanceWebView> {
  int? selectedSubjectIndex;

  final List<Map<String, dynamic>> subjects = [
    {'name': 'English', 'total': 10, 'attended': 10},
    {'name': 'Urdu', 'total': 12, 'attended': 9},
    {'name': 'Maths', 'total': 8, 'attended': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          const StudentSidebar(selectedIndex: 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  child: Row(
                    children: [
                      const Text(
                        'Attendance Report',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                const Divider(height: 1, thickness: 1, color: Color(0xFFE5EAF1)),
                // Content Row
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    children: [
                      // Subject List
                      Expanded(
                        child: SizedBox(
                          height: 500,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Subjects", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              ...List.generate(subjects.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 30),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedSubjectIndex = index;
                                      });
                                    },
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        color: Theme.of(context).cardColor,
                                        shadowColor: Theme.of(context).shadowColor,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: selectedSubjectIndex == index ? appGreen : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(subjects[index]['name']),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      // Attendance Report
                      Expanded(
                        child: selectedSubjectIndex == null
                            ? const Center(
                          child: Text(
                            'Select a subject to see attendance',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                            : AttendanceChart(subject: subjects[selectedSubjectIndex!]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceChart extends StatelessWidget {
  final Map<String, dynamic> subject;

  const AttendanceChart({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    int total = subject['total'];
    int attended = subject['attended'];
    int missed = total - attended;
    double percentage = (attended / total) * 100;

    final dataMap = {
      "Attended": attended.toDouble(),
      "Missed": missed.toDouble(),
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PieChart(
          dataMap: dataMap,
          chartRadius: 150,
          animationDuration: const Duration(milliseconds: 800),
          chartType: ChartType.ring,
          ringStrokeWidth: 20,
          baseChartColor: Colors.grey[200]!,
          colorList: [appGreen, Colors.grey.shade200],
          centerText: "${percentage.toStringAsFixed(0)}%",
          centerTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // or any color you want
            backgroundColor: Colors.white,
          ),
          legendOptions: const LegendOptions(showLegends: false),
          chartValuesOptions: const ChartValuesOptions(showChartValues: false),
        ),
        const SizedBox(height: 10),
        Text(
          percentage == 100 ? "Excellent!" : percentage >= 75 ? "Good!" : "Needs Improvement",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        InfoTile(label: "Total Classes", value: "$total"),
        InfoTile(label: "Classes Attended", value: "$attended"),
        InfoTile(label: "Classes Missed", value: "$missed"),
      ],
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).shadowColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}