import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../constants/colors.dart';
import '../../students/student_notifications/student_notifications.dart';
import '../components/student_sidebar.dart';
import '../../components/teacher_image_picker.dart'; // reuse teacher image picker

class StudentProfileWeb extends StatefulWidget {
  const StudentProfileWeb({super.key});

  @override
  State<StudentProfileWeb> createState() => _StudentProfileWebState();
}

class _StudentProfileWebState extends State<StudentProfileWeb> {
  String fullName = '';
  String email = '';
  String phone = '';
  String studentClass = '';
  Uint8List? uploadedImageBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentInfo();
  }

  Future<void> fetchStudentInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('students')
              .doc(user.uid)
              .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          fullName = data['fullName'] ?? '';
          email = data['email'] ?? '';
          phone = data['phoneNumber'] ?? '';
          studentClass = data['class'] ?? '';
          isLoading = false;
        });
      }
    }
  }

  Future<void> handleImageUpload() async {
    final bytes = await pickImagePlatform();
    if (bytes != null) {
      setState(() {
        uploadedImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          StudentSidebar(selectedIndex: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const StudentNotificationScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 150,
                          child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 70,
                                    backgroundImage:
                                        uploadedImageBytes != null
                                            ? MemoryImage(uploadedImageBytes!)
                                            : null,
                                    backgroundColor: Colors.purple[100],
                                    child:
                                        uploadedImageBytes == null
                                            ? const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            )
                                            : null,
                                  ),
                                  const SizedBox(height: 10),
                                  TextButton(
                                    onPressed: handleImageUpload,
                                    child: const Text(
                                      "Upload",
                                      style: TextStyle(
                                        color: appGreen,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "Student",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 10),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Iconsax.verify, color: appGreen),
                                      SizedBox(width: 5),
                                      Text(
                                        "Enrolled",
                                        style: TextStyle(color: appGreen),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 150,
                          child: Card(
                            color: Theme.of(context).cardColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  buildField("Full Name", fullName),
                                  buildField("Email", email),
                                  buildField("Phone", phone),
                                  buildField("Class", studentClass),
                                  const SizedBox(height: 30),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      if (constraints.maxWidth > 300) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {},
                                              child: const Text(
                                                "Change Password",
                                                style: TextStyle(
                                                  color: appGreen,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: appGreen,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text(
                                                "Save Changes",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            Center(
                                              child: TextButton(
                                                onPressed: () {},
                                                child: const Text(
                                                  "Change Password",
                                                  style: TextStyle(
                                                    color: appGreen,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: appGreen,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: const Text(
                                                  "Save Changes",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
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

  Widget buildField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: appGrey),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: appGrey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
