import 'package:fyp/const/assets/videos/app_videos.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class SuggestionController extends GetxController {
  late VideoPlayerController videoController;

  @override
  void onInit() {
    super.onInit();
    videoController = VideoPlayerController.asset(AppVideos.backgroundVideo);
    videoController.initialize().then((_) {
      videoController.setLooping(true);
      videoController.play();
      update();
    });
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    videoController.dispose();
    super.dispose();
  }
}
