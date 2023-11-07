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
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            firebaseAuth.currentUser != null &&
                                    firebaseAuth.currentUser!.photoURL != null
                                ? firebaseAuth.currentUser!.photoURL.toString()
                                : "https://picsum.photos/200/300?random=2"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      VStack([
                        firebaseAuth.currentUser!.email!.text.makeCentered(),
                        Text(
                          (firebaseAuth.currentUser != null &&
                                  firebaseAuth.currentUser!.displayName != null)
                              ? firebaseAuth.currentUser!.displayName!
                              : "anonymous",
                        )
                      ])
                    ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          pref.clearUserToken().then((value) {
                            Get.offAndToNamed(RoutesName.signScreen);
                          });
                        },
                      ),
                    ),
                    "LogOut".text.make()
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
