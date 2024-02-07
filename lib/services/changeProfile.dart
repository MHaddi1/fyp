import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangeProfile {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> checkUserDataExists(User user) async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();

    if (userData.exists) {
      // User data exists, check if phoneNo field exists
      Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
      bool phoneNoExists = data.containsKey('phoneNo');
      if (!phoneNoExists) {
        // PhoneNo field doesn't exist, prompt user to enter phone number
        return false;
      } else {
        // PhoneNo field exists
        return true;
      }
    } else {
      // User data doesn't exist, prompt user to enter phone number
      return false;
    }
  }

  Future changeProfilePhone(String phoneNo) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.email)
          .update({"phoneNo": phoneNo, "type": 2});
    } catch (e) {}
  }

  Future<int?> getType() async {
    try {
      int? currentType;
      String? userEmail = _auth.currentUser?.email;
      if (userEmail != null) {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection("users")
            .doc(userEmail)
            .get();

        if (userSnapshot.exists) {
          currentType = userSnapshot.get('type');
        }
      }
      return currentType;
    } catch (e) {
      // Handle errors
      print("Error getting user type: $e");
      return null;
    }
  }

  Future<void> changeProfileType() async {
    try {
      int? currentType = await getType();
      if (currentType != null) {
        int newType = currentType == 2 ? 1 : 2;
        String? userEmail = _auth.currentUser?.email;
        if (userEmail != null) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userEmail)
              .update({"type": newType});
          print("Profile type changed successfully");
        }
      } else {
        print("Failed to get current user type");
      }
    } catch (e) {
      print("Error changing profile type: $e");
    }
  }

  Future<String?> getImageUrl(String email) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.email)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('image');
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }
}
