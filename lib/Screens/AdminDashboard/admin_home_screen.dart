import 'package:al_mehdi_online_school/Screens/AdminDashboard/active_class_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/fees_status_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/notifications.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/admin_mian_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/attendance_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/chat_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/profile_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/schedule_class.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/sidebar%20and%20bottom%20Tabs%20Screens/settings_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/total_users_screen.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/Unassigned%20Users%20Screens/unassigned_users_screen.dart';
import 'package:al_mehdi_online_school/components/admin_sidebar.dart';
import 'package:al_mehdi_online_school/components/custom_bottom_nabigator.dart';
import 'package:flutter/material.dart';
import 'package:al_mehdi_online_school/constants/colors.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth >= 900;

    if (isWeb) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            AdminSidebar(selectedIndex: 0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/logo/Frame.png', width: 36, height: 36),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Admin Dashboard',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 24)),
                                Text('Control center for everything',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Notifications()),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final spacing = 16.0;
                        final totalSpacing = spacing * 3;
                        final cardWidth = (constraints.maxWidth - totalSpacing) / 4;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: cardWidth,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () => _goToActiveClass(context),
                                    child: _infoCard(
                                      context: context,
                                      assetPath: 'assets/logo/Activeclass.png',
                                      number: '38',
                                      label: 'Active Classes',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () => _goToTotalUsers(context),
                                    child: _infoCard(
                                      context: context,
                                      assetPath: 'assets/logo/Totaluser.png',
                                      number: '120',
                                      label: 'Total Users',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () => _goToUnassignedUsers(context),
                                    child: _infoCard(
                                      context: context,
                                      assetPath: 'assets/logo/Unassigneduser.png',
                                      number: '30',
                                      label: 'Unassigned users',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: cardWidth,
                                  child: InkWell(
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () => _goToFeesStatus(context),
                                    child: _infoCard(
                                      context: context,
                                      assetPath: 'assets/logo/Fees.png',
                                      number: 'Paid/Unpaid',
                                      label: 'Fees Status',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add user action here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  '+ Add User',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _userList(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return AdminMainScreen();
    }
  }
}

class MobileVersion extends StatelessWidget {
  const MobileVersion({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Image.asset('assets/logo/Frame.png', width: 32, height: 32),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Admin Dashboard',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text('Control center for everything',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => _goToActiveClass(context),
                  child: SizedBox(
                    width: (screenWidth - 48) / 2,
                    child: _infoCard(
                      context: context,
                      assetPath: 'assets/logo/Activeclass.png',
                      number: '38',
                      label: 'Active Classes',
                    ),
                  ),
                ),
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () =>_goToTotalUsers(context),
                  child: SizedBox(
                    width: (screenWidth - 48) / 2,
                    child: _infoCard(
                      context: context,
                      assetPath: 'assets/logo/Totaluser.png',
                      number: '120',
                      label: 'Total Users',
                    ),
                  ),
                ),
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => _goToUnassignedUsers(context),
                  child: SizedBox(
                    width: (screenWidth - 48) / 2,
                    child: _infoCard(
                      context: context,
                      assetPath: 'assets/logo/Unassigneduser.png',
                      number: '30',
                      label: 'Unassigned users',
                    ),
                  ),
                ),
                InkWell(
                  hoverColor: Colors.transparent,
                  onTap: () => _goToFeesStatus(context),
                  child: SizedBox(
                    width: (screenWidth - 48) / 2,
                    child: _infoCard(
                      context: context,
                      assetPath: 'assets/logo/Fees.png',
                      number: 'Paid/Unpaid',
                      label: 'Fees Status',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Schedule Class Button (full width)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _goToScheduleClass,
                style: ElevatedButton.styleFrom(
                  backgroundColor: appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Schedule Class',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Add User Button (full width)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add user action here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '+ Add User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }
}


_userList(BuildContext context) {
  return Card(
    color: Theme.of(context).cardColor,
    shadowColor: Theme.of(context).shadowColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manage Users',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            cursorColor: appGreen,
            decoration: InputDecoration(
              hintText: 'Search Users...',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Grey outline color
                  width: 1.0, // Adjust thickness as needed
                ), // No focus border
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.grey.shade400, // Grey outline color
                  width: 1.0, // Adjust thickness as needed
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1')),
            title: const Text('Ali Khan'),
            subtitle: const Text('ali.khan@example.com'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: appGreen)),
                  child: const Text('Student'),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: appGreen, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: const [
                      Icon(Icons.check, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Paid', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _infoCard({
  required BuildContext context,
  required String assetPath,
  required String number,
  required String label,
  String? extraLabel,
}) {
  return Card(
    color: Theme.of(context).cardColor,
    shadowColor: Theme.of(context).shadowColor,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(assetPath, width: 50, height: 50, fit: BoxFit.contain),
          const SizedBox(height: 12),
          Text(
            number,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          if (extraLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              extraLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    ),
  );
}

void _goToActiveClass(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const ActiveClassScreen()),
  );
}

void _goToTotalUsers(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const TotalUsersScreen()),
  );
}

void _goToUnassignedUsers(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const UnassignedUsersScreen()),
  );
}

void _goToFeesStatus(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const FeesStatusScreen()),
  );
}

void _goToScheduleClass(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const ScheduleClass()),
  );
}