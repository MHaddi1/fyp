import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/services/SharedPrefernece/state_save.dart';
import 'package:fyp/views/verification_code.dart';
import 'package:get/get.dart';

class ChangeProfile {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String vrID = "";

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      await sendVerificationCode(phoneNo);
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

  getUserName(String? email) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (userSnapshot.exists) {
        return userSnapshot.get('name');
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (e) {
      print('Error fetching image URL: $e');
      return null;
    }
  }

  Future<String?> getImageUrl(String email) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(email).get();

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

  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 90),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == "Invalid-phone-number") {
            print("Phone number is invalid");
          } else
            print('Phone verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Verification code sent to $phoneNumber');
          this.vrID = verificationId;
          StateSave().saveState();
          Get.to(() => VerificationCode(
                reCode: resendToken!,
                code: verificationId,
                phoneNumber: phoneNumber,
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto-retrieval timeout');
          this.vrID = verificationId;
        },
      );
    } catch (e) {
      // Handle errors
      print('Error sending verification code: $e');
    }
  }

  Future<bool> verifyOTP(String otp) async {
    try {
      var credential = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: vrID.toString(), smsCode: otp));
      return credential.user != null ? true : false;
    } catch (e) {
      return false;
    }
  }

  Future<int> getMessageUsersLength() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      final userData = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> messageUsers = userData['MessageUsers'] ?? [];
      return messageUsers.length;
    } catch (e) {
      print('Error getting message users length: $e');
      rethrow; // Rethrow the error to handle it in the UI if needed
    }
  }

  Future<int?> getUserEmailIndex() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      final userData = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> messageUsers = userData['MessageUsers'] ?? [];

      for (var i = 0; i < messageUsers.length; i++) {
        final user = messageUsers[i]['MessageUsers'] as Map<String, dynamic>;
        final String? userEmail = user['email'];
        if (userEmail != null) {
          return i;
        }
      }
      return null; // User email not found
    } catch (e) {
      print('Error getting user email index: $e');
      rethrow; // Rethrow the error to handle it in the UI if needed
    }
  }

  // Future<String> getUserEmail(int index) async {
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.email)
  //         .get();
  //     final userData = snapshot.data() as Map<String, dynamic>;
  //     final List<dynamic> messageUsers = userData['MessageUsers'] ?? [];

  //     if (messageUsers.isNotEmpty && index < messageUsers.length) {
  //       final user =
  //           messageUsers[index]['MessageUsers'] as Map<String, dynamic>;
  //       final String userEmail = user['email'];
  //       return userEmail;
  //     } else {
  //       throw Exception('User email not found');
  //     }
  //   } catch (e) {
  //     print('Error getting user email: $e');
  //     rethrow; // Rethrow the error to handle it in the UI if needed
  //   }
  // }

  Future<List<String>> getUserEmailsFromIndex(int startIndex) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();
      final userData = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> messageUsers = userData['MessageUsers'] ?? [];
      List<String> userEmails = [];

      for (int i = startIndex; i < messageUsers.length; i++) {
        final userMap = messageUsers[i]['MessageUsers'] as Map<String, dynamic>;
        final String userEmail = userMap['email'] as String;
        userEmails.add(userEmail);
      }

      if (userEmails.isNotEmpty) {
        return userEmails;
      } else {
        throw Exception('No user emails found from index $startIndex');
      }
    } catch (e) {
      print('Error getting user emails: $e');
      rethrow; // Rethrow the error to handle it in the UI if needed
    }
  }

  Future<void> updateUserName(List<String> userEmails, String newName) async {
    try {
      for (String userEmail in userEmails) {
        final DocumentSnapshot senderSnapshot =
            await _firestore.collection('users').doc(userEmail).get();

        if (senderSnapshot.exists) {
          List<dynamic> existingData =
              (senderSnapshot.data() as Map<String, dynamic>)['MessageUsers'] ??
                  [];
          List<Map<String, dynamic>> userList =
              List<Map<String, dynamic>>.from(existingData);

          for (var userMap in userList) {
            final String email = userMap['MessageUsers']['email'];
            final String uid = userMap['MessageUsers']['UID'];

            if (email == FirebaseAuth.instance.currentUser!.email &&
                uid == FirebaseAuth.instance.currentUser!.uid) {
              userMap['MessageUsers']['Name'] = newName;
              break; // Exit loop after updating name for the user
            }
          }

          // Update Firestore document
          await _firestore
              .collection('users')
              .doc(userEmail)
              .set({"MessageUsers": userList}, SetOptions(merge: true));
          print('User name updated successfully for $userEmail');
        } else {
          print('User document does not exist for $userEmail');
        }
      }
    } catch (error) {
      print('Error updating user names: $error');
      // Handle the error accordingly
    }
  }

  Future<void> updateStatus(List<String> userEmails, String status) async {
    try {
      for (String userEmail in userEmails) {
        final DocumentSnapshot senderSnapshot =
            await _firestore.collection('users').doc(userEmail).get();

        if (senderSnapshot.exists) {
          List<dynamic> existingData =
              (senderSnapshot.data() as Map<String, dynamic>)['MessageUsers'] ??
                  [];
          List<Map<String, dynamic>> userList =
              List<Map<String, dynamic>>.from(existingData);

          for (var userMap in userList) {
            final String email = userMap['MessageUsers']['email'];
            final String uid = userMap['MessageUsers']['UID'];

            if (email == FirebaseAuth.instance.currentUser!.email &&
                uid == FirebaseAuth.instance.currentUser!.uid) {
              userMap['MessageUsers']['Name'] = status;
              break; // Exit loop after updating name for the user
            }
          }

          // Update Firestore document
          await _firestore
              .collection('users')
              .doc(userEmail)
              .set({"MessageUsers": userList}, SetOptions(merge: true));
          print('User name updated successfully for $userEmail');
        } else {
          print('User document does not exist for $userEmail');
        }
      }
    } catch (error) {
      print('Error updating user names: $error');
      // Handle the error accordingly
    }
  }
}
