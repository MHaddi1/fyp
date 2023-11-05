import 'package:flutter/material.dart';
import 'package:fyp/const/components/login/bottom_sheet.dart';

class SignView extends StatelessWidget {
  const SignView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      body: MyBottomLoginSheet(),
    );
  }
}
