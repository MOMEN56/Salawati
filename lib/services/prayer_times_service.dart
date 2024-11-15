import 'package:dio/dio.dart';

class PrayerTimesService {
  final Dio _dio = Dio();

  Future<List<Map<String, String>>> fetchPrayerTimes() async {
    final String url = 'https://api.aladhan.com/v1/timings/16-11-2024'; // تحديد التاريخ
    final Map<String, dynamic> queryParameters = {
      'latitude': 31.2156,  // إحداثيات خط العرض
      'longitude': 29.9553, // إحداثيات خط الطول
      'method': 5, // طريقة الحساب (حسب الطريقة المصرية)
    };

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final data = response.data['data']['timings'];
        return [
          {"time": data['Fajr'], "prayerName": "الفجر"},
          {"time": data['Sunrise'], "prayerName": "الشروق"},
          {"time": data['Dhuhr'], "prayerName": "الظهر"},
          {"time": data['Asr'], "prayerName": "العصر"},
          {"time": data['Maghrib'], "prayerName": "المغرب"},
          {"time": data['Isha'], "prayerName": "العشاء"},
        ];
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
