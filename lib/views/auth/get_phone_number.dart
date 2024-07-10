// lib/screens/get_number_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/color.dart';
import '../../const/routes/routes_name.dart';
import '../../controllers/sign_up_controller.dart';

class GetNumberScreen extends StatefulWidget {
  @override
  State<GetNumberScreen> createState() => _GetNumberScreenState();
}

class _GetNumberScreenState extends State<GetNumberScreen> {
  final TextEditingController numberController = TextEditingController();

  final SignUpController signUpController = Get.put(SignUpController());

  final signUpServices = SignUpServices();

  @override
  void initState() {
    signUpServices.currentCity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Number',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Icon(
                  Icons.phone_android,
                  size: 100,
                  color: Colors.deepPurple,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: numberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter your number',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                  ),
                  style: GoogleFonts.lato(),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                String number = numberController.text;
                if (number.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .update({"phoneNo": number});

                  signUpController.mySignUp(type: Get.arguments);
                  //Get.toNamed(RoutesName.signScreen);
                } else {
                  Get.snackbar('Error', 'Please enter a number');
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                primary: mainColor,
                onPrimary: textWhite,
                textStyle: GoogleFonts.lato(fontSize: 18),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
