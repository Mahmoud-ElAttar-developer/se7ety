import 'package:shared_preferences/shared_preferences.dart';

class AppLocal {
  static String doctorLogin = 'doctorLogin';
  static String onboardingSkipped = 'onBoardingSkipped';
  static String imageProfile = 'imageProfile';

  static dynamic cacheData(String key, dynamic value) async {
    final pref = await SharedPreferences.getInstance();
    if (value is bool) {
      await pref.setBool(key, value);
    } else if (value is String) {
      await pref.setString(key, value);
    } else {
      await pref.setDouble(key, value);
    }
  }

  static Future<dynamic> getData(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.get(key);
  }
}
