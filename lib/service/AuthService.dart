import 'package:shared_preferences/shared_preferences.dart';

 class AuthService {

  Future<void> login(String sessionID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionID', sessionID);
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionID');
  }

  Future<String?> getSessionID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionID');
  }
}