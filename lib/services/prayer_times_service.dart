import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ

class PrayerTimesService {
  final Dio _dio = Dio();

  
  Future<List<Map<String, String>>> fetchPrayerTimes() async {
    
    String currentDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

     String url = 'https://api.aladhan.com/v1/timings/$currentDate'; // تحديد التاريخ بناءً على التاريخ الحالي
    final Map<String, dynamic> queryParameters = {
      'latitude': 31.2156, 
      'longitude': 29.9553, 
      'method': 5, 
    };

    try {
      final response = await _dio.get(url, queryParameters: queryParameters);

      // التأكد من نجاح الاستجابة
      if (response.statusCode == 200 && response.data != null && response.data['data'] != null) {
        final data = response.data['data']['timings'];

        // التحقق من وجود كل وقت
        if (data != null) {
          return [
            {"time": data['Fajr'], "prayerName": "الفجر"},
            {"time": data['Sunrise'], "prayerName": "الشروق"},
            {"time": data['Dhuhr'], "prayerName": "الظهر"},
            {"time": data['Asr'], "prayerName": "العصر"},
            {"time": data['Maghrib'], "prayerName": "المغرب"},
            {"time": data['Isha'], "prayerName": "العشاء"},
          ];
        } else {
          throw Exception('بيانات أوقات الصلاة غير موجودة');
        }
      } else {
        throw Exception('فشل في جلب أوقات الصلاة');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('خطأ: ${e.response?.statusCode}, ${e.response?.data}');
      } else {
        throw Exception('خطأ: ${e.message}');
      }
    }
  }
}
