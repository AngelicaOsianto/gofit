//penghubung UI antar login dan service

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? get userName => null;

  // Cek status login saat aplikasi baru dibuka
  void checkLoginStatus() {
    _user = _authService.currentUser;
    notifyListeners();
  }

  // Logic Login untuk dipanggil UI
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.signIn(email: email, password: password);
      _errorMessage = null;
      _setLoading(false);
      return true; // Berhasil
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false; // Gagal
    }
  }

  // Logic Register untuk dipanggil UI
  Future<bool> register(String email, String password) async {
    _setLoading(true);
    try {
      _user = await _authService.signUp(email: email, password: password);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUserName(String fullName) {}
}