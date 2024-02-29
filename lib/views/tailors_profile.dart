import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/services/changeProfile.dart';

import 'chat_view.dart';

class TailorsProfile extends StatefulWidget {
  const TailorsProfile(
      {super.key,
      this.image = "",
      this.description = "",
      this.name = "",
      this.star = 0,
      this.avg = 0.0,
      this.email,
      this.uid,
      this.onRatingChanged,
      this.rating = 1});

  final String name;
  final String description;
  final int star;
  final String image;
  final double avg;
  final String? uid;
  final String? email;
  final int? rating;
  final void Function(int)? onRatingChanged;

  @override
  State<TailorsProfile> createState() => _TailorsProfileState();
}

class _TailorsProfileState extends State<TailorsProfile> {
  late RatingController ratingController;
  @override
  void initState() {
    super.initState();
    ratingController = Get.put(RatingController());
    ratingController.rating.value = widget.rating!;
  }

  @override
  Widget build(BuildContext context) {
    print("name: ${widget.name}");
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: mainBack,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: mainBack,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(widget.image),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'username',
                        style: TextStyle(color: textWhite),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                                color: textWhite,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      Text(
                        "Total Rating: ${widget.star.toString()} ⭐",
                        style: TextStyle(color: textWhite, fontSize: 25),
                      ),
                      Text(
                        "⭐ ${widget.avg}",
                        style: TextStyle(fontSize: 25.0, color: textWhite),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Obx(() => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < ratingController.rating.value
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    ratingController.updateRating(
                                        index, widget.email!, context);
                                    widget.onRatingChanged!(
                                        ratingController.rating.value);
                                  });
                                },
                              );
                            }),
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description:",
                                style:
                                    TextStyle(color: textWhite, fontSize: 30.0),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                widget.description,
                                style:
                                    TextStyle(color: textWhite, fontSize: 17.0),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: Get.width,
                  child: TabBarView(
                    children: [
                      Container(
                        color: mainBack,
                        child: Center(
                          child: Text(
                            'Page 1',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        color: mainBack,
                        child: Center(
                          child: Text(
                            'Page 2',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        color: mainBack,
                        child: Center(
                          child: Text(
                            'Page 3',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Container(
          width: 120,
          height: 70,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          decoration: BoxDecoration(
              color: textWhite, borderRadius: BorderRadius.circular(20.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: () async {
                  final userName = await ChangeProfile()
                      .getUserName(FirebaseAuth.instance.currentUser!.email);
                  print(userName);
                  Get.to(() => ChatView(
                        receiverUser: widget.name,
                        receiverUserEmail: widget.email!,
                        receiverUserID: widget.uid!,
                        senderName: userName,
                      ));
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.image),
                ),
              ),
              Text("Chat")
            ],
          ),
        ),
      ),
    );
  }
}

class RatingController extends GetxController {
  RxInt rating = 1.obs;

  Future<void> updateRating(int index, String email, context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case where the user is not logged in
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection("users").doc(email);
    final userData = await userDoc.get();
    final List<dynamic>? previousRatings = userData.data()?["ratings"];

    if (previousRatings != null && previousRatings.contains(currentUser.uid)) {
      // User has already rated this tailor
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Already Rated"),
            content: Text("You have already rated this tailor."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    rating.value = index + 1;
    await userDoc.set(
      {
        "ratings": FieldValue.arrayUnion([currentUser.uid]),
        "star": FieldValue.arrayUnion([rating.value.toString()])
      },
      SetOptions(merge: true),
    );
  }
}
