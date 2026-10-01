import 'package:shared_preferences/shared_preferences.dart';

abstract final class AuthFlowPreferences {
  static const _keySignupEmail = 'signup_email';
  static const _keyEmailVerified = 'email_verified';
  static const _keyDataSharingAcknowledged = 'data_sharing_acknowledged';

  static Future<String> getSignupEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keySignupEmail) ?? 'hello@facepix.ai';
  }

  static Future<void> setSignupEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keySignupEmail, email);
  }

  static Future<bool> isEmailVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyEmailVerified) ?? false;
  }

  static Future<void> setEmailVerified(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEmailVerified, value);
  }

  static Future<bool> isDataSharingAcknowledged() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDataSharingAcknowledged) ?? false;
  }

  static Future<void> setDataSharingAcknowledged(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDataSharingAcknowledged, value);
  }
}
