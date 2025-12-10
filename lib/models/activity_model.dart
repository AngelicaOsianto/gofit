// Lokasi: lib/models/activity_model.dart

class ActivityModel {
  final String id;
  final String title;
  final String type; // Running, Walking, Bike
  final DateTime startDate;
  final int durationMinutes;
  final String? notes;
  final DateTime? reminderTime; // Menyimpan waktu reminder
  bool isCompleted;

  ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.durationMinutes,
    this.notes,
    this.reminderTime,
    this.isCompleted = false,
  });

  // Helper untuk duplikasi data (berguna saat Edit agar data lama tidak hilang)
  ActivityModel copyWith({
    String? id,
    String? title,
    String? type,
    DateTime? startDate,
    int? durationMinutes,
    String? notes,
    DateTime? reminderTime,
    bool? isCompleted,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      notes: notes ?? this.notes,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}