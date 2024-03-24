import 'package:get/get.dart';

class OrdersController extends GetxController {
  RxString dropdownValue = "Accept".obs;
  RxString dropdownValue2 = "Shipped".obs;
  RxString dropdownValue3 = "OutForDelivery".obs;
  RxString dropdownValue4 = "delivered".obs;

  void changeValue(String newValue) {
    dropdownValue.value = newValue;
  }

  void changeValue2(String newValue) {
    dropdownValue2.value = newValue;
  }

  void changeValue3(String newValue) {
    dropdownValue3.value = newValue;
  }

  void changeValue4(String newValue) {
    dropdownValue4.value = newValue;
  }
}
