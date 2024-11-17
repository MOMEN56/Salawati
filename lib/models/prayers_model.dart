import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // استيراد Intl لتنسيق الوقت

class Prayers extends StatelessWidget {
  final List<Map<String, String>> prayerTimes;

  const Prayers({super.key, required this.prayerTimes});

  // دالة لتحويل الوقت إلى تنسيق 12 ساعة مع إضافة "ص" أو "م"
  String formatTime12Hour(String time) {
    try {
      DateTime dateTime = DateFormat("HH:mm").parse(time); // تحويل الوقت من 24 إلى 12 ساعة
      String formattedTime = DateFormat("hh:mm a").format(dateTime); // تنسيق الوقت بتنسيق 12 ساعة
      // تحويل "AM" و "PM" إلى "ص" و "م"
      formattedTime = formattedTime.replaceAll("AM", "ص").replaceAll("PM", "م");
      return formattedTime;
    } catch (e) {
      print("Error formatting time: $e");
      return time; // إرجاع الوقت كما هو في حالة حدوث خطأ
    }
  }

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
                    formatTime12Hour(prayer['time']!), // استخدام الدالة لتحويل الوقت إلى 12 ساعة
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
            const SizedBox(height: 24), // مسافة بين النص والخط
            Container(
              height: 2, // سماكة الخط
              color: Colors.grey, // لون الخط
            ),
            const SizedBox(height: 24), // مسافة بين الأقسام
          ],
        );
      }).toList(),
    );
  }
}
