import 'package:get/get_navigation/get_navigation.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          "email_hint": 'Email',
          "title": 'A²RI Craft',
          "des": "Tailor Service is.\nOn Demand",
          "tailor": "Tailor",
          "customer": "Customer",
          "sign_in": 'Sign In',
          "skip": 'Skip'
        },
        'ur_PK': {
          'email_hint': 'ای میل درج کریں۔',
          'title': 'A²RI Craft',
          "des": 'درزی سروس ہے۔\nمطالبہ پر',
          'tailor': "درزی",
          'customer': "صارف",
          'sign_in': "سائن ان",
          'skip': "چھوڑ دو"
        },
      };
}
