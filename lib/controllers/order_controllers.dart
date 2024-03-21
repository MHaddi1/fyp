import 'package:get/get.dart';

class OrdersController extends GetxController {
  RxString dropdownValue = "Accept".obs;
  void changeValue(String newValue) {
    dropdownValue.value = newValue;
  }
}
