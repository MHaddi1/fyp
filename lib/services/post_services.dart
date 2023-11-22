import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/models/post_model.dart';

class PostServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PostModel>> getPosts(String collectionName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection(collectionName).get();

      List<PostModel> posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();
      print(posts);

      return posts;
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }

  Future<void> updateLikes(
      String collectionName, String postId, List<String> likes) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(postId)
          .update({'likes': likes});
      print("Likes updated for post $postId");
    } catch (e) {
      print('Error updating likes: $e');
      rethrow;
    }
  }

  Future<void> updatePost(
      String collectionName, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection(collectionName).doc().update(updatedData);
      print("Post updated successfully");
    } catch (e) {
      print('Error updating post: $e');
      rethrow;
    }
  }
}
