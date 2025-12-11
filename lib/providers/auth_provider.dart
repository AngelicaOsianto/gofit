import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? _user;
  String _userName = "Runner";
  String _email = "";
  String _weight = "60";
  String _height = "170";

  // Getters yang dibutuhkan UI
  User? get user => _user;
  bool get isAuthenticated => _user != null;
  String get userName => _userName;
  String get email => _email;
  String get weight => _weight;
  String get height => _height;

  // Cek sesi (Dibutuhkan SplashScreen)
  void checkAuthStatus() {
    _user = _auth.currentUser;
    if (_user != null) {
      _fetchUserProfile();
    }
    notifyListeners();
  }

  Future<void> _fetchUserProfile() async {
    if (_user == null) return;
    try {
      final doc = await _db.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        _userName = data['name'] ?? "Runner";
        _email = data['email'] ?? _user!.email ?? "";
        _weight = data['weight'] ?? "60";
        _height = data['height'] ?? "170";
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String weight,
    required String height,
  }) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    _user = result.user;
    if (_user != null) {
      await _db.collection('users').doc(_user!.uid).set({
        'name': name, 'email': email, 'weight': weight, 'height': height,
        'createdAt': DateTime.now().toIso8601String(),
      });
      _userName = name; _email = email; _weight = weight; _height = height;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    _user = result.user;
    await _fetchUserProfile();
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}