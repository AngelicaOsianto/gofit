import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/activity_model.dart';
import '../../../providers/activity_provider.dart';
import '../../timer/timer_screen.dart'; // Import Timer

class ActivityItemCard extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback onTap;

  const ActivityItemCard({
    super.key,
    required this.activity,
    required this.onTap,
  });

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Running': return Colors.green;
      case 'Walking': return Colors.blue;
      case 'Bike': return Colors.orange;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(activity.startDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: InkWell(
          onTap: () {
            Provider.of<ActivityProvider>(context, listen: false)
                .toggleActivityStatus(activity.id);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.isCompleted ? Colors.green : Colors.transparent,
              border: Border.all(color: Colors.green, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: activity.isCompleted
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              activity.type,
              style: TextStyle(
                  color: _getTypeColor(activity.type),
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$formattedTime | ${activity.durationMinutes} min",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill, color: Colors.white, size: 36),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerScreen(specificActivity: activity),
              ),
            );
          },
        ),
      ),
    );
  }
}