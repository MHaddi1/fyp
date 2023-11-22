import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? loggedInUser;
  Stream<QuerySnapshot> getMessages() {
    return _firestore.collection('messages').snapshots();
  }

  void sendMessage(String messageText) {
    _firestore.collection('messages').add({
      'text': messageText,
      'sender': loggedInUser!.email,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
