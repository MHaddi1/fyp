import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/profile_card.dart';
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

                          double average =
                              starListLength > 0 ? num / starListLength : 0.0;

                          // if (search.isEmpty) {
                          return ProfileCard(
                            image: userData['image'] == null
                                ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_2RVIZc1ppKuC-d8egbHChBoGMCcEjVe-K7GNmBjvsSdrKyXibk-ao7jJArJHoqU3xHc&usqp=CAU"
                                : userData['image'].toString(),
                            desctiption: starListLength.toString(),
                            avg: average.floorToDouble(),
                            name: userData['name'].toString().capitalized,
                            onPressed: () {},
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
