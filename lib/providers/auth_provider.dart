// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import ini WAJIB menunjuk ke file service yang sudah kita buat sebelumnya
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  // Memanggil Class AuthService yang asli (bukan yang kosong)
  final AuthService _authService = AuthService();

  User? _user; // User yang sedang login
  bool _isLoading = false;
  String? _errorMessage;
  bool _registrationSuccess = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get registrationSuccess => _registrationSuccess;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    // Memantau perubahan user secara real-time (Login/Logout/Register)
    _authService.userChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // 1. LOGIKA SIGN UP (Daftar Akun)
  Future<void> register(String email, String password, String name) async {
    _isLoading = true;
    _errorMessage = null;
    _registrationSuccess = false;
    notifyListeners();

    try {
      // Memanggil fungsi di Service (yang akan simpan ke Database juga)
      await _authService.signUpWithEmail(
          email: email,
          password: password,
          name: name
      );
      _registrationSuccess = true;
    } catch (e) {
      // Menangkap error (baik dari Firebase Auth atau Firestore)
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. LOGIKA SIGN IN (Login Email)
  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmail(email, password);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 3. LOGIKA LOGIN (Google)
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 4. LOGIKA LOGOUT (Keluar)
  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}