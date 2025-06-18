import 'dart:io';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/change%20password.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants/colors.dart';

class StudentProfileMobile extends StatefulWidget {
  const StudentProfileMobile({super.key});

  @override
  State<StudentProfileMobile> createState() => _StudentProfileMobileState();
}

class _StudentProfileMobileState extends State<StudentProfileMobile> {
  String fullName = '';
  String email = '';
  String phone = '';
  String studentClass = '';
  File? selectedImage;
  bool isLoading = true;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
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
          studentClass = data['grade'] ?? '';
          isLoading = false;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CircleAvatar(
                  radius: 54,
                  backgroundImage:
                      selectedImage != null
                          ? FileImage(selectedImage!)
                          : const NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSzmDFOpRqmQmU64T6__2MDOl6NLaCK4I-10MHVrCGltXOSeXcl56_sD59-0ddr4M9aNc0&usqp=CAU',
                              )
                              as ImageProvider,
                ),
                TextButton(
                  onPressed: pickImage,
                  child: const Text(
                    'Upload',
                    style: TextStyle(color: appGreen),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildField('Full Name', fullName),
                      buildField('Email', email),
                      buildField('Phone', phone),
                      buildField('Class', studentClass),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: appGreen,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: appGreen),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Save Changes",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ChangePassword()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: appGreen,
                        side: const BorderSide(color: appGreen),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Change Password",
                          style: TextStyle(fontSize: 16),
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
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
