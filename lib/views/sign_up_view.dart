import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/controllers/login_controller.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  final SignUpController signUpController = Get.put(SignUpController());
  // @override
  // void initState() {
  //   super.initState();
  //   signUpController.isVerify();
  //   signUpController.mySingUp();
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              20.heightBox,
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyField(
                        onChanged: (value) {
                          signUpController.setEmail(value!);
                        },
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                        text: "email_hint".tr,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Email is required";
                          } else if (!value.isEmail) {
                            return "Enter a valid email address";
                          }
                          return null;
                        }),
                    20.heightBox,
                    Obx(
                      () => MyField(
                          onChanged: (value) {
                            signUpController.setPassword(value!);
                          },
                          iconTap: () => loginController.showPassword(),
                          iconData: loginController.ispassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          obscureText: loginController.ispassword.value,
                          textInputType: TextInputType.emailAddress,
                          controller: _passwordController,
                          text: "password".tr,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "passwrod is required";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            } else if (value !=
                                _confirmPasswordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          }),
                    ),
                    20.heightBox,
                    Obx(
                      () => MyField(
                          iconTap: () => loginController.showPassword(),
                          iconData: loginController.ispassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          obscureText: loginController.ispassword.value,
                          textInputType: TextInputType.emailAddress,
                          controller: _confirmPasswordController,
                          text: "Confirm Password".tr,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "passwrod is required";
                            }
                            return null;
                          }),
                    )
                  ],
                ),
              ),
              30.heightBox,
              MyButton(
                text: "Sign Up",
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    signUpController.mySingUp();
                  }
                },
              )
            ],
          ).scrollVertical(),
        ),
      ),
    );
  }
}
