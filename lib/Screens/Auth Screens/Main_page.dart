import 'package:al_mehdi_online_school/Screens/Auth%20Screens/login_screen.dart';
import 'package:al_mehdi_online_school/students/student_home_screen/student_home_screen.dart';
import 'package:al_mehdi_online_school/teachers/teacher_home_screen/teacher_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  Future<Widget> _determineRoleAndNavigate(User user) async {
    final uid = user.uid;

    final studentDoc = await FirebaseFirestore.instance.collection('students').doc(uid).get();
    if (studentDoc.exists) {
      return const StudentHomeScreen();
    }

    final teacherDoc = await FirebaseFirestore.instance.collection('teachers').doc(uid).get();
    if (teacherDoc.exists) {
      return const TeacherHomeScreen();
    }

    return const Center(child: Text("Unknown role or user not found"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            return FutureBuilder<Widget>(
              future: _determineRoleAndNavigate(snapshot.data!),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasData) {
                  return roleSnapshot.data!;
                } else {
                  return const Center(child: Text("Error loading user role"));
                }
              },
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
