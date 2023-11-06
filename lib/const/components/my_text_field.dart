import 'package:flutter/material.dart';

class MyField extends StatelessWidget {
  final String text;
  final String? Function(String?) validate;
  final TextInputType? textInputType;
  final bool obscureText;
  const MyField(
      {super.key,
      required this.text,
      required this.validate,
      this.textInputType,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      obscureText: obscureText,
      validator: validate,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: text,
      ),
    );
  }
}
