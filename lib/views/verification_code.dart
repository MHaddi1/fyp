import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'dart:async';

import 'package:fyp/services/changeProfile.dart';
import 'package:lottie/lottie.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode(
      {Key? key,
      required this.code,
      required this.reCode,
      required this.phoneNumber})
      : super(key: key);
  final String code;
  final dynamic reCode;
  final dynamic phoneNumber;

  @override
  State<VerificationCode> createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final _codeText = TextEditingController();
  late Timer _timer;
  int _secondsRemaining = 90;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        if (_secondsRemaining == 0) {
          timer.cancel();
        } else {
          setState(() {
            _secondsRemaining--;
          });
        }
      },
    );
  }

  void resendCode() {
    // Reset the timer
    _secondsRemaining = 90;
    startTimer();
    ChangeProfile().sendVerificationCode(widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: textWhite,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LottieBuilder.asset(
                "assets/image/code.json",
                width: media.width * 0.2,
              ),
              SizedBox(
                height: media.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Verification Code",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MyField(
                controller: _codeText,
                text: "Enter Code",
                validate: (value) => null,
              ),
              SizedBox(height: 15.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                    text: "Verify ($_secondsRemaining)",
                    onPressed: (_secondsRemaining > 0)
                        ? null
                        : () async {
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
                  TextButton(
                    onPressed: (_secondsRemaining > 0)
                        ? null
                        : () {
                            // Implement resend code functionality
                            resendCode();
                          },
                    child: Text(
                      "Resend Code",
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Text(
                "Please do not exit your app.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
