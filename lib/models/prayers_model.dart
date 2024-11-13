import 'package:flutter/material.dart';

class Prayers extends StatelessWidget {
  final List<Map<String, String>> prayerTimes;

  const Prayers({super.key, required this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prayerTimes.map((prayer) {
        return Column(
          children: [
            Align(
              alignment: Alignment.center, // محاذاة الوقت في المنتصف
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start, // تأكيد المحاذاة على اليسار
                children: [
                  Text(
                    prayer['time']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 40), // مسافة بين الوقت واسم الصلاة
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight, // محاذاة أسماء الصلوات إلى اليمين
                      child: Text(
                        prayer['prayerName']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8), // مسافة بين النص والخط
            Container(
              height: 2, // سماكة الخط
              color: Colors.grey, // لون الخط
            ),
            const SizedBox(height: 16), // مسافة بين الأقسام
          ],
        );
      }).toList(),
    );
  }
}
