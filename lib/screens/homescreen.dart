import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';
import 'package:salawati/services/prayer_api.dart'; // استيراد PrayerApi
import 'package:salawati/models/prayers_model.dart'; // استيراد PrayerApi
import 'package:salawati/widgits/time_remaining_widget.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> prayerTimes = [];
  bool isLoading = true;
  String remainingTime = ""; // لحفظ الوقت المتبقي على الصلاة القادمة

  final PrayerApi _prayerApi = PrayerApi(Dio()); // استخدام PrayerApi

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    try {
      var times = await _prayerApi.fetchPrayerTimes('16-11-2024', '31.2156', '29.9553');
      setState(() {
        prayerTimes = [
          {"time": times['Fajr']!, "prayerName": "الفجر"},
          {"time": times['Sunrise']!, "prayerName": "الشروق"},
          {"time": times['Dhuhr']!, "prayerName": "الظهر"},
          {"time": times['Asr']!, "prayerName": "العصر"},
          {"time": times['Maghrib']!, "prayerName": "المغرب"},
          {"time": times['Isha']!, "prayerName": "العشاء"},
        ];
        isLoading = false;
      });
      calculateRemainingTime(); // حساب الوقت المتبقي بعد تحميل الأوقات
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching prayer times: $e');
    }
  }

  // دالة لحساب الوقت المتبقي على الصلاة القادمة
  void calculateRemainingTime() {
    DateTime now = DateTime.now(); // الوقت الحالي
    List<DateTime> prayerDateTimes = [];

    // تحويل أوقات الصلاة إلى DateTime
    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        try {
          // تحويل الوقت إلى DateTime
          DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
          DateTime prayerDateTime = DateTime(
              now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
          prayerDateTimes.add(prayerDateTime);
        } catch (e) {
          print("Error parsing time: ${prayer['time']}");
        }
      }
    }

    // تصفية أوقات الصلاة التي لم تأتي بعد
    prayerDateTimes.sort((a, b) => a.compareTo(b));

    // إيجاد أقرب صلاة قادمة
    bool allPrayersPassed = true;
    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        allPrayersPassed = false; // إذا كانت هناك صلاة لم تنتهي بعد
        Duration remainingDuration = prayerDateTime.difference(now);
        setState(() {
          remainingTime =
              formatDuration(remainingDuration); // تنسيق الوقت المتبقي
        });
        break;
      }
    }

    if (allPrayersPassed) {
      // إذا كانت جميع الصلوات قد انتهت، نبحث عن أول صلاة في اليوم التالي
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
            nextDayPrayerTimes.add(nextDayPrayerDateTime);
          } catch (e) {
            print("Error parsing time: ${prayer['time']}");
          }
        }
      }

      nextDayPrayerTimes.sort((a, b) => a.compareTo(b)); // ترتيب أوقات الصلاة للغد

      Duration remainingDuration = nextDayPrayerTimes.first.difference(now);
      setState(() {
        remainingTime =
            formatDuration(remainingDuration); // تنسيق الوقت المتبقي
      });
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
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD8BC78)),
                ),
              ),
            if (!isLoading)
              Expanded(
                child: Prayers(
                  prayerTimes: prayerTimes,
                ),
              ),
            if (remainingTime.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Text(
                      "الوقت المتبقي على الصلاة: $remainingTime",
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const QuranicVerse(),
          ],
        ),
      ),
    );
  }
}
