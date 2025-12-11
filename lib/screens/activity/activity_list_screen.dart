import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/activity_provider.dart';
import 'activity_form_screen.dart';
import 'widgets/activity_item_card.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita gunakan SafeArea agar tidak tertutup notch HP
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Activity (Custom, bukan AppBar bawaan Scaffold)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "My Activity",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "It's time to challenge your limits",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),

          // List Activity
          Expanded(
            child: Consumer<ActivityProvider>(
              builder: (context, provider, child) {
                final activities = provider.activities;

                if (activities.isEmpty) {
                  return const Center(
                      child: Text("No activities yet. Tap '+' to add.", style: TextStyle(color: Colors.white54))
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return ActivityItemCard(
                      activity: activities[index],
                      onTap: () {
                        // Edit Activity
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityFormScreen(activityId: activities[index].id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}