import 'package:al_mehdi_online_school/components/Custom_Textfield.dart';
import 'package:al_mehdi_online_school/components/Custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reset link sent to $email")),
      );
      Navigator.pop(context); // Back to login screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
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
        leading: BackButton(),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: responsiveWidth,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Forgot Password',
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
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Reset Password',
                onPressed: _resetPassword,
                width: responsiveWidth,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(
                    color: const Color(0xff02D185),
                    fontSize: 16 * textScale,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
