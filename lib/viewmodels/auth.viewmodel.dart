import 'package:flutter/material.dart';
import 'package:oldcare/views/login_page.dart';
import '../models/user.model.dart';
import '../services/auth/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  AuthViewModel(this._authService);

  User_App? user;
  bool isLoading = false;
  String? error;

  Future<void> login(String email, String password) async {
    try {
      user = await _authService.login(email, password);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> registerChild({
    required String email,
    required String password,
    required String role,
    required String name,
    required String phone,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      user = await _authService.registerChild(
        email,
        password,
        role,
        name,
        phone,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerParent({
    required String password,
    required String name,
    required String phone,
    required String childPhone,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      user = await _authService.registerParent(
        password: password,
        name: name,
        phone: phone,
        phoneChild: childPhone,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    // MaterialPageRoute(builder: (_) => LoginScreen());
    await _authService.logout();
    user = null;
    notifyListeners();
  }
}
