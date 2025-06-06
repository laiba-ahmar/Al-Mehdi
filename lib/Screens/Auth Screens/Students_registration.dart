import 'package:al_mehdi_online_school/Screens/AdminDashboard/Unassigned%20Users%20Screens/wait_for_assignment_screen.dart';
import 'package:al_mehdi_online_school/components/Custom_Textfield.dart';
import 'package:flutter/material.dart';
import 'package:al_mehdi_online_school/components/Custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';
import '../../students/student_home_screen/student_home_screen.dart';

class StudentsRegistration extends StatefulWidget {
  const StudentsRegistration({super.key});

  @override
  State<StudentsRegistration> createState() => _StudentsRegistrationState();
}

class _StudentsRegistrationState extends State<StudentsRegistration> {
  String? selectedCountry;
  final _fullNameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final List<String> countries = [
    'United States', 'Canada', 'United Kingdom', 'Australia', 'India',
    'Germany', 'France', 'Spain', 'Italy', 'Brazil', 'Mexico', 'Japan',
    'China', 'South Korea', 'Russia', 'South Africa', 'Nigeria', 'Egypt',
    'Saudi Arabia', 'United Arab Emirates', 'Pakistan', 'Bangladesh',
    'Indonesia', 'Philippines', 'Vietnam', 'Thailand', 'Malaysia', 'Singapore',
    'New Zealand', 'Ireland', 'Netherlands', 'Sweden', 'Norway', 'Denmark',
  ];

  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth >= 800) return 400;
    if (screenWidth >= 600) return 350;
    return screenWidth * 0.9;
  }

  Future<void> _submitStudentData() async {
    if (_fullNameController.text.isEmpty ||
        selectedCountry == null ||
        _gradeController.text.isEmpty ||
        _subjectController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No authenticated user found");

      final studentData = {
        'uid': user.uid,
        'email': user.email,
        'fullName': _fullNameController.text.trim(),
        'country': selectedCountry,
        'grade': _gradeController.text.trim(),
        'favouriteSubject': _subjectController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'role': 'Student',
        'assignedTeacherId': null, // initially no assignment
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('students').doc(user.uid).set(studentData);

      // Add to unassigned_students collection for admin notification
      await FirebaseFirestore.instance.collection('unassigned_students').doc(user.uid).set({
        'uid': user.uid,
        'fullName': _fullNameController.text.trim(),
        'assigned': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // After registration, check assignment and route accordingly
      final doc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
      final assignedTeacherId = doc.data()?['assignedTeacherId'];

      if (assignedTeacherId == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WaitForAssignmentScreen(role: 'Student')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const StudentHomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _gradeController.dispose();
    _subjectController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color dropdownColor = Theme.of(context).brightness == Brightness.dark ? darkBackground : appLightGreen;
    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveWidth = _getResponsiveWidth(screenWidth);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: responsiveWidth,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: const Text(
                    'Students Registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: responsiveWidth,
                child: const Text(
                  'Please fill in the details below to register as a student.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextfield(
                labelText: 'Full Name',
                width: responsiveWidth,
                controller: _fullNameController,
              ),
              const SizedBox(height: 24),
              CustomTextfield(
                labelText: 'Phone Number',
                width: responsiveWidth,
                controller: _phoneNumberController,
              ),
              const SizedBox(height: 24),
              Container(
                width: responsiveWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<String>(
                  focusColor: Colors.transparent,
                  dropdownColor: dropdownColor,
                  underline: const SizedBox.shrink(),
                  value: selectedCountry,
                  hint: const Text('Select your country', style: TextStyle(fontSize: 16)),
                  onChanged: (value) => setState(() => selectedCountry = value),
                  items: countries.map((country) => DropdownMenuItem(value: country, child: Text(country))).toList(),
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextfield(
                labelText: 'Currently Studying in which Grade',
                width: responsiveWidth,
                controller: _gradeController,
              ),
              const SizedBox(height: 24),
              CustomTextfield(
                labelText: 'Favourite Subject',
                width: responsiveWidth,
                controller: _subjectController,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: responsiveWidth,
                height: 45,
                child: CustomButton(
                  text: 'Register',
                  onPressed: _submitStudentData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
