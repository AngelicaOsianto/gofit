import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  // Data Dummy Awal
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: "Welcome to GoFit!",
      body: "Start your journey today. Set your first activity now.",
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      title: "Time to Drink Water",
      body: "Stay hydrated! Drink a glass of water now.",
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
  ];

  List<NotificationModel> get notifications {
    // Urutkan: Terbaru di atas
    _notifications.sort((a, b) => b.time.compareTo(a.time));
    return _notifications;
  }

  int get unreadCount {
    return _notifications.where((n) => !n.isRead).length;
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  // --- FUNGSI BARU UNTUK MENAMBAH NOTIFIKASI ---
  void addNotification(String title, String body, DateTime time) {
    _notifications.add(
      NotificationModel(
        id: DateTime.now().toString(), // ID Unik dari waktu sekarang
        title: title,
        body: body,
        time: time,
        isRead: false, // Otomatis jadi belum dibaca (muncul badge merah)
      ),
    );
    notifyListeners();
  }
}