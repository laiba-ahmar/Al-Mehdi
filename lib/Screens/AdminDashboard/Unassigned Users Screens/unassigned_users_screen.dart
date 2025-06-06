import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import 'Teachers_details.dart';

class UnassignedUsersScreen extends StatefulWidget {
  const UnassignedUsersScreen({super.key});

  @override
  State<UnassignedUsersScreen> createState() => _UnassignedUsersScreenState();
}

class _UnassignedUsersScreenState extends State<UnassignedUsersScreen> {
  List<Map<String, dynamic>> unassignedTeachers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUnassignedTeachers();
  }

  Future<void> fetchUnassignedTeachers() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('unassigned_teachers')
      .where('assigned', isEqualTo: false)
      .get();

    setState(() {
      unassignedTeachers = snapshot.docs.map((doc) => {
        'uid': doc['uid'],
        'name': doc['fullName'],
        'role': 'Teacher',
        'avatar': 'https://i.pravatar.cc/100?u=${doc['uid']}',
      }).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    final double fontSize = isWeb ? 18 : 14;
    final double padding = isWeb ? 24 : 16;
    final double avatarSize = isWeb ? 48 : 40;
    final double cardMargin = isWeb ? 16 : 12;

    if (loading) return const Center(child: CircularProgressIndicator());
    if (unassignedTeachers.isEmpty) return const Center(child: Text('No unassigned teachers'));

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
        );
        return false;
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
          title: const Text('Unassigned Teachers', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
          child: ListView.separated(
            itemCount: unassignedTeachers.length,
            separatorBuilder: (_, __) => SizedBox(height: cardMargin),
            itemBuilder: (context, index) {
              final user = unassignedTeachers[index];
              final isTeacher = user['role'] == 'Teacher';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeachersDetails(user: user),
                    ),
                  );
                },
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Theme.of(context).shadowColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user['name'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isTeacher ? Colors.blue[50] : Colors.amber[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['role'] ?? '',
                                  style: TextStyle(
                                    fontSize: fontSize - 2,
                                    color: isTeacher ? Colors.blue : Colors.orange[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
