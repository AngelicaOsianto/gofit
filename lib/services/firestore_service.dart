//Simpan/ambil data aktivitas

// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/activity_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // C: CREATE (Menyimpan Data Tambahan Setelah Daftar)
  Future<void> saveUserProfile(UserModel user) async {
    if (userId == null) throw Exception("User not logged in.");
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  // C: CREATE (Menyimpan Hasil Tracking)
  Future<void> saveActivity(ActivityModel activity) async {
    if (userId == null) throw Exception("User not logged in.");
    await _db.collection('users').doc(userId).collection('activities').add({
      ...activity.toJson(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // R: READ (Mendapatkan Stream Aktivitas untuk History)
  Stream<List<ActivityModel>> getActivitiesStream() {
    if (userId == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(userId)
        .collection('activities')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ActivityModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }
}