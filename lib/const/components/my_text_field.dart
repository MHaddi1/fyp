import 'package:flutter/material.dart';
import '../color.dart';

class MyField extends StatelessWidget {
  final String text;
  final String? Function(String?) validate;
  final TextInputType? textInputType;
  final bool obscureText;
  final IconData? iconData;
  final TextEditingController controller;
  final Function()? iconTap;
  final Function(String?)? onChanged;
  final String? initialValue;
  const MyField(
      {super.key,
      required this.controller,
      required this.text,
      required this.validate,
      this.textInputType,
      this.obscureText = false,
      this.iconData,
      this.iconTap,
      this.onChanged,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      controller: controller,
      onTapOutside: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      obscureText: obscureText,
      validator: validate,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        fillColor: textWhite,
        filled: true,
        suffixIcon: iconData != null
            ? IconButton(
                onPressed: iconTap,
                icon: Icon(
                  iconData,
                  color: mainColor,
                ))
            : null,
        border: const OutlineInputBorder(),
        labelText: text,
      ),
    );
  }
}
