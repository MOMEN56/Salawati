import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:salawati/models/prayers_model.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';
import 'package:salawati/services/prayer_api.dart'; // استيراد PrayerApi


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
      var times =
          await _prayerApi.fetchPrayerTimes('16-11-2024', '31.2156', '29.9553');
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
      calculateRemainingTime(); // حساب الوقت المتبقي على الصلاة القادمة بعد تحميل الأوقات
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
    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        Duration remainingDuration = prayerDateTime.difference(now);
        setState(() {
          remainingTime =
              formatDuration(remainingDuration); // تنسيق الوقت المتبقي
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
        padding:
            const EdgeInsets.only(right: 16, left: 16, top: 28, bottom: 18),
        child: Column(
          children: [
            if (isLoading)
              const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD8BC78))),
            if (!isLoading)
              Expanded(
                child: Prayers(
                  prayerTimes: prayerTimes,
                ),
              ),
            if (remainingTime.isNotEmpty) // فقط إذا كان الوقت المتبقي موجودًا
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Text(
                      "الوقت المتبقي على الصلاة: $remainingTime",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 28), // المسافة بين النص والخط
                    Container(
                      height: 2, // سماكة الخط
                      color: Colors.grey, // لون الخط
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 35),
            const QuranicVerse(),
          ],
        ),
      ),
    );
  }
}
