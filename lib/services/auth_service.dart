import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    var box = await Hive.openBox('authBox');
    _isAuthenticated = box.get('isLoggedIn', defaultValue: false);
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // Dummy validation
    await Future.delayed(const Duration(milliseconds: 500)); 
    if (email == 'admin@eczanem.com' && password == '123456') {
      _isAuthenticated = true;
      var box = await Hive.openBox('authBox');
      await box.put('isLoggedIn', true);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    var box = await Hive.openBox('authBox');
    await box.put('isLoggedIn', false);
    notifyListeners();
  }
}
