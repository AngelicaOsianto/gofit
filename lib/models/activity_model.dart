class ActivityModel {
  final String id;
  final String title;
  final String type; // Running, Walking, Bike
  final DateTime startDate;
  final int durationMinutes;
  final String? notes;
  final DateTime? reminderTime;
  bool isCompleted;
  bool isReminderSent; // <--- BARU: Penanda apakah notif sudah muncul

  ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.durationMinutes,
    this.notes,
    this.reminderTime,
    this.isCompleted = false,
    this.isReminderSent = false, // <--- Default False
  });

  ActivityModel copyWith({
    String? id,
    String? title,
    String? type,
    DateTime? startDate,
    int? durationMinutes,
    String? notes,
    DateTime? reminderTime,
    bool? isCompleted,
    bool? isReminderSent,
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
      isReminderSent: isReminderSent ?? this.isReminderSent,
    );
  }
}