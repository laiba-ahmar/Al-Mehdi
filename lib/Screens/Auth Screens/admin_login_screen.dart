import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:al_mehdi_online_school/Screens/AdminDashboard/admin_home_screen.dart';
import 'package:al_mehdi_online_school/Screens/Auth%20Screens/login_screen.dart';
import 'package:al_mehdi_online_school/components/Custom_Textfield.dart';
import 'package:al_mehdi_online_school/components/Custom_button.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _goToAdminScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
    );
  }

  void _goBackToLoginScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  double _getResponsiveWidth(double screenWidth) {
    if (screenWidth >= 800) return 400;
    if (screenWidth >= 600) return 350;
    return screenWidth * 0.9;
  }

  Future<void> _loginAdmin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      print('Attempting login for admin: $email');

      final query = await FirebaseFirestore.instance
          .collection('admin') // Ensure collection name is correct
          .where('email', isEqualTo: email)
          .get();

      print('Query found ${query.docs.length} documents');

      if (query.docs.isEmpty) {
        _showError('Admin email not found.');
      } else {
        final data = query.docs.first.data();
        print('Fetched admin data: $data');

        if (data['password'] == password) {
          _goToAdminScreen();
        } else {
          _showError('Incorrect password.');
        }
      }
    } catch (e) {
      print('Login error: $e');
      _showError('Something went wrong. Please try again.');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = screenWidth > 600 ? 1.2 : 1.0;
    final responsiveWidth = _getResponsiveWidth(screenWidth);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToLoginScreen,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: responsiveWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Welcome Admin',
                      style: TextStyle(
                        fontSize: 50 * textScale,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 20 * textScale,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  CustomTextfield(
                    labelText: 'Email',
                    controller: _emailController,
                    width: responsiveWidth,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  CustomTextfield(
                    labelText: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    width: responsiveWidth,
                  ),
                  const SizedBox(height: 30),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          text: 'Login',
                          onPressed: _loginAdmin,
                          width: responsiveWidth,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
