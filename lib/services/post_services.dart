import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/models/post_model.dart';

class PostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  

  Future<List<PostModel>> getPosts(String collectionName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection(collectionName).get();

      List<PostModel> posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
      print(posts);

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }
}
