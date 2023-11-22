import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/models/message.dart';

class ChatServices {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Future<void> sendMessage(String message, String rUID) async {
    final String currentUserUID = _auth.currentUser!.uid;
    final String currentUser = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    final newMessage = MessageModel(
      senderId: currentUserUID,
      receiverId: rUID,
      timestamp: timestamp,
      message: message,
      senderEmail: currentUser,
    );

    List<String> ids = [currentUserUID, rUID];
    ids.sort();
    String chatRoomId = ids.join('_');

    await _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
    return _firestore
        .collection("chat_room")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
