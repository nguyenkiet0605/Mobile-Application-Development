import 'package:flutter/material.dart';

class TasksHeader extends StatelessWidget {
  final int total;
  final int completed;

  const TasksHeader({super.key, required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tiến độ hôm nay',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed / $total',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.indigo[300],
            valueColor: const AlwaysStoppedAnimation(Colors.white),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
