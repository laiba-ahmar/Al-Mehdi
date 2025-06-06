import 'package:al_mehdi_online_school/Screens/AdminDashboard/Unassigned%20Users%20Screens/wait_for_assignment_screen.dart';
import 'package:al_mehdi_online_school/components/Custom_button.dart';
import 'package:al_mehdi_online_school/components/Custom_Textfield.dart';
import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:al_mehdi_online_school/teachers/teacher_home_screen/teacher_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TeachersRegistration extends StatefulWidget {
  const TeachersRegistration({super.key});

  @override
  State<TeachersRegistration> createState() => _TeachersRegistrationState();
}

class _TeachersRegistrationState extends State<TeachersRegistration> {
  String? selectedCountry;
  String? selectedDegree;
  PlatformFile? degreeFile;
  bool isSubmitting = false;

  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  final List<String> countries = [
    'United States', 'Canada', 'United Kingdom', 'Australia', 'India',
    'Germany', 'France', 'Spain', 'Italy', 'Brazil', 'Mexico', 'Japan',
    'China', 'South Korea', 'Russia', 'South Africa', 'Nigeria', 'Egypt',
    'Saudi Arabia', 'United Arab Emirates', 'Pakistan', 'Bangladesh',
    'Indonesia', 'Philippines', 'Vietnam', 'Thailand', 'Malaysia', 'Singapore',
    'New Zealand', 'Ireland', 'Netherlands', 'Sweden', 'Norway', 'Denmark',
  ];

  final List<String> degrees = [
    'Bachelor', 'Master', 'PhD', 'Diploma', 'Associate'
  ];

  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth >= 800) return 400;
    if (screenWidth >= 600) return 350;
    return screenWidth * 0.9;
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      setState(() {
        degreeFile = result.files.first;
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (_fullNameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        selectedCountry == null ||
        selectedDegree == null ||
        degreeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields including full name, phone number, and document are required")),
      );
      return;
    }

    try {
      setState(() => isSubmitting = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not authenticated");

      await FirebaseFirestore.instance.collection('teachers').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'country': selectedCountry,
        'degree': selectedDegree,
        'assignedStudentId': null, // initially no assignment
        'createdAt': Timestamp.now(),
      });

      // Add to unassigned_teachers for admin notification
      await FirebaseFirestore.instance.collection('unassigned_teachers').doc(user.uid).set({
        'uid': user.uid,
        'fullName': _fullNameController.text.trim(),
        'assigned': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // After registration, check assignment and route accordingly
      final doc = await FirebaseFirestore.instance.collection('teachers').doc(user.uid).get();
      final assignedStudentId = doc.data()?['assignedStudentId'];

      if (assignedStudentId == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WaitForAssignmentScreen(role: 'Teacher')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeacherHomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color dropdownColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : appLightGreen;

    double screenWidth = MediaQuery.of(context).size.width;
    double responsiveWidth = _getResponsiveWidth(screenWidth);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                child: const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    'Teachers Registration',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: responsiveWidth,
                child: const Text(
                  'Please fill in the details below to register as a teacher.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              CustomTextfield(
                labelText: 'Full Name',
                width: responsiveWidth,
                controller: _fullNameController,
              ),
              const SizedBox(height: 16),

              // Phone Number
              CustomTextfield(
                labelText: 'Phone Number',
                width: responsiveWidth,
                controller: _phoneNumberController,
              ),
              const SizedBox(height: 16),

              // Country dropdown
              Container(
                width: responsiveWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  value: selectedCountry,
                  hint: const Text('Select your country'),
                  onChanged: (value) => setState(() => selectedCountry = value),
                  items: countries.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  isExpanded: true,
                  focusColor: Colors.transparent,
                  dropdownColor: dropdownColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 16),

              // Degree dropdown
              Container(
                width: responsiveWidth,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButton<String>(
                  underline: const SizedBox.shrink(),
                  value: selectedDegree,
                  hint: const Text('Select your degree'),
                  onChanged: (value) => setState(() => selectedDegree = value),
                  items: degrees.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  isExpanded: true,
                  dropdownColor: dropdownColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 24),

              // Upload document
              SizedBox(
                width: responsiveWidth,
                child: OutlinedButton.icon(
                  onPressed: _pickDocument,
                  icon: const Icon(Icons.upload_file, color: Color(0xff02D185)),
                  label: Text(
                    degreeFile != null ? degreeFile!.name : 'Upload Degree Document',
                    style: const TextStyle(color: Color(0xff02D185)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xff02D185)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: responsiveWidth,
                height: 45,
                child: isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Register',
                        onPressed: _submitRegistration,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
