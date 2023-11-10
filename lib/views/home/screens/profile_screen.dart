import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final pref = UserPreference();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(null),
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          firebaseAuth.currentUser != null &&
                                  firebaseAuth.currentUser!.photoURL != null
                              ? firebaseAuth.currentUser!.photoURL.toString()
                              : "https://yt3.googleusercontent.com/-H4bsnS3lUHCiaDtVcHxm9dJudoCyLdjnBCaIJZSsMJPNqIJFZFqs5iaTx0OjZcxwwCxycfEnA=s900-c-k-c0x00ffffff-no-rj",
                        ),
                      ),
                      //https://picsum.photos/200/300?random=2
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome back!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              firebaseAuth.currentUser != null &&
                                      firebaseAuth.currentUser!.displayName !=
                                          null
                                  ? "Hello, ${firebaseAuth.currentUser!.displayName}!"
                                  : "Hello, Anonymous!",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Email:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              firebaseAuth.currentUser != null &&
                                      firebaseAuth.currentUser!.email != null
                                  ? firebaseAuth.currentUser!.email!
                                  : "Email not found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                350.heightBox,
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {},
                        ),
                      ),
                      "LogOut".text.make()
                    ],
                  ),
                ).onTap(() {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                            title: Text("Log Out"),
                            content: Center(
                              child: CircularProgressIndicator(),
                            ));
                      });
                  pref.clearUserToken();
                  Get.back();
                  Get.offAndToNamed(RoutesName.signScreen);
                }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
