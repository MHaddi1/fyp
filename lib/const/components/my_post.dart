import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/like_button.dart';

class MyPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const MyPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  });

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference reference =
        FirebaseFirestore.instance.collection("admin_Post").doc(widget.postId);
    if (isLiked) {
      reference.update({
        "likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      reference.update({
        "likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: postBlock, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          20.widthBox,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.user,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: textWhite),
                    )),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: textWhite),
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            MyLikeButton(isLiked: isLiked, onTap: toggleLike),
                            5.heightBox,
                            Text(
                              widget.likes.length.toString(),
                              style: const TextStyle(
                                  color: textWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    // Align(
                    //     alignment: Alignment.topLeft,
                    //     child: Column(
                    //       children: [
                    //         MyLikeButton(isLiked: isLiked, onTap: toggleLike),
                    //         5.heightBox,
                    //         Text(
                    //           widget.likes.length.toString(),
                    //           style: const TextStyle(
                    //               color: textWhite,
                    //               fontWeight: FontWeight.bold),
                    //         ),
                    //       ],
                    //     )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  Share.share(
                                      "${widget.user}\n${widget.message}");
                                },
                                icon: Icon(
                                  Icons.share_rounded,
                                  color: textWhite,
                                )),
                            5.heightBox,
                            // Text(
                            //   widget.likes.length.toString(),
                            //   style: const TextStyle(
                            //       color: textWhite,
                            //       fontWeight: FontWeight.bold),
                            // ),
                          ],
                        )),
                  ],
                ),
                //count Likes
              ],
            ),
          ),
        ],
      ),
    );
  }
}
