import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../components/teacher_main_screen.dart';
import '../teacher_schedule_class/teacher_schedule_class.dart';
import 'class_list.dart';

class TeacherClassesMobileView extends StatelessWidget {
  const TeacherClassesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              'Classes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 3, color: appGreen),
                  insets: const EdgeInsets.symmetric(horizontal: 16),
                ),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Missed'),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              const Expanded(
                child: TabBarView(
                  children: [
                    ClassesList(type: 'upcoming'),
                    ClassesList(type: 'completed'),
                    ClassesList(type: 'missed'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appGreen,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScheduleClassesScreen()),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Schedule a Class', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: buildBottomNavigationBar(context, 1),
      ),
    );
  }
}
