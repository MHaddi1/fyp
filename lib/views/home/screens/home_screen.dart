import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final postController = Get.put(HomeController());
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
    //postController.fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Obx(() {
        final posts = postController.posts;

        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (posts.isEmpty) {
          return const Center(child: Text("No Data Found"));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              DateTime datetime = posts[index].date;
              return FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => CircleAvatar(
                              backgroundColor: Colors.orange,
                              radius: 30,
                              backgroundImage: CachedNetworkImageProvider(
                                posts[index].image,
                              ),
                            ),
                          ),
                          10.widthBox,
                          Obx(() => Text(posts[index].name)),
                          10.widthBox,
                          const Icon(
                            Icons.verified,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      10.heightBox,
                      _formatDate(datetime).text.make().box.alignTopLeft.make(),
                      5.heightBox,
                      posts[index].post.text.justify.make(),
                      10.heightBox,
                      const Divider(
                        thickness: 2,
                        color: Colors.orange,
                      ),
                      5.heightBox,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.thumb_up,
                            color: Colors.orange,
                          ),
                          Icon(Icons.message),
                          Icon(Icons.share),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          '2K Likes'.text.make(),
                          '590 Comments'.text.make(),
                          '100 Shares'.text.make(),
                        ],
                      ),
                    ],
                  ).box.roundedLg.color(Colors.white).shadowSm.p20.make(),
                ),
              );
            },
          );
        }
      }),
    );
  }

  String _formatDate(DateTime dateTime) {
    String formattedDate = DateFormat.yMMMd().format(dateTime);
    return formattedDate;
  }
}
