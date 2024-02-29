import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/models/get_user_model.dart';

class ProfileServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<GetUserModel>> displayUser() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null || currentUser.email == null) {
        return [];
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore
              .collection("users")
              .where("email", isEqualTo: currentUser.email)
              .get();

      List<GetUserModel> users = querySnapshot.docs
          .map((doc) => GetUserModel.fromJson(doc.data()))
          .toList();

      return users;
    } catch (e) {
      print("Error fetching user profile: $e");
      rethrow;
    }
  }
}

