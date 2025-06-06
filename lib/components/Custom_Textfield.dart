import 'package:al_mehdi_online_school/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String labelText;
  final double? width;
  final TextEditingController? controller;
  final bool obscureText; // To determine whether it's for password or email

  const CustomTextfield({
    Key? key,
    required this.labelText,
    this.width,
    this.controller,
    this.obscureText = false, // Default is false, for email or non-password fields
  }) : super(key: key);

  @override
  _CustomTextfieldState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; // Set the initial value of _obscureText
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 400,
      child: TextField(
        cursorColor: appGreen,
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Theme.of(context).textTheme.displayMedium?.color,
          ),
          floatingLabelStyle: TextStyle(color: appGreen),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 206, 206, 206)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: appGreen),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 206, 206, 206)),
          ),
          // Show the eye icon only if it's for a password field
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).textTheme.displayMedium?.color,
                  ),
                  onPressed: _togglePasswordVisibility,
                )
              : null, // If not a password, no icon will show
        ),
      ),
    );
  }
}
