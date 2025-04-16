import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final Map<String, String> _users = {};

  Future<bool> signUp(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_users.containsKey(email)) {
      return false; // User already exists
    }
    _users[email] = password;
    await prefs.setString(email, password); // Save to persistent storage
    return true;
  }

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedPassword = prefs.getString(email);
    return storedPassword == password;
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    _users[email] = password;
    await prefs.setString(email, password); // Save to persistent storage
  }

  checkAccountExists(String email) {}
}
