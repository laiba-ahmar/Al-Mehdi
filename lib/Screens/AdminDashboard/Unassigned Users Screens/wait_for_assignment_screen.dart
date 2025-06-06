import 'package:al_mehdi_online_school/Screens/Auth%20Screens/login_screen.dart';
import 'package:flutter/material.dart';

class WaitForAssignmentScreen extends StatelessWidget {
  final String role; // 'Student' or 'Teacher'

  const WaitForAssignmentScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
        title: Text('Waiting for Assignment'),
      ),
      body: Center(
        child: Text(
          'Please wait for admin to assign you to a ${role == 'Teacher' ? 'student' : 'teacher'}.',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
