class ActivityModel {
  final String id;
  final String title;
  final String type; // Running, Walking, Bike
  final DateTime startDate;
  final int durationMinutes;
  final String? notes;
  final DateTime? reminderTime;
  bool isCompleted;
  bool isReminderSent;

  ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.startDate,
    required this.durationMinutes,
    this.notes,
    this.reminderTime,
    this.isCompleted = false,
    this.isReminderSent = false,
  });

  // 1. Ubah Data ke Format JSON (Untuk dikirim ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type,
      'startDate': startDate.toIso8601String(), // Ubah tanggal jadi teks ISO
      'durationMinutes': durationMinutes,
      'notes': notes,
      'reminderTime': reminderTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'isReminderSent': isReminderSent,
    };
  }

  // 2. Ubah JSON dari Firebase menjadi Data Aplikasi
  factory ActivityModel.fromMap(Map<String, dynamic> map, String docId) {
    return ActivityModel(
      id: docId, // ID diambil dari nama dokumen di Firebase
      title: map['title'] ?? '',
      type: map['type'] ?? 'Running',
      startDate: DateTime.parse(map['startDate']),
      durationMinutes: map['durationMinutes'] ?? 0,
      notes: map['notes'],
      reminderTime: map['reminderTime'] != null ? DateTime.parse(map['reminderTime']) : null,
      isCompleted: map['isCompleted'] ?? false,
      isReminderSent: map['isReminderSent'] ?? false,
    );
  }

  // Helper untuk Clone data (Edit)
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