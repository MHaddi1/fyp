import 'dart:convert';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/services/changeProfile.dart';
import 'package:fyp/services/chat_services.dart';
import 'package:fyp/services/notification_services.dart';
import 'package:fyp/utils/check_internet_utils.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ChatView extends StatefulWidget {
  final String? receiverUserEmail;
  final String? receiverUserID;
  final String? receiverUser;
  final String? senderName;
  final String image;

  const ChatView(
      {Key? key,
      this.receiverUserEmail,
      this.receiverUserID,
      this.receiverUser,
      this.senderName,
      this.image =
          "https://imgv3.fotor.com/images/blog-richtext-image/10-profile-picture-ideas-to-make-you-stand-out.jpg"})
      : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  final messageController = TextEditingController();
  final chatServices = ChatServices();
  final _fireStore = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  bool delivered = false;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      chatServices.sendMessage(messageController.text, widget.receiverUserID!);
      await updateSenderDocument();
      await updateReceiverDocument();
      deviceTokken();
     setState(() {
       messageController.clear();
     });
    }
  }
  void addToken(String token) async {
    try{
      await _firebaseFirestore.collection("users").doc(FirebaseAuth.instance.currentUser!.email).set({"FCMToken":token},SetOptions(merge: true));
    }catch(e){
      Logger().d(e);
    }
  }

  Future<void> updateSenderDocument() async {
    String userEmail = widget.receiverUserEmail!;
    String userUID = widget.receiverUserID!;
    final userName =
        await ChangeProfile().getUserName(widget.receiverUserEmail);
    final userImage =
        await ChangeProfile().getImageUrl(widget.receiverUserEmail!);

    try {
      final senderSnapshot =
          await _fireStore.doc(FirebaseAuth.instance.currentUser!.email).get();

      if (senderSnapshot.exists) {
        List<dynamic> senderExistingData =
            (senderSnapshot.data() as Map<String, dynamic>)['MessageUsers'] ??
                [];
        List<Map<String, dynamic>> senderList =
            List<Map<String, dynamic>>.from(senderExistingData);

        int index = senderList.indexWhere((element) =>
            element['MessageUsers']['email'] == userEmail &&
            element['MessageUsers']['UID'] == userUID);

        if (index != -1) {
          // Combination exists, update last message
          senderList[index]['MessageUsers']['Last_message'] =
              messageController.text;
        } else {
          // Combination doesn't exist, add new entry
          senderList.add({
            "MessageUsers": {
              "email": userEmail,
              "UID": userUID,
              "Name": userName, // Add sender's name
              "Rimage": userImage,
              "Last_message": messageController.text
            }
          });
        }

        // Update sender's Firestore document
        await _fireStore
            .doc(FirebaseAuth.instance.currentUser!.email)
            .set({"MessageUsers": senderList}, SetOptions(merge: true));

        print('Sender document updated successfully');
      } else {
        print('Sender document does not exist');
      }
    } catch (error) {
      print('Error updating sender document: $error');
    }
  }

  Future<void> updateReceiverDocument() async {
    final senderName = await ChangeProfile()
        .getUserName(FirebaseAuth.instance.currentUser!.email);
    final userSimage =
        await ChangeProfile().getImageUrl(widget.receiverUserEmail!);

    try {
      final receiverSnapshot =
          await _fireStore.doc(widget.receiverUserEmail).get();

      if (receiverSnapshot.exists) {
        List<dynamic> receiverExistingData =
            (receiverSnapshot.data() as Map<String, dynamic>)['MessageUsers'] ??
                [];
        List<Map<String, dynamic>> receiverList =
            List<Map<String, dynamic>>.from(receiverExistingData);

        int index = receiverList.indexWhere((element) =>
            element['MessageUsers']['email'] ==
                FirebaseAuth.instance.currentUser!.email &&
            element['MessageUsers']['UID'] ==
                FirebaseAuth.instance.currentUser!.uid);

        if (index != -1) {
          // Combination exists, update last message
          receiverList[index]['MessageUsers']['Last_message'] =
              messageController.text;
        } else {
          // Combination doesn't exist, add new entry
          receiverList.add({
            "MessageUsers": {
              "email": FirebaseAuth.instance.currentUser!.email,
              "UID": FirebaseAuth.instance.currentUser!.uid,
              "Name": senderName,
              "Rimage": userSimage,
              "Last_message": messageController.text
            }
          });
        }

        // Update receiver's Firestore document
        await _fireStore
            .doc(widget.receiverUserEmail)
            .set({"MessageUsers": receiverList}, SetOptions(merge: true));

        print('Receiver document updated successfully');
      } else {
        print('Receiver document does not exist');
      }
    } catch (error) {
      print('Error updating receiver document: $error');
    }
  }

  sendToken(String value) async {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({"FCMToken": value}, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  getToken(String email) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(email).get();

      if (userSnapshot.exists) {
        return userSnapshot.get('FCMToken');
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }

  void sendNotification(String deviceToken, String message) async {
    final RToken = await getToken(widget.receiverUserEmail.toString());
    var data = {
      "to": RToken == null ? deviceToken : RToken,
      "priority": "high",
      'notification': {
        "title": RToken == null ? "You send Message" : " New Message",
        "body": message,
      },
      "data": {'type': "chat", "id": "123456"}
    };

    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "Authorization":
                "key=AAAANFZ7kDQ:APA91bFzd7VOzBXrRAd7B6l2PN5UEZv1NtXQR3QUqed2M32zYf4mLyppR5P9dzg9nid8pOGhKeVIsunwtJUDkye13ow4zQu8abSNdgYb_Ah29UVxZxPK5La37oQNF-226d8nmCDSL6Y3"
          },
          body: jsonEncode(data));
    } catch (error) {
      print("Error sending notification: $error");
    }
  }

  void deviceTokken() async {
    await MessageNotification.instance.getMessageTokken().then((value) async {
      final checkToken =
          await getToken(FirebaseAuth.instance.currentUser!.email.toString());
      if (checkToken == value) {
        sendNotification(value, messageController.text);
      } else {
        sendToken(value);
      }
    });
  }

  internetCheck() async {
    delivered = await ConnectivityUtil.instance.checkInternetConnection();
    return delivered;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // final email = await myCollection();
    if (state == AppLifecycleState.resumed) {
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }

  void setStatus(String status) async {
    try {
      _firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .set({"status": status}, SetOptions(merge: true));
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    MessageNotification.instance.getMessageTokken().then((value) {
      addToken(value);
    });
    internetCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
                color: textWhite, borderRadius: BorderRadius.circular(12.0)),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            //padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Icon(Icons.arrow_back),
          ),
        ),
        title: StreamBuilder<DocumentSnapshot>(
            stream: _firebaseFirestore
                .collection('users')
                .doc(widget.receiverUserEmail)
                .snapshots(),
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Text(snapshot.data?['status'] == null
                        ? "Offline"
                        : snapshot.data!['status']),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                ],
              );
            }),
        backgroundColor: mainColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatServices.getMessage(
        widget.receiverUserID!,
        _auth.currentUser!.uid,
      ),
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
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final document = snapshot.data!.docs[index];
            return _buildMessageItem(document);
          },
        );
      }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    final isSender = data["senderId"] == _auth.currentUser!.uid;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isSender)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.receiverUser!,
                style: TextStyle(fontWeight: FontWeight.bold, color: mainBack),
              ),
            ),
          SizedBox(
            width: 5.0,
          ),
          BubbleNormal(
            text: data['message'],
            textStyle: TextStyle(color: Colors.white),
            isSender: isSender,
            color: isSender ? Colors.blue : Colors.grey[300]!,
            tail: true,
            sent: delivered ? true : false,
            delivered: delivered ? true : false,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: sendMessage,
              color: mainColor,
            ),
          ],
        ),
      ),
    );
  }
}
