import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:salawati/services/prayer_times.dart';

class PrayerTimesService {
  final Dio _dio = Dio();

  Future<List<Map<String, String>>> fetchPrayerTimesForMonth() async {
    List<Map<String, String>> allPrayerTimes = [];
    DateTime now = DateTime.now();

    // تحديد بداية ونهاية الشهر الحالي
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // تحميل مواقيت الصلاة لجميع الأيام في الشهر
    for (DateTime date = firstDayOfMonth; date.isBefore(lastDayOfMonth); date = date.add(Duration(days: 1))) {
      String currentDate = DateFormat('dd-MM-yyyy').format(date);

      String url = 'https://api.aladhan.com/v1/timings/$currentDate';
      final Map<String, dynamic> queryParameters = {
        'latitude': 31.2156,
        'longitude': 29.9553,
        'method': 5,
      };

      try {
        final response = await _dio.get(url, queryParameters: queryParameters);
        
        if (response.statusCode == 200 && response.data != null && response.data['data'] != null) {
          final data = response.data['data']['timings'];

          if (data != null) {
            allPrayerTimes.add({
              "date": currentDate,
              "Fajr": data['Fajr'],
              "Sunrise": data['Sunrise'],
              "Dhuhr": data['Dhuhr'],
              "Asr": data['Asr'],
              "Maghrib": data['Maghrib'],
              "Isha": data['Isha'],
            });
          }
        }
      } catch (e) {
        print("Error fetching prayer times for $currentDate: $e");
      }
    }

    return allPrayerTimes;
  }
}
