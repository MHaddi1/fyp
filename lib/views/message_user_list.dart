import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/services/changeProfile.dart';
import 'package:fyp/views/chat_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageList extends StatefulWidget {
  MessageList({super.key, required this.id});
  final id;
  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  myName(String email) async {
    return await ChangeProfile().getUserName(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.toNamed(RoutesName.homeScreen);
          },
          child: Container(
            decoration: BoxDecoration(
                color: textWhite, borderRadius: BorderRadius.circular(12.0)),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Icon(Icons.arrow_back),
          ),
        ),
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(color: textWhite),
        ),
        backgroundColor: mainColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final List<dynamic> messageUsers = userData['MessageUsers'] ?? [];

          if (messageUsers.isEmpty) {
            return Center(
              child: Text("No Chats Found"),
            );
          }

          return ListView.builder(
            itemCount: messageUsers.length,
            itemBuilder: (context, index) {
              final user =
                  messageUsers[index]['MessageUsers'] as Map<String, dynamic>;
              final String userEmail = user['email'];
              final String userUID = user['UID'];
              final String userImage = userData['image'];
              final String userNameT = user['Name'];
              final Rimage = user["Rimage"];
              final lastMsg = user['Last_message'];

              return GestureDetector(
                onTap: () async {
                  final userName = await ChangeProfile()
                      .getUserName(FirebaseAuth.instance.currentUser!.email);
                  //final myImage = await ChangeProfile().getImageUrl(userEmail);
                  final name = await myName(userEmail);
                  Get.to(() => ChatView(
                        senderName: userName,
                        receiverUser: name,
                        receiverUserEmail: userEmail,
                        receiverUserID: userUID,
                        image: userImage,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                        Rimage.toString(),
                      ),
                    ),
                    title: Text(
                      userNameT.toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      lastMsg, // You can add last message here
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
