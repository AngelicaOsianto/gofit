//penghubuung antar UI home dan service

import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../services/firestore_service.dart';

class ActivityProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- KAMUS MET (DATA DARI ANGGOTA C) ---
  // Ini daftar nilai intensitas olahraga.
  // Nanti Anggota C yang melengkapi list ini via Notepad.
  final Map<String, double> metValues = {
    'Lari Santai': 6.0,
    'Lari Cepat': 9.8,
    'Jalan Kaki': 3.8,
    'Bersepeda': 7.5,
  };

  // --- RUMUS PINTAR HITUNG KALORI ---
  // Rumus: MET x Berat Badan (kg) x Durasi (jam) = Total Kalori
  double _calculateCalories(String activityName, double durationMinutes, double weightKg) {
    // Ambil nilai MET, kalau tidak ada di kamus, anggap 1.0 (seperti duduk diam)
    double met = metValues[activityName] ?? 1.0;

    // Konversi menit ke jam (menit / 60)
    return met * weightKg * (durationMinutes / 60);
  }

  // Fungsi yang dipanggil saat tombol "Simpan" ditekan
  Future<void> addActivity({
    required String userId,
    required String activityName,
    required double durationMinutes,
    required double weightKg,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Hitung dulu kalorinya
      double calories = _calculateCalories(activityName, durationMinutes, weightKg);

      // 2. Buat ID unik berdasarkan waktu sekarang
      String newId = DateTime.now().millisecondsSinceEpoch.toString();

      // 3. Bungkus data jadi rapi
      ActivityModel newActivity = ActivityModel(
        id: newId,
        userId: userId,
        activityName: activityName,
        durationMinutes: durationMinutes,
        caloriesBurned: calories, // <-- Hasil hitungan otomatis masuk sini
        date: DateTime.now(),
      );

      // 4. Kirim ke Firebase
      await _firestoreService.addActivity(newActivity);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Fungsi untuk List di Halaman Home
  Stream<List<ActivityModel>> getActivities(String userId) {
    return _firestoreService.getActivities(userId);
  }

  // Fungsi Hapus
  Future<void> removeActivity(String id) async {
    await _firestoreService.deleteActivity(id);
  }
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/activity_model.dart';

class ActivityProvider with ChangeNotifier {
  final Uuid _uuid = const Uuid(); // Inisialisasi UUID yang benar

  // Data Dummy Awal
  final List<ActivityModel> _activities = [
    ActivityModel(
      id: '1',
      title: "Lari Pagi",
      type: "Running",
      startDate: DateTime.now(),
      durationMinutes: 60,
      isCompleted: false,
    ),
  ];

  List<ActivityModel> get activities => _activities;

  // CREATE
  void addActivity(ActivityModel activity) {
    _activities.add(activity);
    notifyListeners();
  }

  // UPDATE
  void updateActivity(String id, ActivityModel updatedActivity) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _activities[index] = updatedActivity;
      notifyListeners();
    }
  }

  // DELETE
  void deleteActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  // TOGGLE STATUS (Checkbox)
  void toggleActivityStatus(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _activities[index].isCompleted = !_activities[index].isCompleted;
      notifyListeners();
    }
  }

  // Helper generate ID
  String generateId() => _uuid.v4();
}