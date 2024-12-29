import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:salawati/main.dart';

class TimeCalculator {
  static String formatTime12Hour(String timeString) {
    try {
      final DateTime dateTime = DateFormat("HH:mm").parse(timeString);
      String formattedTime = DateFormat("hh:mm a").format(dateTime);
      formattedTime = formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');
      return formattedTime;
    } catch (e) {
      return timeString;
    }
  }

  static String formatHourString(int hour) {
    if (hour == 1) {
      return 'ساعة';
    } else if (hour == 2) {
      return 'ساعتين';
    } else {
      return '$hour ساعات';
    }
  }

  static String formatMinuteString(int minute) {
    if (minute == 1) {
      return 'دقيقة';
    } else if (minute == 2) {
      return 'دقيقتين';
    } else if (minute > 10) {
      return '$minute دقيقة';
    } else {
      return '$minute دقائق';
    }
  }

  static String calculateRemainingTime(List<Map<String, String>> prayerTimes) {
    DateTime now = DateTime.now();
    List<DateTime> prayerDateTimes = [];

    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
        DateTime prayerDateTime = DateTime(
            now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
        prayerDateTimes.add(prayerDateTime);
      }
    }

    prayerDateTimes.sort((a, b) => a.compareTo(b));

    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        Duration remainingDuration = prayerDateTime.difference(now);
        String formattedTime = formatTime12Hour(prayerDateTime.toString());
        String hourString = formatHourString(remainingDuration.inHours);
        String minuteString =
            formatMinuteString(remainingDuration.inMinutes.remainder(60));
        return "الوقت المتبقي على الصلاة القادمة: $hourString و $minuteString، وقت الصلاة القادمة: $formattedTime";
      }
    }

    DateTime nextDay = now.add(const Duration(days: 1));
    List<DateTime> nextDayPrayerTimes = [];

    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
        DateTime nextDayPrayerDateTime = DateTime(nextDay.year, nextDay.month,
            nextDay.day, prayerTime.hour, prayerTime.minute);
        nextDayPrayerTimes.add(nextDayPrayerDateTime);
      }
    }

    nextDayPrayerTimes.sort((a, b) => a.compareTo(b));

    Duration remainingDuration = nextDayPrayerTimes.first.difference(now);
    String formattedTime =
        formatTime12Hour(nextDayPrayerTimes.first.toString());
    String hourString = formatHourString(remainingDuration.inHours);
    String minuteString =
        formatMinuteString(remainingDuration.inMinutes.remainder(60));
    return "الوقت المتبقي على الصلاة القادمة: $hourString و $minuteString، وقت الصلاة القادمة في اليوم التالي: $formattedTime";
  }
}
