import 'package:get/get.dart';
import '../models/post_model.dart';
import '../services/post_services.dart';

class HomeController extends GetxController {
  final postServices = PostServices();
  final posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;

  fetchData() async {
    //final String collectionName = 'admin_Post';
    try {
      isLoading.value = true;
      final fetchedPosts = await postServices.getPosts("admin_Post");
      posts.addAll(fetchedPosts);
      print("Successfully fetched");
      print(posts);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
}
