import 'package:flutter/material.dart';

class ClassesList extends StatelessWidget {
  final String type;
  const ClassesList({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    // Example data for demonstration
    final upcomingClasses = [
      {
        'subject': 'Maths',
        'teacher': 'Miss Mahreen',
        'datetime': '01-05-2025 / 10:00 AM',
      },
      {
        'subject': 'Maths',
        'teacher': 'Miss Mahreen',
        'datetime': '01-05-2025 / 10:00 AM',
      },
      {
        'subject': 'Maths',
        'teacher': 'Miss Mahreen',
        'datetime': '01-05-2025 / 10:00 AM',
      },
    ];
    final completedClasses = [
      {
        'subject': 'Maths',
        'teacher': 'Miss Mahreen',
        'datetime': '01-05-2025 / 10:00 AM',
      },
      {
        'subject': 'Maths',
        'teacher': 'Miss Mahreen',
        'datetime': '01-05-2025 / 10:00 AM',
      },
    ];
    // For demonstration, show empty for missed
    final isMissed = type == 'missed';
    final isCompleted = type == 'completed';
    final showList = !isMissed;
    final classes = isCompleted ? completedClasses : upcomingClasses;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child:
      showList
          ? Column(
        children: List.generate(classes.length, (index) {
          final c = classes[index];
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
                  'Subject: ${c['subject']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Teacher: ${c['teacher']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Date/Time: ${c['datetime']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }),
      )
          : Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 48.0),
          child: Text(
            'No missed classes',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}