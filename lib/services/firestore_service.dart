//Simpan/ambil data aktivitas

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/activity_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Nama gudang penyimpanan di Firebase
  final String _collectionName = 'activities';

  // 1. Tambah Data Olahraga Baru
  Future<void> addActivity(ActivityModel activity) async {
    try {
      // Menyimpan data dengan ID unik yang kita buat
      await _db.collection(_collectionName).doc(activity.id).set(activity.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  // 2. Ambil Daftar Olahraga (Realtime)
  // Stream artinya: Kalau ada data baru, aplikasi langsung update otomatis tanpa refresh
  Stream<List<ActivityModel>> getActivities(String userId) {
    return _db
        .collection(_collectionName)
        .where('userId', isEqualTo: userId) // Ambil data milik user ini saja
        .orderBy('date', descending: true)  // Urutkan dari yang terbaru
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ActivityModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 3. Hapus Data
  Future<void> deleteActivity(String activityId) async {
    await _db.collection(_collectionName).doc(activityId).delete();
  }
}