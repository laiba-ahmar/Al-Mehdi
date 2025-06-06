import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import '../../constants/colors.dart';

class FeesStatusScreen extends StatefulWidget {
  const FeesStatusScreen({super.key});

  @override
  State<FeesStatusScreen> createState() => _FeesStatusScreenState();
}

class _FeesStatusScreenState extends State<FeesStatusScreen> {
  String selectedRole = 'All';
  String selectedStatus = 'All';
  TextEditingController searchController = TextEditingController();
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
          'feeStatus': data['feeStatus'] ?? 'Unpaid',
          'enabled': true,
        });
      }

      // Fetch teachers
      final teacherSnap = await firestore.collection('teachers').get();
      for (var doc in teacherSnap.docs) {
        final data = doc.data();
        fetchedUsers.add({
          'name': data['fullName'] ?? 'Unnamed',
          'role': 'Teacher',
          'feeStatus': data['feeStatus'] ?? 'Unpaid',
          'enabled': true,
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

  List<Map<String, dynamic>> get filteredUsers {
    return users.where((user) {
      final matchesRole = selectedRole == 'All' || user['role'] == selectedRole;
      final matchesStatus = selectedStatus == 'All' || user['feeStatus'] == selectedStatus;
      final matchesSearch = searchController.text.isEmpty ||
          user['name']!.toLowerCase().contains(searchController.text.toLowerCase());
      return matchesRole && matchesStatus && matchesSearch;
    }).toList();
  }

  Color getFeeStatusColor(String status) {
    if (status == 'Paid') return Colors.green;
    if (status == 'Unpaid') return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    Color dropdownColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : appLightGreen;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWeb = screenWidth > 600;

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
            'Fees Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? screenWidth * 0.06 : 16,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DropdownButton<String>(
                    focusColor: Colors.transparent,
                    icon: const Icon(Icons.arrow_drop_down, color: appGreen),
                    dropdownColor: dropdownColor,
                    value: selectedRole,
                    items: ['All', 'Teacher', 'Student']
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedRole = val;
                        });
                      }
                    },
                    underline: Container(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                    focusColor: Colors.transparent,
                    icon: const Icon(Icons.arrow_drop_down, color: appGreen),
                    dropdownColor: dropdownColor,
                    value: selectedStatus,
                    items: ['All', 'Paid', 'Unpaid']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          selectedStatus = val;
                        });
                      }
                    },
                    underline: Container(
                      height: 1,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      cursorColor: appGreen,
                      controller: searchController,
                      onChanged: (val) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search by name or email',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    Expanded(flex: 4, child: Text('User Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 3, child: Text('Fee Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Card(
                  color: Theme.of(context).cardColor,
                  shadowColor: Theme.of(context).shadowColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[300]),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(flex: 4, child: Text(user['name'] ?? '')),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getRoleColor(user['role'] ?? '').withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  user['role'] ?? '',
                                  style: TextStyle(
                                    color: getRoleColor(user['role'] ?? ''),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getFeeStatusColor(user['feeStatus'] ?? '').withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      user['feeStatus'] == 'Paid' ? 'Paid' : 'Unpaid',
                                      style: TextStyle(
                                        color: getFeeStatusColor(user['feeStatus'] ?? ''),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Switch(
                                      value: user['feeStatus'] == 'Paid',
                                      onChanged: (value) {
                                        setState(() {
                                          user['feeStatus'] = value ? 'Paid' : 'Unpaid';
                                          // Update Firestore accordingly
                                        });
                                      },
                                      activeColor: Colors.green,
                                      inactiveThumbColor: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getRoleColor(String role) {
    if (role == 'Teacher') return Colors.blue;
    if (role == 'Student') return Colors.orange;
    return Colors.grey;
  }
}
