import 'package:dio/dio.dart';

class PrayerApi {
  final Dio _dio;

  PrayerApi(this._dio);

  Future<Map<String, String>> fetchPrayerTimes(String date, String latitude, String longitude) async {
    final String url = 'https://api.aladhan.com/v1/timings/$date'; // تحديد التاريخ
    final Map<String, dynamic> queryParameters = {
      'latitude': latitude,  // إحداثيات خط العرض
      'longitude': longitude, // إحداثيات خط الطول
      'method': 5, // طريقة الحساب (حسب الطريقة المصرية)
    };

    try {
      final response = await _dio.get(url, queryParameters: queryParameters); // استخدام _dio هنا

      if (response.statusCode == 200) {
        final data = response.data['data']['timings'];
        return {
          'Fajr': data['Fajr'],
          'Sunrise': data['Sunrise'],
          'Dhuhr': data['Dhuhr'],
          'Asr': data['Asr'],
          'Maghrib': data['Maghrib'],
          'Isha': data['Isha'],
        };
      } else {
        throw Exception('فشل في جلب أوقات الصلاة');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('خطأ: ${e.response?.statusCode}, ${e.response?.data}');
      } else {
        throw Exception('خطأ: ${e.message}');
      }
    }
  }
}
