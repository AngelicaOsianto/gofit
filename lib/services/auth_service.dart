//untuk login/Register ke Firebase

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cek siapa user yang sedang login
  User? get currentUser => _auth.currentUser;

  // Fungsi Register (Daftar Akun)
  Future<User?> signUp({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } catch (e) {
      // Lempar error ke Provider biar bisa muncul di layar
      throw e.toString();
    }
  }

  // Fungsi Login
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return result.user;
    } catch (e) {
      throw e.toString();
    }
  }

  // Fungsi Logout (Keluar)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}}
//untuk login/Register ke Firebase
