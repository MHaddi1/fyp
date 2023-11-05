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
    return Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          )),
      height: 50,
      child: TextFormField(
        obscureText: obscureText,
        validator: validate,
        keyboardType: textInputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: text,
        ),
      ),
    );
  }
}
