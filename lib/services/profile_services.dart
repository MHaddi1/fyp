import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/models/get_user_model.dart';

class ProfileServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<GetUserModel>> displayUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore.collection("users").get();

      List<GetUserModel> posts = querySnapshot.docs
          .map((doc) => GetUserModel.fromJson(doc.data()))
          .toList();
      return posts;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
