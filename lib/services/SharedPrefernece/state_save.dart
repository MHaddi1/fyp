import 'package:shared_preferences/shared_preferences.dart';

class StateSave {
  Future<void> saveState() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setBool("check", true);
  }

  // Load state
  Future<bool> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLogged') ??
        false; // Default value is false if not found
  }
}
