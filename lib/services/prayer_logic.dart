import 'package:intl/intl.dart';

List<Map<String, String>> formatPrayerTimes(Map<String, String> times) {
  return [
    {"time": times['Fajr'] ?? "00:00", "prayerName": "الفجر"},
    {"time": times['Sunrise'] ?? "00:00", "prayerName": "الشروق"},
    {"time": times['Dhuhr'] ?? "00:00", "prayerName": "الظهر"},
    {"time": times['Asr'] ?? "00:00", "prayerName": "العصر"},
    {"time": times['Maghrib'] ?? "00:00", "prayerName": "المغرب"},
    {"time": times['Isha'] ?? "00:00", "prayerName": "العشاء"},
  ];
}

String getNextPrayerTime(List<Map<String, String>> prayerTimes) {
  DateTime now = DateTime.now();
  List<DateTime> prayerDateTimes = [];

  for (var prayer in prayerTimes) {
    try {
      DateTime prayerTime = DateFormat("HH:mm").parse(prayer['time']!);
      DateTime prayerDateTime = DateTime(
          now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
      prayerDateTimes.add(prayerDateTime);
    } catch (e) {
      print("Error parsing prayer time: ${prayer['time']}");
    }
  }

  prayerDateTimes.sort();
  for (var time in prayerDateTimes) {
    if (time.isAfter(now)) {
      Duration remaining = time.difference(now);
      return "${remaining.inHours} ساعة و ${remaining.inMinutes % 60} دقيقة";
    }
  }
  return "";
}
