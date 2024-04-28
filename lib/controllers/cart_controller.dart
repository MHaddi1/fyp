import 'package:get/get.dart';

class CartController extends GetxController {
  RxInt currentIndex = 0.obs;
  void updateIndex(dynamic index) {
    currentIndex.value = index;
  }
}
