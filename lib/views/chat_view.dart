import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/services/chat_services.dart';

class ChatView extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatView({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final messageContrller = TextEditingController();
  final chatServices = ChatServices();
  final _fireStore = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
  Map<String, dynamic>? msgData;

  sendMessage() {
    if (messageContrller.text.isNotEmpty) {
      chatServices.sendMessage(messageContrller.text, widget.receiverUserID);
      messageContrller.clear();

      String userEmail = widget.receiverUserEmail;
      String userUID = widget.receiverUserID;

      _fireStore
          .where('Tailors_Email', isEqualTo: userEmail)
          .where('Tailors_UID', isEqualTo: userUID)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          print('Document with the same email and UID already exists');
        } else {
          try {
            Map<String, dynamic> msgData = {
              "Tailors_Email": widget.receiverUserEmail,
              "Tailors_UID": widget.receiverUserID,
            };
            List<Map<String, dynamic>> listOfMaps = [];

            _fireStore
                .doc(FirebaseAuth.instance.currentUser!.email)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                List<dynamic> existingData = (documentSnapshot.data()
                        as Map<String, dynamic>)['MessageUsers'] ??
                    [];

                listOfMaps
                    .addAll(List<Map<String, dynamic>>.from(existingData));

                bool combinationExists = listOfMaps.any((element) =>
                    element['MessageUsers']['Tailors_Email'] == userEmail &&
                    element['MessageUsers']['Tailors_UID'] == userUID);

                // If the combination doesn't exist, add it to the list
                if (!combinationExists) {
                  listOfMaps.add({"MessageUsers": msgData});
                }
              } else {
                // If no existing data, simply add the new user data to the list
                listOfMaps.add({"MessageUsers": msgData});
              }

              // Update Firestore with the updated list
              _fireStore
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .set({"MessageUsers": listOfMaps}, SetOptions(merge: true));
            }).catchError((error) {
              print('Error retrieving existing data: $error');
            });
          } catch (e) {
            print('Error adding data to Firestore: $e');
          }
        }
      }).catchError((error) {
        print('Error checking document existence: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatServices.getMessage(
          widget.receiverUserID, _auth.currentUser!.uid),
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
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      }),
    );
  }

  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    var alignment = (data["senderId"] == _auth.currentUser!.uid)
        ? Alignment.centerLeft
        : Alignment.centerRight;
    return Container(
      margin: const EdgeInsets.all(8.0),
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data["senderId"] == _auth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(data['senderEmail']),
          BubbleNormal(
            text: data['message'],
            textStyle: const TextStyle(color: Colors.white),
            isSender: true,
            color: Colors.blue,
            tail: true,
            sent: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: TextField(
              controller: messageContrller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your message",
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: sendMessage,
        ),
      ],
    );
  }
}
