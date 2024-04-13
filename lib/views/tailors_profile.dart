import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/views/tailor_services.dart';
import 'package:get/get.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/services/changeProfile.dart';
import 'chat_view.dart';

class TailorsProfile extends StatefulWidget {
  const TailorsProfile({
    Key? key,
    this.image = "",
    this.description = "",
    this.name = "",
    this.star = 0,
    this.avg = 0.0,
    this.email,
    this.uid,
    this.onRatingChanged,
    this.rating = 1,
  }) : super(key: key);

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

class _TailorsProfileState extends State<TailorsProfile>
    with SingleTickerProviderStateMixin {
  late RatingController ratingController;

  @override
  void initState() {
    super.initState();
    ratingController = Get.put(RatingController());
    ratingController.rating.value = widget.rating!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back, color: textWhite),
                  ),
                  IconButton(
                    onPressed: () {
                      // Implement action for another icon
                    },
                    icon: Icon(Icons.more_vert, color: textWhite),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 100,
              backgroundImage: CachedNetworkImageProvider(widget.image),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textWhite,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.verified, color: Colors.blue),
                SizedBox(width: 5),
                Text(
                  "Verified",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < ratingController.rating.value
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow,
                    ),
                    onPressed: () {
                      setState(() {
                        ratingController.updateRating(
                          index,
                          widget.email!,
                          context,
                        );
                        widget.onRatingChanged!(ratingController.rating.value);
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Rating: ${widget.star.toString()} ⭐",
                  style: TextStyle(color: textWhite, fontSize: 20),
                ),
                SizedBox(width: 10),
                Text(
                  "⭐ ${widget.avg}",
                  style: TextStyle(fontSize: 20, color: textWhite),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Description",
                style: TextStyle(color: textWhite, fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.description,
                style: TextStyle(color: textWhite, fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Tailor_Services')
                    .doc(widget.email)
                    .get()
                    .then((doc) {
                  if (doc.exists) {
                    Get.to(() => TailorServices(
                          email: widget.email,
                        ));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Services Not Available"),
                          content: Text(
                              "Tailor services are not available for this profile."),
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
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Check Out Services',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton.extended(
              onPressed: () async {
                final userName = await ChangeProfile().getUserName(
                  FirebaseAuth.instance.currentUser!.email,
                );
                Get.to(
                  () => ChatView(
                    receiverUser: widget.name,
                    receiverUserEmail: widget.email!,
                    receiverUserID: widget.uid!,
                    senderName: userName,
                  ),
                );
              },
              icon: Icon(Icons.chat),
              label: Text("Chat"),
              backgroundColor: textWhite,
              foregroundColor: mainBack,
            ),
            SizedBox(height: 20),
          ],
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
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection("users").doc(email);
    final userData = await userDoc.get();
    final List<dynamic>? previousRatings = userData.data()?["ratings"];

    if (previousRatings != null && previousRatings.contains(currentUser.uid)) {
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
    final starsData = await userDoc.get();

    double sumStar = 0;

    List<dynamic>? stars = starsData.data()?["star"];
    int Slength = stars!.length;
    for (var star in stars) {
      var value = double.parse(star);
      sumStar += value;
      await userDoc.set(
        {"totalRating": sumStar.toString()},
        SetOptions(merge: true),
      );
    }

    final avgData = await userDoc.get();
    String t = avgData.data()?['totalRating'];
    String total = t;
    final avg = double.parse(total) / Slength;

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set({
      "avg": avg.toString(),
    }, SetOptions(merge: true));

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
