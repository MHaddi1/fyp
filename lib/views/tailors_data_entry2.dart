import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TailorsDataEntry2 extends StatefulWidget {
  const TailorsDataEntry2({Key? key}) : super(key: key);

  @override
  _TailorsDataEntry2State createState() => _TailorsDataEntry2State();
}

class _TailorsDataEntry2State extends State<TailorsDataEntry2> {
  Map<String, dynamic> description = {
    "MyDescriptions": "",
  };
  bool _validateDescription() {
    for (var value in description.values) {
      if (value.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Tailor Services Data Entry',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: description.entries.map((entry) {
                      String key = entry.key;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            key,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: mainColor,
                            ),
                          ),
                          SizedBox(height: 10),
                          DescriptionField(
                            onChanged: (value) {
                              setState(() {
                                description[key] = value;
                              });
                            },
                            hintText: "Enter the description of $key",
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              MyButton(
                text: "Submit",
                onPressed: () async {
                  if (_validateDescription()) {
                    EasyLoading.show(
                      dismissOnTap: true,
                      status: "Data In Process",
                      indicator: CircularProgressIndicator(),
                      maskType: EasyLoadingMaskType.black,
                    );
                    Map<String, dynamic> userData = {
                      "description": description
                    };
                    await FirebaseFirestore.instance
                        .collection("Tailor_Services")
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .set(userData, SetOptions(merge: true));
                    EasyLoading.dismiss();
                    Get.toNamed(RoutesName.homeScreen);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill description fields.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DescriptionField extends StatelessWidget {
  const DescriptionField(
      {Key? key, required this.onChanged, required this.hintText})
      : super(key: key);
  final Function(String) onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: TextField(
        onChanged: onChanged,
        maxLines: 4,
        maxLength: 500,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
