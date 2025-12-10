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
    );
  }
}