import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.inputType,
    required this.prefixicon,
    required this.hintText,
    required this.validationString,
  });

  final TextEditingController controller;
  final TextInputType inputType;
  final IconData prefixicon;
  final String hintText;
  final String validationString;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: inputType,
      // autofocus: true,
      validator: (val) => val == "" ? validationString : null,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixicon),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
