import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_splitter/model/auth_models.dart'; // Adjust import path if needed

class SessionManager {
  // A static method allows us to call it without creating an instance of the class
  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('userId', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email ?? '');
    await prefs.setString('mobile', user.mobile);
    await prefs.setString('country_code', user.countryCode ?? '');
    await prefs.setInt('is_banned', user.is_banned);
    await prefs.setString('username', user.username);
    await prefs.setString('dp', user.dp ?? '');
  }
}
