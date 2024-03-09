import 'package:connectivity/connectivity.dart';

class ConnectivityUtil {
  ConnectivityUtil._instance();
  static final instance = ConnectivityUtil._instance();
  Future<bool> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
