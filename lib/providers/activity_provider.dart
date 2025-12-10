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