import 'package:intl/intl.dart';

class TimeCalculator {
  // دالة لتحويل الوقت إلى تنسيق 12 ساعة
  static String formatTime12Hour(String timeString) {
    try {
      final DateTime dateTime = DateFormat("HH:mm").parse(timeString); // تحويل الوقت من 24 ساعة إلى 12 ساعة
      String formattedTime = DateFormat("hh:mm a").format(dateTime); // تنسيق الوقت بصيغة 12 ساعة
      // استبدال AM بـ "ص" و PM بـ "م"
      formattedTime = formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');
      return formattedTime;
    } catch (e) {
      print("Error formatting time: $e");
      return timeString; // إرجاع الوقت كما هو إذا حدث خطأ
    }
  }

  // دالة لتحويل الساعة إلى صيغة عربية بدون الأرقام
  static String formatHourString(int hour) {
    if (hour == 1) {
      return 'ساعة';
    } else if (hour == 2) {
      return 'ساعتين';
    } else {
      return '$hour ساعات';
    }
  }

  // دالة لتحويل الدقائق إلى صيغة عربية بدون الأرقام
  static String formatMinuteString(int minute) {
    if (minute == 1 || minute == 21 || minute == 31 || minute == 41 || minute == 51) {
      return 'دقيقة';
    } else if (minute == 2 || minute == 22 || minute == 32 || minute == 42 || minute == 52) {
      return 'دقيقتين';
    } else {
      return '$minute دقائق';
    }
  }

  // دالة لحساب الوقت المتبقي على الصلاة القادمة
  static String calculateRemainingTime(List<Map<String, String>> prayerTimes) {
    DateTime now = DateTime.now(); // الوقت الحالي
    List<DateTime> prayerDateTimes = [];

    // تحويل أوقات الصلاة من البيانات وإضافتها إلى القائمة
    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        try {
          // تحويل الوقت إلى 24 ساعة أولًا
          DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
          DateTime prayerDateTime = DateTime(
              now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
          prayerDateTimes.add(prayerDateTime); // إضافة الوقت إلى القائمة
        } catch (e) {
          print("Error parsing time: ${prayer['time']}");
        }
      }
    }

    prayerDateTimes.sort((a, b) => a.compareTo(b)); // ترتيب أوقات الصلاة

    // البحث عن أول صلاة قادمة بعد الوقت الحالي
    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        Duration remainingDuration = prayerDateTime.difference(now);
        String formattedTime = formatTime12Hour(prayerDateTime.toString()); // استخدام التنسيق 12 ساعة
        String hourString = formatHourString(remainingDuration.inHours); // استخدام الدالة لتنسيق الساعة
        String minuteString = formatMinuteString(remainingDuration.inMinutes.remainder(60)); // تنسيق الدقائق
        return "الوقت المتبقي على الصلاة القادمة: $hourString و $minuteString، وقت الصلاة القادمة: $formattedTime";
      }
    }

    // إذا لم تكن هناك صلوات قادمة اليوم، احسب للغد
    DateTime nextDay = now.add(const Duration(days: 1)); // اليوم التالي
    List<DateTime> nextDayPrayerTimes = [];

    // تحويل أوقات الصلاة للغد
    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        try {
          DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
          DateTime nextDayPrayerDateTime = DateTime(nextDay.year, nextDay.month,
              nextDay.day, prayerTime.hour, prayerTime.minute);
          nextDayPrayerTimes.add(
              nextDayPrayerDateTime); // إضافة الوقت إلى قائمة أوقات الصلاة للغد
        } catch (e) {
          print("Error parsing time: ${prayer['time']}");
        }
      }
    }

    nextDayPrayerTimes
        .sort((a, b) => a.compareTo(b)); // ترتيب أوقات الصلاة للغد

    Duration remainingDuration = nextDayPrayerTimes.first.difference(now);
    String formattedTime = formatTime12Hour(nextDayPrayerTimes.first.toString()); // استخدام التنسيق 12 ساعة
    String hourString = formatHourString(remainingDuration.inHours); // تنسيق الساعة للغد
    String minuteString = formatMinuteString(remainingDuration.inMinutes.remainder(60)); // تنسيق الدقائق للغد
    return "الوقت المتبقي على الصلاة القادمة: $hourString و $minuteString، وقت الصلاة القادمة في اليوم التالي: $formattedTime";
  }
}
