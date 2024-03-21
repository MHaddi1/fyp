import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/list_title.dart';
import 'package:fyp/const/components/profile_card.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/views/tailors_profile.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../const/components/drawer.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection("users");
  String search = '';
  String stars = "4";
  @override
  void dispose() {
    print("Hello");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        print(didPop);
        if (didPop) {
          //await Get.to(() => SearchScreen());
        } else {
          await Get.toNamed(RoutesName.homeScreen);
        }
      },
      child: Scaffold(
        // drawer: MyDrawer(),
        // appBar: AppBar(),
        backgroundColor: mainBack,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SearchBar(
                    trailing: [
                      GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print("Working...");
                          }
                          Get.bottomSheet(
                            backgroundColor: textWhite,
                            Container(
                              width: Get.width,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.05,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    height: 10,
                                    width: Get.width * 0.5,
                                    decoration: BoxDecoration(
                                        color: mainBack,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  MyListTitle(
                                      color: mainBack,
                                      icon: Icons.star,
                                      text: "Filter By Star",
                                      onPressed: () {
                                        showOptions(context);
                                      })
                                ],
                              ),
                            ),
                          );
                        },
                        child:
                            Icon(IconData(0xe280, fontFamily: 'MaterialIcons')),
                      )
                    ],
                    hintText: "Search",
                    leading: Icon(
                      Icons.search,
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: userCollection
                        .where("type", isEqualTo: 2)
                        .where('name', isGreaterThanOrEqualTo: search)
                        .where('name', isLessThan: search + 'z')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final userData = snapshot.data!.docs[index];
                            List<dynamic>? starList = userData['star'] ?? [];
                            int starListLength = starList!.length;
                            double num = 0.0;
                            for (int i = 0; i < starListLength; i++) {
                              double value =
                                  double.tryParse(starList[i]) ?? 0.0;
                              num += value;
                            }

                            var average =
                                starListLength > 0 ? num / starListLength : 0.0;

                            return userData['email'].toString() !=
                                    FirebaseAuth.instance.currentUser!.email
                                ? ProfileCard(
                                    image: userData['image'] == null
                                        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_2RVIZc1ppKuC-d8egbHChBoGMCcEjVe-K7GNmBjvsSdrKyXibk-ao7jJArJHoqU3xHc&usqp=CAU"
                                        : userData['image']?.toString() ?? '',
                                    description: starListLength.toString(),
                                    avg: average.floorToDouble(),
                                    name: userData['name']
                                            ?.toString()
                                            .capitalized ??
                                        '',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TailorsProfile(
                                            rating: 1,
                                            onRatingChanged: (value) {},
                                            email:
                                                userData['email']?.toString(),
                                            uid: userData['uid']?.toString(),
                                            name: userData['name']!.toString(),
                                            description:
                                                userData['bio']!.toString(),
                                            star: starListLength,
                                            image: userData['image'] == null
                                                ? "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1706427756~exp=1706428356~hmac=3d3a5aa4798754cc09aafb2fcf7a1b246824aa67b35ba49b5e4e7d5614b54b0b"
                                                : userData['image']
                                                        ?.toString() ??
                                                    '',
                                            avg: average.floorToDouble(),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container();
                          },
                        );
                      } else if (snapshot.hasError) {
                        print("error: ${snapshot.error}");
                        return Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: textWhite),
                        );
                      } else {
                        return Center(child: const CircularProgressIndicator());
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Option 1'),
              onTap: () {
                setState(() {
                  stars = "5.0";
                });
              },
            ),
            ListTile(
              title: Text('Option 2'),
              onTap: () {
                setState(() {
                  stars = "4.0";
                });
                // Handle Option 2
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            // Add more options as needed
          ],
        );
      },
    );
  }
}
