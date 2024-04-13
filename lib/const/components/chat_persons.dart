import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/components/chat_simple.dart';
import 'package:fyp/views/chat_view.dart';
import 'package:get/get.dart';

class ChatPerson extends StatefulWidget {
  const ChatPerson({Key? key});

  @override
  State<ChatPerson> createState() => _ChatPersonState();
}

class _ChatPersonState extends State<ChatPerson> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.grey[200],
        body: _buildUserList());
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
              children: snapshot.data!.docs
                  .map<Widget>((doc) => _buildUserListItem(doc))
                  .toList());
        }));
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    int type = data['type'] ?? 0;
    if (_auth.currentUser!.email != data['email'] && type == 3) {
      return ChatSimple(
        username: data['name'],
        onPressed: () {
          Get.to(() => ChatView(
                receiverUser: data['name'],
                receiverUserEmail: data['email'],
                receiverUserID: data['uid'],
              ));
        },
      );
    }
    return Container();
  }
}
