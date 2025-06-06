import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import '../../constants/colors.dart';

class TotalUsersScreen extends StatefulWidget {
  const TotalUsersScreen({super.key});

  @override
  State<TotalUsersScreen> createState() => _TotalUsersScreenState();
}

class _TotalUsersScreenState extends State<TotalUsersScreen> {
  String selectedRole = 'All';
  String selectedStatus = 'All';
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> fetchedUsers = [];

    try {
      // Fetch students
      final studentSnap = await firestore.collection('students').get();
      for (var doc in studentSnap.docs) {
        final data = doc.data();
        fetchedUsers.add({
          'name': data['fullName'] ?? 'Unnamed',
          'role': 'Student',
          'enabled': true,
          'avatarUrl': data['avatarUrl'] ?? 'https://i.pravatar.cc/100?img=11'
        });
      }

      // Fetch teachers
      final teacherSnap = await firestore.collection('teachers').get();
      for (var doc in teacherSnap.docs) {
        final data = doc.data();
        fetchedUsers.add({
          'name': data['fullName'] ?? 'Unnamed',
          'role': 'Teacher',
          'enabled': true,
          'avatarUrl': data['avatarUrl'] ?? 'https://i.pravatar.cc/100?img=12'
        });
      }

      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color dropdownColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : appLightGreen;

    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final double padding = isWeb ? 32 : 16;
    final double fontSize = isWeb ? 18 : 15;
    final double avatarRadius = isWeb ? 28 : 22;
    final double cardSpacing = isWeb ? 16 : 10;
    final double dropdownWidth = isWeb ? 180 : 140;

    final filteredUsers = users.where((user) {
      final roleMatch = selectedRole == 'All' || user['role'] == selectedRole;
      final statusMatch = selectedStatus == 'All' ||
          (selectedStatus == 'Enabled' && user['enabled'] == true) ||
          (selectedStatus == 'Disabled' && user['enabled'] == false);
      return roleMatch && statusMatch;
    }).toList();

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
          title: const Text(
            'Total User',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registered Users: ${filteredUsers.length}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: isWeb ? MainAxisAlignment.start : MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDropdown('Role', ['All', 'Student', 'Teacher'], selectedRole, (val) {
                          setState(() => selectedRole = val);
                        }, dropdownWidth, fontSize, dropdownColor),
                        const SizedBox(width: 16),
                        _buildDropdown('Status', ['All', 'Enabled', 'Disabled'], selectedStatus, (val) {
                          setState(() => selectedStatus = val);
                        }, dropdownWidth, fontSize, dropdownColor),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredUsers.length,
                        separatorBuilder: (_, __) => SizedBox(height: cardSpacing),
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return Container(
                            padding: EdgeInsets.all(isWeb ? 20 : 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5FFF6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: avatarRadius,
                                  backgroundImage: NetworkImage(user['avatarUrl']),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black, fontSize: fontSize),
                                          children: [
                                            const TextSpan(
                                              text: 'Name: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(text: user['name']),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(color: Colors.black, fontSize: fontSize),
                                          children: [
                                            const TextSpan(
                                              text: 'Role: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            TextSpan(text: user['role']),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: user['enabled'] ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      user['enabled'] = value;
                                    });
                                  },
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String selectedValue,
      Function(String) onChanged, double width, double fontSize, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      width: width,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: DropdownButton<String>(
          focusColor: Colors.transparent,
          icon: const Icon(Icons.arrow_drop_down, color: appGreen),
          underline: const SizedBox.shrink(),
          dropdownColor: bgColor,
          value: selectedValue,
          isExpanded: true,
          onChanged: (value) => onChanged(value ?? options[0]),
          items: options
              .map((val) => DropdownMenuItem(
                    value: val,
                    child: Text(
                      val,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  ))
              .toList(),
          style: TextStyle(fontSize: fontSize),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
