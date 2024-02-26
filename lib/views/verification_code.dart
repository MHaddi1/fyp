import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/views/tailors_data_entry.dart';

import 'package:get/get.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key, required this.code});
  final String code;
  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final _codeText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: textWhite,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              MyField(
                controller: _codeText,
                text: "Enter Code",
                validate: (value) => null,
              ),
              SizedBox(
                height: 15.0,
              ),
              MyButton(
                text: "Verify",
                onPressed: () async {
                  try {
                    PhoneAuthCredential phone =
                        await PhoneAuthProvider.credential(
                            verificationId: widget.code,
                            smsCode: _codeText.text.toString());
                    FirebaseAuth.instance.signInWithCredential(phone);
                  } catch (e) {
                    print(e.toString());
                  }
                },
              ),
              Text(
                "Please Do not exist you App",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
