import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';


class TextFields extends StatelessWidget {
  final String label;
  final int maxLines;
  final IconData? icon;
  final bool isDatePicker;
  final bool isTimePicker;
  final TextEditingController? controller;

  const TextFields({super.key,
    required this.label,
    this.maxLines = 1,
    this.icon,
    this.isDatePicker = false,
    this.isTimePicker = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController internalController = controller ?? TextEditingController();

    return GestureDetector(
      onTap: (isDatePicker || isTimePicker)
          ? () async {
        FocusScope.of(context).unfocus(); // Hide keyboard

        if (isDatePicker) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: appGreen, // Header and buttons
                    onPrimary: Color(0xFFe5faf3),
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green, // Button text color
                    ),
                  ), dialogTheme: DialogThemeData(backgroundColor: Color(0xFFe5faf3)),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            internalController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
          }
        }

        if (isTimePicker) {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: appGreen, // Header and buttons
                    onPrimary: Color(0xFFe5faf3),
                    onSurface: Colors.black,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedTime != null) {
            final now = DateTime.now();
            final time = DateTime(
              now.year,
              now.month,
              now.day,
              pickedTime.hour,
              pickedTime.minute,
            );
            internalController.text = DateFormat('hh:mm a').format(time);
          }
        }
      }
          : null,
      child: AbsorbPointer(
        absorbing: isDatePicker || isTimePicker,
        child: TextField(
          cursorColor: appGreen,
          controller: internalController,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 15, color: Colors.black ),
          decoration: InputDecoration(
            label: Text(label, style: TextStyle(fontSize: 15, color: Colors.black),),
            floatingLabelStyle: TextStyle(color: appGreen),
            prefixIcon: icon != null ? Icon(icon, color: appGreen) : null,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: appGreen),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownField extends StatelessWidget {
  final String label;
  final List<String> options;

  const DropdownField({super.key, required this.label, this.options = const ['Math', 'Science', 'English']});

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(
      dropdownColor: appLightGreen,
      icon: Icon(Icons.arrow_drop_down, color: appGreen,),
      value: null,
      hint: Text(label, style:  TextStyle(fontSize: 15, color: Colors.black),),
      style: TextStyle(color: Colors.black),
      items: options.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 15),))).toList(),
      onChanged: (val) {},
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: appGreen),
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );
  }
}