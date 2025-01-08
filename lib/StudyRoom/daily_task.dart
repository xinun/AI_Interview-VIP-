import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DailyTask extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final String motivationMessage;

  const DailyTask({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.motivationMessage,
  });

  @override
  Widget build(BuildContext context) {
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0; // 0으로 나누기 방지

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Task",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            "$completedTasks/$totalTasks Task Completed",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            "\"$motivationMessage\"",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Container(
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade800,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                color: Colors.purple,
              ),
            ),
          ),
          const SizedBox(height: 10),

        ],
      ),
    );
  }
}

