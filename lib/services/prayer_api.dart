
import 'package:dio/dio.dart';

class PrayerApi {
  final Dio dio;

  PrayerApi(this.dio);

  Future<Map<String, String>> fetchPrayerTimes(String date, String latitude, String longitude) async {
    try {
      final response = await dio.get(
        'https://api.aladhan.com/v1/timings/$date',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': '5', // طريقة حساب أوقات الصلاة
        },
      );

      var data = response.data['data']['timings'];
      return {
        "Fajr": data['Fajr'],
        "Dhuhr": data['Dhuhr'],
        "Asr": data['Asr'],
        "Maghrib": data['Maghrib'],
        "Isha": data['Isha'],
        "Sunrise": data['Sunrise'],
      };
    } catch (e) {
      print('Error fetching prayer times: $e');
      rethrow;
    }
  }
}
