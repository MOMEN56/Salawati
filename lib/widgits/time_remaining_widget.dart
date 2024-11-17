import 'package:flutter/material.dart';

class TimeRemainingWidget extends StatelessWidget {
  final String remainingTime;

  const TimeRemainingWidget({super.key, required this.remainingTime});

  @override
  Widget build(BuildContext context) {
    // طباعة الوقت المتبقي للتحقق
    print("Remaining Time in Widget: $remainingTime");

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (remainingTime.isNotEmpty)
            Column(
              children: [
                Text(
                  "الوقت المتبقي على الصلاة: $remainingTime",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24), // المسافة بين النص والخط
                Container(
                  height: 2,  // سماكة الخط
                  color: Colors.grey, // لون الخط
                ),
              ],
            ),
        ],
      ),
    );
  }
}
