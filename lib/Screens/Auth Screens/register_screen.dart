import 'package:al_mehdi_online_school/Screens/Auth%20Screens/Students_registration.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/Teachers_registration.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/login_screen.dart';
import 'package:al_mehdi_online_school/components/Custom_Textfield.dart';
import 'package:al_mehdi_online_school/components/Custom_button.dart';
import 'package:al_mehdi_online_school/components/Social_Login_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../constants/colors.dart';

class MyDropdown extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String?> onChanged;
  final double? width;

  const MyDropdown({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Color dropdownColor = Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : appLightGreen;

    return Container(
      width: width ?? 400,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        focusColor: Colors.transparent,
        dropdownColor: dropdownColor,
        underline: const SizedBox.shrink(),
        value: selectedRole,
        onChanged: onChanged,
        items: const [
          DropdownMenuItem<String>(value: "Role", child: Text('Role')),
          DropdownMenuItem<String>(value: "Student", child: Text('Student')),
          DropdownMenuItem<String>(value: "Teacher", child: Text('Teacher')),
        ],
        isExpanded: true,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  String _selectedRole = "Role";

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _registerAndNavigate() async {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (_selectedRole == "Role") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a valid role")),
      );
      return;
    }

    if (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      await _firestore
          .collection(_selectedRole == "Student" ? "students" : "teachers")
          .doc(uid)
          .set({
        "fullName": fullName,
        "email": email,
        "role": _selectedRole,
        "uid": uid,
        "createdAt": Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => _selectedRole == "Student"
              ? const StudentsRegistration()
              : const TeachersRegistration(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Registration failed";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    if (_selectedRole == "Role") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a role before continuing with Google")),
      );
      return;
    }

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

      final roleCollection = _selectedRole == "Student" ? "students" : "teachers";
      final doc = await _firestore.collection(roleCollection).doc(user.uid).get();

      if (!doc.exists) {
        await _firestore.collection(roleCollection).doc(user.uid).set({
          "fullName": user.displayName ?? '',
          "email": user.email ?? '',
          "role": _selectedRole,
          "uid": user.uid,
          "createdAt": Timestamp.now(),
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => _selectedRole == "Student"
              ? const StudentsRegistration()
              : const TeachersRegistration(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google sign-in failed: $e")),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth >= 800) return 400;
    if (screenWidth >= 600) return 350;
    return screenWidth * 0.9;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textScale = screenWidth > 600 ? 1.2 : 1.0;
    double responsiveWidth = _getResponsiveWidth(screenWidth);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: responsiveWidth,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Create Account',
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
                labelText: 'Full Name',
                width: responsiveWidth,
                controller: _fullNameController,
                obscureText: false, // Full name field should not be obscured  
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                labelText: 'Email',
                width: responsiveWidth,
                controller: _emailController,
                obscureText: false, // Email field should not be obscured
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                labelText: 'Password',
                width: responsiveWidth,
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                labelText: 'Confirm Password',
                width: responsiveWidth,
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              MyDropdown(
                width: responsiveWidth,
                selectedRole: _selectedRole,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRole = value);
                  }
                },
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Register',
                onPressed: _registerAndNavigate,
                width: responsiveWidth,
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
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 2),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xff02D185),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
