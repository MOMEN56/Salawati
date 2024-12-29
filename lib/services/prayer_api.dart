import 'package:dio/dio.dart';

class PrayerApi {
  final Dio dio;

  PrayerApi(this.dio);

  Future<Map<String, String>> fetchPrayerTimes(String date, String latitude, String longitude) async {
    try {
      final response = await dio.get(
        'https://api.aladhan.com/v1/timingsByCity',
        queryParameters: {
          'city': 'Alexandria',
          'country': 'Egypt',
          'method': 5,
        },
      );

      if (response.statusCode == 200) {
        return {
          'Fajr': response.data['data']['timings']['Fajr'],
          'Sunrise': response.data['data']['timings']['Sunrise'],
          'Dhuhr': response.data['data']['timings']['Dhuhr'],
          'Asr': response.data['data']['timings']['Asr'],
          'Maghrib': response.data['data']['timings']['Maghrib'],
          'Isha': response.data['data']['timings']['Isha'],
        };
      } else {
        throw Exception('فشل في جلب البيانات');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء جلب البيانات');
    }
  }
}
