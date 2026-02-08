import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/activity_model.dart';

class ActivityProvider with ChangeNotifier {
  final Uuid _uuid = const Uuid();

  // 1. List Jadwal Aktif (Untuk Tab Activity & Dashboard)
  final List<ActivityModel> _activities = [
    // Data Dummy (Contoh)
    ActivityModel(
      id: '1',
      title: "Lari Sore",
      type: "Running",
      startDate: DateTime.now().add(const Duration(hours: 2)),
      durationMinutes: 60,
      isCompleted: false, // Belum selesai -> Tidak akan muncul di History
    ),
    ActivityModel(
      id: '2',
      title: "Jalan Pagi Santai",
      type: "Walking",
      startDate: DateTime.now().subtract(const Duration(hours: 1)),
      durationMinutes: 30,
      isCompleted: true, // Sudah selesai -> AKAN MUNCUL DI HISTORY
    ),
  ];

  // 2. List History (Arsip Semua Data)
  late List<ActivityModel> _history = [..._activities];

  // Getter Activities (Jadwal Aktif)
  List<ActivityModel> get activities {
    final sortedList = [..._activities];
    sortedList.sort((a, b) => a.startDate.compareTo(b.startDate));
    return sortedList;
  }

  // --- BAGIAN INI YANG DIUBAH (FILTER HISTORY) ---
  List<ActivityModel> get history {
    // 1. Ambil data dari _history
    // 2. FILTER: Hanya ambil yang sudah dicentang (isCompleted == true)
    final completedOnly = _history.where((a) => a.isCompleted == true).toList();

    // 3. Urutkan dari yang terbaru (Start Date paling besar di atas)
    completedOnly.sort((a, b) => b.startDate.compareTo(a.startDate));

    return completedOnly;
  }
  // -----------------------------------------------

  String generateId() => _uuid.v4();

  void addActivity(ActivityModel activity) {
    _activities.add(activity);
    _history.add(activity);
    notifyListeners();
  }

  void updateActivity(String id, ActivityModel updatedActivity) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _activities[index] = updatedActivity;
    }

    final indexHistory = _history.indexWhere((a) => a.id == id);
    if (indexHistory != -1) {
      _history[indexHistory] = updatedActivity;
    }

    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((a) => a.id == id);
    // Kita TIDAK menghapus dari _history, agar tetap ada arsipnya.
    // Tapi karena ada filter di 'get history', item ini hanya akan muncul di History
    // JIKA statusnya isCompleted == true.
    notifyListeners();
  }

  void toggleActivityStatus(String id) {
    // Update di Jadwal Aktif
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = _activities[index].copyWith(
          isCompleted: !_activities[index].isCompleted
      );
      _activities[index] = updated;

      // Update di History juga (PENTING AGAR FILTER BERJALAN)
      final indexHistory = _history.indexWhere((a) => a.id == id);
      if (indexHistory != -1) {
        _history[indexHistory] = updated;
      }

      notifyListeners();
    }
  }

  void markReminderAsSent(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _activities[index] = _activities[index].copyWith(isReminderSent: true);
      notifyListeners();
    }
  }
}