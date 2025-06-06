import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../teachers/teacher_classes_screen/class_list.dart';
import '../components/student_navbar.dart';

class StudentClassesMobileView extends StatelessWidget {
  const StudentClassesMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
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
        body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: TabBarView(
            children: [
              ClassesList(type: 'upcoming'),
              ClassesList(type: 'completed'),
              ClassesList(type: 'missed'),
            ],
          ),
        ),
        // bottomNavigationBar: const StudentNavbar(selectedIndex: 1),
      ),
    );
  }
}
