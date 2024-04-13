import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_post.dart';
import 'package:fyp/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final postController = Get.put(HomeController());
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getUser();
    postController.fetchData();
  }

  void getUser() {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      print(currentUser!.uid);
    }
  }

  sendMessage() {
    FirebaseFirestore.instance.collection("admin_Post").add({
      "email": currentUser!.email,
      "message": "This is a new post",
      'TimeStamp': Timestamp.now(),
      "likes": [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("admin_Post")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print("Data: ${snapshot.data}");

                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final myData = snapshot.data!.docs[index];
                        return MyPost(
                          message: myData["message"],
                          user: myData['email'],
                          postId: myData.id,
                          likes: List<String>.from(myData['likes'] ?? []),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(child: const CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
