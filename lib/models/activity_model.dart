// lib/models/activity_model.dart (Direvisi)

import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  // Properti Domain
  final String id; // Digunakan sebagai docId Firestore
  final String title;
  final String type; // Running, Walking, Bike
  final DateTime startDate;
  final int durationMinutes;
  final String? notes;
  final DateTime? reminderTime;
  bool isCompleted;

  // Properti tambahan (untuk tampilan UI yang meminta String kalori)
  final String calories; // Disimpan sebagai String, dikalkulasi sebelum disimpan

  ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.durationMinutes,
    required this.calories, // Wajib diisi saat membuat model
    this.notes,
    this.reminderTime,
    this.isCompleted = false,
  });


  // =========================================================
  // 1. MAPPER: Dari Firestore (JSON) ke Objek Dart
  // =========================================================
  factory ActivityModel.fromJson(Map<String, dynamic> json, String docId) {
    // Parsing yang Aman: Mengambil Timestamp dari Firestore
    final timestamp = json['startDate'] as Timestamp;

    return ActivityModel(
      id: docId, // Menggunakan docId Firestore sebagai id internal
      title: json['title'] as String,
      type: json['type'] as String,
      startDate: timestamp.toDate(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      calories: json['calories'] as String,
      notes: json['notes'] as String?,
      reminderTime: (json['reminderTime'] as Timestamp?)?.toDate(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  // =========================================================
  // 2. MAPPER: Dari Objek Dart ke Map (JSON) untuk Firestore
  // =========================================================
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      // Konversi Dart DateTime ke Firestore Timestamp
      'startDate': Timestamp.fromDate(startDate),
      'durationMinutes': durationMinutes,
      'calories': calories,
      'notes': notes,
      // Konversi Dart DateTime ke Firestore Timestamp (nullable)
      'reminderTime': reminderTime != null ? Timestamp.fromDate(reminderTime!) : null,
      'isCompleted': isCompleted,
    };
  }

// ... (copyWith method Anda diletakkan di sini)
}