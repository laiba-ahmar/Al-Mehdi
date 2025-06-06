import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/Unassigned%20Users%20Screens/wait_for_assignment_screen.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/Main_page.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/register_screen.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/forgot_password.dart';
import 'package:al_mehdi_online_school/components/Custom_Textfield.dart';
import 'package:al_mehdi_online_school/components/Custom_button.dart';
import 'package:al_mehdi_online_school/components/Social_Login_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/admin_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Get the current logged-in user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No authenticated user found");

      // Check if the user is in the unassigned_students collection
      final unassignedStudentDoc = await FirebaseFirestore.instance.collection('unassigned_students').doc(user.uid).get();
      final unassignedTeacherDoc = await FirebaseFirestore.instance.collection('unassigned_teachers').doc(user.uid).get();

      // Check for unassigned student
      if (unassignedStudentDoc.exists && unassignedStudentDoc['assigned'] == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitForAssignmentScreen(role: 'Student'),
          ),
        );
      } else if (unassignedTeacherDoc.exists && unassignedTeacherDoc['assigned'] == false) {
        // Check for unassigned teacher
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitForAssignmentScreen(role: 'Teacher'),
          ),
        );
      } else {
        // Check if the user is a student or teacher and navigate accordingly
        final studentDoc = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
        final teacherDoc = await FirebaseFirestore.instance.collection('teachers').doc(user.uid).get();

        if (studentDoc.exists) {
          // If the user is a student, navigate to the student home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()), // Replace with Student Home
          );
        } else if (teacherDoc.exists) {
          // If the user is a teacher, navigate to the teacher home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()), // Replace with Teacher Home
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) return;

      // Check if the user is in the unassigned_students collection
      final unassignedStudentDoc = await FirebaseFirestore.instance.collection('unassigned_students').doc(user.uid).get();
      final unassignedTeacherDoc = await FirebaseFirestore.instance.collection('unassigned_teachers').doc(user.uid).get();

      if (unassignedStudentDoc.exists && unassignedStudentDoc['assigned'] == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitForAssignmentScreen(role: 'Student'),
          ),
        );
      } else if (unassignedTeacherDoc.exists && unassignedTeacherDoc['assigned'] == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitForAssignmentScreen(role: 'Teacher'),
          ),
        );
      } else {
        final docStudent = await FirebaseFirestore.instance.collection('students').doc(user.uid).get();
        final docTeacher = await FirebaseFirestore.instance.collection('teachers').doc(user.uid).get();

        if (!docStudent.exists && !docTeacher.exists) {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account not found. Please register first.")),
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPassword()),
    );
  }

  void _goToAdminScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
    );
  }

  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth >= 800) {
      return 400;
    } else if (screenWidth >= 600) {
      return 350;
    } else {
      return screenWidth * 0.9;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textScale = screenWidth > 600 ? 1.2 : 1.0;
    double responsiveWidth = _getResponsiveWidth(screenWidth);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Container(
                width: responsiveWidth,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50 * textScale,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextfield(
                labelText: 'Email',
                width: responsiveWidth,
                controller: _emailController,
                obscureText: false, // Email field should not obscure text
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                labelText: 'Password',
                width: responsiveWidth,
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Login',
                onPressed: signIn,
                width: responsiveWidth,
              ),
              const SizedBox(height: 20),
              Container(
                width: responsiveWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: _navigateToForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: Color(0xff02D185)),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xff02D185)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: responsiveWidth,
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.grey, thickness: 1, endIndent: 10)),
                    const Text('OR', style: TextStyle(color: Colors.grey)),
                    const Expanded(child: Divider(color: Colors.grey, thickness: 1, indent: 10)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SocialLoginButton(
                imagePath: 'assets/logo/Google.png',
                labelText: 'Continue with Google',
                imagePadding: const EdgeInsets.only(left: 15),
                width: responsiveWidth,
                onPressed: _signInWithGoogle,
              ),
              const SizedBox(height: 10),
              SocialLoginButton(
                imagePath: 'assets/logo/apple.png',
                labelText: 'Continue with Apple',
                imagePadding: const EdgeInsets.only(left: 10),
                width: responsiveWidth,
                onPressed: () {}, // TODO: Implement Apple Sign-In
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _goToAdminScreen,
                child: const Text(
                  'Login as Admin',
                  style: TextStyle(color: Color(0xff02D185)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
