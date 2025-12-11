import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<ActivityModel> _activities = [];

  List<ActivityModel> get activities => _activities;

  // Getter History: Hanya yang isCompleted = true
  List<ActivityModel> get history => _activities.where((a) => a.isCompleted).toList();

  // Fungsi Fetch (Dibutuhkan HomeScreen)
  Future<void> fetchActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await _db.collection('activities')
        .where('userId', isEqualTo: user.uid)
        .get();

    _activities = snapshot.docs.map((doc) => ActivityModel.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  void toggleActivityStatus(String id) {
    final index = _activities.indexWhere((a) => a.id == id);
    if (index != -1) {
      _activities[index].isCompleted = !_activities[index].isCompleted;
      notifyListeners();
    }
  }
}