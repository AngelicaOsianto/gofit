//simpan jenis, durasi, kalori, tanggal

class ActivityModel {
  final String id;
  final String userId;
  final String activityName;
  final double durationMinutes; // Lama olahraga (menit)
  final double caloriesBurned;  // Hasil hitungan rumus MET
  final DateTime date;

  ActivityModel({
    required this.id,
    required this.userId,
    required this.activityName,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.date,
  });

  // Mengubah data jadi JSON untuk dikirim ke Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'activityName': activityName,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'date': date.toIso8601String(),
    };
  }

  // Mengubah JSON dari Firebase menjadi data Aplikasi
  factory ActivityModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ActivityModel(
      id: documentId,
      userId: map['userId'] ?? '',
      activityName: map['activityName'] ?? 'Unknown',
      durationMinutes: (map['durationMinutes'] ?? 0).toDouble(),
      caloriesBurned: (map['caloriesBurned'] ?? 0).toDouble(),
      date: DateTime.parse(map['date']),

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