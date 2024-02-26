import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/profile_card.dart';
import 'package:fyp/views/tailors_profile.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection("users");
  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SearchBar(
                  hintText: "Search",
                  leading: Icon(
                    Icons.search,
                  ),
                  onChanged: (value) {
                    setState(() {
                      search = value;
                      // print(search);
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
                          List<dynamic>? starList = userData['star'];
                          int starListLength = starList?.length ?? 0;
                          double num = 0.0;
                          for (int i = 0; i < starListLength; i++) {
                            double value = double.tryParse(starList![i]) ??
                                0.0; // Use 0.0 if parsing fails
                            num += value;
                          }

                          var average =
                              starListLength > 0 ? num / starListLength : 0.0;

                          // if (search.isEmpty) {
                          return ProfileCard(
                            image: userData['image'] == null
                                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_2RVIZc1ppKuC-d8egbHChBoGMCcEjVe-K7GNmBjvsSdrKyXibk-ao7jJArJHoqU3xHc&usqp=CAU"
                                : userData['image'].toString(),
                            desctiption: starListLength.toString(),
                            avg: average.floorToDouble(),
                            name: userData['name'].toString().capitalized,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TailorsProfile(
                                            email: userData['email'],
                                            uid: userData['uid'],
                                            name: userData['name'],
                                            description: userData['bio'],
                                            star: starListLength,
                                            image: userData['image'] == null
                                                ? "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?w=740&t=st=1706427756~exp=1706428356~hmac=3d3a5aa4798754cc09aafb2fcf7a1b246824aa67b35ba49b5e4e7d5614b54b0b"
                                                : userData['image'],
                                            avg: average.floorToDouble(),
                                          )));
                            },
                          );
                          // } else if (userData['name']
                          //     .toString()
                          //     .toLowerCase()
                          //     .startsWith(search)) {
                          //   return ProfileCard(
                          //     image: userData['image'] == null
                          //         ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_2RVIZc1ppKuC-d8egbHChBoGMCcEjVe-K7GNmBjvsSdrKyXibk-ao7jJArJHoqU3xHc&usqp=CAU"
                          //         : userData['image'].toString(),
                          //     desctiption: userData['bio'].toString(),
                          //     name: userData['name'].toString(),
                          //     onPressed: () {},
                          //   );
                          // }
                          // return Container();
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
    );
  }
}
