import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/activity_provider.dart';
import '../../models/activity_model.dart';
import '../../main.dart'; // Import AuthProvider

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  int _calculateCalories(String type, int durationMinutes, String userWeight) {
    double weight = double.tryParse(userWeight) ?? 60.0;
    double durationHours = durationMinutes / 60.0;
    double met = 0;

    switch (type.toLowerCase()) {
      case 'running': met = 8.0; break;
      case 'walking': met = 3.0; break;
      case 'bike': met = 4.0; break;
      default: met = 3.0;
    }
    return (met * weight * durationHours).round();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String userWeight = authProvider.weight;

    return Scaffold(
      backgroundColor: AppTheme.blackBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Completed History", // Judul diganti biar lebih jelas
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: Consumer<ActivityProvider>(
                builder: (context, provider, child) {
                  // Provider.history SEKARANG HANYA MENGEMBALIKAN YANG SUDAH DICENTANG
                  final historyList = provider.history;

                  if (historyList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline, size: 80, color: Colors.grey.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          const Text(
                            "No completed activities yet.\nFinish an activity to see it here!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: historyList.length,
                    itemBuilder: (context, index) {
                      final activity = historyList[index];
                      // Cek apakah sudah dihapus dari jadwal (tidak ada di provider.activities)
                      final bool isDeleted = !provider.activities.any((a) => a.id == activity.id);
                      final int calories = _calculateCalories(activity.type, activity.durationMinutes, userWeight);

                      return _buildHistoryCard(activity, isDeleted, calories);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ActivityModel activity, bool isDeleted, int calories) {
    // Karena list ini isinya PASTI completed, kita hanya perlu bedakan
    // apakah "Deleted Completed" atau "Active Completed"
    Color statusColor = isDeleted ? Colors.redAccent : AppTheme.neonGreen;
    String statusText = isDeleted ? "Deleted" : "Completed";
    IconData statusIcon = isDeleted ? Icons.delete_outline : Icons.check_circle_outline;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10, offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('EEEE, dd MMM yyyy').format(activity.startDate),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(statusText, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.neonGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getActivityIcon(activity.type), color: AppTheme.neonGreen, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(activity.type.toUpperCase(), style: TextStyle(color: AppTheme.neonGreen.withValues(alpha: 0.8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem(Icons.timer_outlined, "${activity.durationMinutes} Min", "Duration"),
                Container(width: 1, height: 30, color: Colors.white10),
                _buildMetricItem(Icons.local_fire_department_outlined, "$calories Kcal", "Burned"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'running': return Icons.directions_run;
      case 'walking': return Icons.directions_walk;
      case 'bike': return Icons.directions_bike;
      default: return Icons.fitness_center;
    }
  }
}