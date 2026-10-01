import 'package:shared_preferences/shared_preferences.dart';

abstract final class RegistrationPreferences {
  static const _keyCompleted = 'registration_completed';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCompleted) ?? false;
  }

  static Future<void> setCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, value);
  }
}
