import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../teachers/teacher_classes_screen/class_list.dart';
import '../components/student_sidebar.dart';
import '../student_notifications/student_notifications.dart';

class StudentClassesWebView extends StatefulWidget {
  const StudentClassesWebView({super.key});

  @override
  State<StudentClassesWebView> createState() => _StudentClassesWebViewState();
}

class _StudentClassesWebViewState extends State<StudentClassesWebView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          StudentSidebar(selectedIndex: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  child: Row(
                    children: [
                      const Text(
                        'Classes',
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
                // Tabs + Content
                Expanded(
                  child: Row(
                    children: [
                      // Sidebar Tabs
                      Container(
                        width: 250,
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: Color(0xFFE5EAF1), width: 1)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            _WebTab(label: 'Upcoming', selected: _tabController.index == 0, onTap: () => setState(() => _tabController.index = 0)),
                            _WebTab(label: 'Completed', selected: _tabController.index == 1, onTap: () => setState(() => _tabController.index = 1)),
                            _WebTab(label: 'Missed', selected: _tabController.index == 2, onTap: () => setState(() => _tabController.index = 2)),
                          ],
                        ),
                      ),
                      // Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              ClassesList(type: 'upcoming'),
                              ClassesList(type: 'completed'),
                              ClassesList(type: 'missed'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WebTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _WebTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: selected ? 18 : 16,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: selected ? 40 : 0,
              decoration: BoxDecoration(
                color: selected ? appGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}