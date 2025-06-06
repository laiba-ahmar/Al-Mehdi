import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import 'package:flutter/material.dart';

class ActiveClassScreen extends StatefulWidget {
  const ActiveClassScreen({super.key});

  @override
  State<ActiveClassScreen> createState() => _ActiveClassScreenState();
}

class _ActiveClassScreenState extends State<ActiveClassScreen> {
  final List<Map<String, String>> activeClasses = [
    {
      'student': 'Umer Ahmed',
      'teacher': 'Laiba Ahmar',
      'duration': '30 mins',
    },
    {
      'student': 'Sara Khan',
      'teacher': 'Ali Raza',
      'duration': '45 mins',
    },
    {
      'student': 'Bilal Sheikh',
      'teacher': 'Zara Noor',
      'duration': '40 mins',
    },
    {
      'student': 'Fatima Noor',
      'teacher': 'Imran Qureshi',
      'duration': '35 mins',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    final double cardPadding = isWeb ? 24.0 : 16.0;
    final double fontSizeTitle = isWeb ? 22.0 : 18.0;
    final double fontSizeContent = isWeb ? 18.0 : 14.0;
    final double cardSpacing = isWeb ? 20.0 : 12.0;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
              );
            },
          ),
          title: const Text(
            'Active Classes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: cardPadding, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Classes: ${activeClasses.length}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeContent,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: activeClasses.length,
                  itemBuilder: (context, index) {
                    final item = activeClasses[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: cardSpacing),
                      padding: EdgeInsets.all(cardPadding),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5FFF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeContent,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Student: ',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: item['student']),
                              ],
                            ),
                          ),
                          SizedBox(height: isWeb ? 8 : 4),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeContent,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Teacher: ',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: item['teacher']),
                              ],
                            ),
                          ),
                          SizedBox(height: isWeb ? 8 : 4),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeContent,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Duration: ',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                TextSpan(text: item['duration']),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
