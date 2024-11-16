// lib/services/time_calculator.dart
import 'package:intl/intl.dart';  // لتنسيق الوقت

class TimeCalculator {
  // دالة لتحويل الوقت إلى DateTime
  static DateTime parsePrayerTime(String timeString) {
    try {
      return DateFormat("HH:mm").parse(timeString);  // استخدام 24 ساعة
    } catch (e) {
      print("Error parsing time: $timeString");
      rethrow;
    }
  }

  // دالة لحساب الوقت المتبقي على الصلاة القادمة
  static String calculateRemainingTime(List<Map<String, String>> prayerTimes) {
    DateTime now = DateTime.now();  // الوقت الحالي
    List<DateTime> prayerDateTimes = [];

    // تحويل أوقات الصلاة إلى DateTime
    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        try {
          DateTime prayerTime = parsePrayerTime(timeString);  // استخدام دالة تحويل الوقت
          DateTime prayerDateTime = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
          prayerDateTimes.add(prayerDateTime);
        } catch (e) {
          print("Error parsing time: ${prayer['time']}");
        }
      }
    }

    // تصفية أوقات الصلاة التي لم تأتي بعد
    prayerDateTimes.sort((a, b) => a.compareTo(b));

    // إيجاد أقرب صلاة قادمة
    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        Duration remainingDuration = prayerDateTime.difference(now);
        return formatDuration(remainingDuration);  // تنسيق الوقت المتبقي
      }
    }

    return "";  // إذا لم يكن هناك وقت متبقي، نرجع قيمة فارغة
  }

  // دالة لتنسيق مدة الوقت المتبقي إلى ساعات ودقائق
  static String formatDuration(Duration duration) {
    String hours = duration.inHours > 0 ? "${duration.inHours} ساعة" : "";
    String minutes = duration.inMinutes.remainder(60) > 0
        ? "${duration.inMinutes.remainder(60)} دقيقة"
        : "";
    return "$hours $minutes".trim();
  }
}
