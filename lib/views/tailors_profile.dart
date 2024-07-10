import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/views/tailor_services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../const/color.dart';
import '../services/changeProfile.dart';
import 'chat_view.dart';

class TailorsProfile extends StatefulWidget {
  const TailorsProfile({
    Key? key,
    this.image = "",
    this.description = "",
    this.name = "",
    this.star = 0,
    this.avg = "0.0",
    this.email,
    this.uid,
    this.onRatingChanged,
    this.rating = 1,
  }) : super(key: key);

  final String name;
  final String description;
  final int star;
  final String image;
  final String avg;
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
  final changeProfile = ChangeProfile();
  int typeCheck = 1;

  @override
  void initState() {
    super.initState();
    ratingController = Get.put(RatingController());
    ratingController.rating.value = widget.rating!;
    userType();
  }

  userType() async {
    try {
      var myType = await changeProfile.getType();
      print('Retrieved type: $myType'); // Debugging line
      if (mounted) {
        setState(() {
          typeCheck = myType ?? 1;
          print('Updated typeCheck: $typeCheck'); // Debugging line
        });
      }
    } catch (e) {
      print('Error retrieving type: $e'); // Debugging line
    }
  }

  @override
  Widget build(BuildContext context) {
    userType();
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
              style: GoogleFonts.poppins(
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
                  style: GoogleFonts.poppins(color: Colors.blue, fontSize: 16),
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
                      if (mounted) {
                        setState(() {
                          ratingController.updateRating(
                            index,
                            widget.email!,
                            context,
                          );
                          widget
                              .onRatingChanged!(ratingController.rating.value);
                        });
                      }
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
                  style: GoogleFonts.poppins(color: textWhite, fontSize: 20),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 90.0,
                  child: Text(
                    "⭐ ${widget.avg}",
                    style: GoogleFonts.poppins(fontSize: 20, color: textWhite),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Description",
                style: GoogleFonts.poppins(color: textWhite, fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.description,
                style: GoogleFonts.poppins(color: textWhite, fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // if (typeCheck == 1) {
                //   FirebaseFirestore.instance
                //       .collection('Tailor_Services')
                //       .doc(widget.email)
                //       .get()
                //       .then(
                //     (doc) {
                //       if (doc.exists) {
                //         Get.to(() => TailorServices(
                //               email: widget.email,
                //             ));
                //       } else {
                //         showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               title: Text("Services Not Available"),
                //               content: Text(
                //                   "Tailor services are not available for this profile."),
                //               actions: <Widget>[
                //                 TextButton(
                //                   onPressed: () {
                //                     Navigator.of(context).pop();
                //                   },
                //                   child: Text("OK"),
                //                 ),
                //               ],
                //             );
                //           },
                //         );
                //       }
                //     },
                //   );
                // } else if (typeCheck == 2) {
                //   showDialog(
                //     context: context,
                //     builder: (_) {
                //       return AlertDialog(
                //         title: Text("Change Your Profile to Customer"),
                //         content: Container(
                //           height: Get.height * 0.15,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.end,
                //             children: [
                //               Expanded(
                //                 child: Row(
                //                   children: [
                //                     Text("Change Profile"),
                //                     SizedBox(width: 15.0),
                //                     Obx(
                //                       () => Switch(
                //                         value: ratingController.getType.value,
                //                         onChanged: (value) async {
                //                           ratingController.changeType = value;
                //                           if (value) {
                //                             confirmChange();
                //                             Get.back();
                //                           } else {
                //                             confirmChange();
                //                             Get.back();
                //                           }
                //                         },
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   );
                // }
                print("typeCheck ");
                print(typeCheck);
                if (typeCheck == 1) {
                  FirebaseFirestore.instance
                      .collection('Tailor_Services')
                      .doc(widget.email)
                      .get()
                      .then((doc) {
                    if (doc.exists) {
                      Get.to(() => TailorServices(email: widget.email));
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
                } else if (typeCheck == 2) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text("Change Your Profile to Customer"),
                        content: Container(
                          height: Get.height * 0.15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Text("Change Profile"),
                                    SizedBox(width: 15.0),
                                    Obx(
                                      () => Switch(
                                        value: ratingController.getType.value,
                                        onChanged: (value) async {
                                          ratingController.changeType = value;
                                          confirmChange();
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
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
                style: GoogleFonts.poppins(
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

  Future<void> confirmChange() async {
    EasyLoading.show(
      dismissOnTap: true,
      status: "Profile change",
      indicator: CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.black,
    );
    int? userType = await changeProfile.getType();
    if (userType == 2 || userType == 1) {
      changeProfile.changeProfileType();
    }
    EasyLoading.dismiss();
  }
}

class RatingController extends GetxController {
  RxInt rating = 1.obs;
  RxBool _change = false.obs;

  set changeType(bool value) {
    _change.value = value;
  }

  get getType => _change;

  Future<void> updateRating(
      int index, String email, BuildContext context) async {
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

    rating.value = index + 1;
    List<dynamic> stars = userData.data()?["star"] ?? [];

    stars.add(rating.value.toDouble());
    double sumStar = stars
        .map((star) => (star is String ? double.parse(star) : star) as double)
        .reduce((a, b) => a + b);
    double avg = sumStar / stars.length;

    await userDoc.set({
      "ratings": FieldValue.arrayUnion([currentUser.uid]),
      "star": stars,
      "totalRating": sumStar,
      "avg": avg,
    }, SetOptions(merge: true));
  }
}
