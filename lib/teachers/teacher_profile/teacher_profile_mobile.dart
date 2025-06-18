import 'dart:io';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/change%20password.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constants/colors.dart';

class TeacherProfileMobile extends StatefulWidget {
  const TeacherProfileMobile({super.key});

  @override
  State<TeacherProfileMobile> createState() => _TeacherProfileMobileState();
}

class _TeacherProfileMobileState extends State<TeacherProfileMobile> {
  String fullName = '';
  String email = '';
  String phone = '';
  String degree = '';
  bool isLoading = true;
  File? selectedImage;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Start loading data immediately but don't block the UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTeacherInfo();
    });
  }

  Future<void> fetchTeacherInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('teachers')
                .doc(user.uid)
                .get();
        if (doc.exists && mounted) {
          final data = doc.data()!;
          setState(() {
            fullName = data['fullName'] ?? '';
            email = data['email'] ?? '';
            phone = data['phoneNumber'] ?? '';
            degree = data['degree'] ?? '';
            isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
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
                selectedImage != null
                    ? CircleAvatar(
                      radius: 54,
                      backgroundImage: FileImage(selectedImage!),
                    )
                    : CircleAvatar(
                      radius: 54,
                      backgroundColor: appGreen,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
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
              fullName.isNotEmpty ? fullName : 'Loading...',
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
                      buildField(
                        'Full Name',
                        fullName.isNotEmpty ? fullName : 'Loading...',
                      ),
                      buildField(
                        'Email',
                        email.isNotEmpty ? email : 'Loading...',
                      ),
                      buildField(
                        'Phone',
                        phone.isNotEmpty ? phone : 'Loading...',
                      ),
                      buildField(
                        'Degree',
                        degree.isNotEmpty ? degree : 'Loading...',
                      ),
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
