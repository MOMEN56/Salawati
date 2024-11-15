import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart'; // لتنسيق الوقت
import 'package:salawati/models/prayers_model.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';

void main() {
  runApp(const MaterialApp(home: Homescreen()));
}

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> prayerTimes = [];
  bool isLoading = true;
  String remainingTime = "";  // لحفظ الوقت المتبقي على الصلاة القادمة

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    try {
      var dio = Dio();
      final response = await dio.get(
        'https://api.aladhan.com/v1/timings/16-11-2024',
        queryParameters: {
          'latitude': '31.2156',
          'longitude': '29.9553',
          'method': '5',
        },
      );

      var data = response.data['data']['timings'];
      setState(() {
        prayerTimes = [
          {"time": data['Fajr'], "prayerName": "الفجر"},
          {"time": data['Dhuhr'], "prayerName": "الظهر"},
          {"time": data['Asr'], "prayerName": "العصر"},
          {"time": data['Maghrib'], "prayerName": "المغرب"},
          {"time": data['Isha'], "prayerName": "العشاء"},
          {"time": data['Sunrise'], "prayerName": "الشروق"},
          {"time": "00", "prayerName": "الوقت المتبقي علي الصلاة"},
        ];
        isLoading = false;
        calculateRemainingTime();  // حساب الوقت المتبقي على الصلاة القادمة بعد تحميل الأوقات
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching prayer times: $e');
    }
  }

  // دالة لحساب الوقت المتبقي على الصلاة القادمة
  void calculateRemainingTime() {
    DateTime now = DateTime.now();  // الوقت الحالي
    List<DateTime> prayerDateTimes = [];

    // تحويل أوقات الصلاة إلى DateTime
    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var time = prayer['time']!;
        DateTime prayerTime = DateFormat("hh:mm a").parse(time);  // تحويل الوقت من نص إلى DateTime
        DateTime prayerDateTime = DateTime(now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
        prayerDateTimes.add(prayerDateTime);
      }
    }

    // تصفية أوقات الصلاة التي لم تأتي بعد
    prayerDateTimes.sort((a, b) => a.compareTo(b));

    // إيجاد أقرب صلاة قادمة
    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        Duration remainingDuration = prayerDateTime.difference(now);
        setState(() {
          remainingTime = formatDuration(remainingDuration);  // تنسيق الوقت المتبقي
        });
        break;
      }
    }
  }

  // دالة لتنسيق مدة الوقت المتبقي إلى ساعات ودقائق
  String formatDuration(Duration duration) {
    String hours = duration.inHours > 0 ? "${duration.inHours} ساعة" : "";
    String minutes = duration.inMinutes.remainder(60) > 0
        ? "${duration.inMinutes.remainder(60)} دقيقة"
        : "";
    return "$hours $minutes".trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16, top: 28, bottom: 18),
        child: Column(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
            if (!isLoading)
              Expanded(
                child: Prayers(
                  prayerTimes: prayerTimes,
                ),
              ),
            SizedBox(height: 20),
            if (remainingTime.isNotEmpty)
              Text(
                "الوقت المتبقي على الصلاة القادمة: $remainingTime",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            const QuranicVerse(),
          ],
        ),
      ),
    );
  }
}
