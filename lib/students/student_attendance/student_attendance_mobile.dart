import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../../constants/colors.dart';

class StudentAttendanceMobileView extends StatelessWidget {
  const StudentAttendanceMobileView({super.key});

  final List<String> subjects = const ['English', 'Urdu', 'Maths'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            color: Theme.of(context).cardColor,
            shadowColor: Theme.of(context).shadowColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(subjects[index], style: TextStyle(fontWeight: FontWeight.w400),),
              trailing: const Icon(Icons.arrow_forward_ios, size: 15,),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentAttendanceDetailScreen(
                      subject: subjects[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class StudentAttendanceDetailScreen extends StatelessWidget {
  final String subject;

  const StudentAttendanceDetailScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final int total = 10;
    final int attended = 10;
    final int missed = total - attended;
    final double percentage = (attended / total) * 100;

    final dataMap = {
      "Attended": attended.toDouble(),
      "Missed": missed.toDouble(),
    };

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          subject,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PieChart(
              dataMap: dataMap,
              chartRadius: MediaQuery.of(context).size.width / 3,
              animationDuration: const Duration(milliseconds: 800),
              chartType: ChartType.ring,
              ringStrokeWidth: 20,
              baseChartColor: Colors.grey[200]!,
              colorList: [appGreen, Colors.grey],
              centerText: "${percentage.toStringAsFixed(0)}%",
              centerTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                backgroundColor: Colors.transparent,
              ),
              legendOptions: const LegendOptions(showLegends: false),
              chartValuesOptions: const ChartValuesOptions(showChartValues: false),
            ),
            const SizedBox(height: 20),
            const Text(
              "Excellent!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            AttendanceStatCard(label: "Total Classes", value: total),
            AttendanceStatCard(label: "Classes Attended", value: attended),
            AttendanceStatCard(label: "Classes Missed", value: missed),
          ],
        ),
      ),
    );
  }
}

class AttendanceStatCard extends StatelessWidget {
  final String label;
  final int value;

  const AttendanceStatCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shadowColor: Theme.of(context).shadowColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label),
        trailing: Text(value.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }
}