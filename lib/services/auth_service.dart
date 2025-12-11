import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 1. GETTER USER CHANGES (Untuk memantau status login real-time)
  Stream<User?> get userChanges => _auth.userChanges();

  // 2. GET CURRENT USER
  User? get currentUser => _auth.currentUser;

  // 3. SIGN UP EMAIL & PASSWORD (+ SIMPAN KE DATABASE)
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name
  }) async {
    try {
      // A. Buat Akun di Firebase Auth (Cuma email & pass)
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      User? user = result.user;

      // B. SAMBUNG KE DATABASE (Simpan Nama & Email ke Firestore)
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,       // Ini yang penting
          'email': email,
          'role': 'user',     // Bisa set default role
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  // 4. SIGN IN EMAIL
  Future<User?> signInWithEmail(String email, String password) async {
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

  // 5. SIGN IN WITH GOOGLE (Biarpun belum disetting SHA-1, methodnya harus ada biar gak error)
  Future<User?> signInWithGoogle() async {
    try {
      // Trigger flow pop up Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User batal login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Buat kredensial baru
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase dengan kredensial Google
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Cek apakah user ini baru pertama kali login Google? Kalau ya, simpan ke DB
      if (result.additionalUserInfo!.isNewUser && user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? "No Name",
          'email': user.email,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      throw e.toString();
    }
  }

  // 6. LOGOUT
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}