// lib/homescreen.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:salawati/models/prayers_model.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';
import 'package:salawati/services/prayer_api.dart';  // استيراد PrayerApi
import 'package:salawati/services/time_calculator.dart';  // استيراد TimeCalculator

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

  final PrayerApi _prayerApi = PrayerApi(Dio());  // استخدام PrayerApi

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
          {"time": times['Dhuhr']!, "prayerName": "الظهر"},
          {"time": times['Asr']!, "prayerName": "العصر"},
          {"time": times['Maghrib']!, "prayerName": "المغرب"},
          {"time": times['Isha']!, "prayerName": "العشاء"},
          {"time": times['Sunrise']!, "prayerName": "الشروق"},
        ];
        isLoading = false;
      });
      calculateRemainingTime();  // حساب الوقت المتبقي على الصلاة القادمة بعد تحميل الأوقات
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching prayer times: $e');
    }
  }

  // دالة لحساب الوقت المتبقي باستخدام TimeCalculator
  void calculateRemainingTime() {
    String time = TimeCalculator.calculateRemainingTime(prayerTimes);
    setState(() {
      remainingTime = time;
    });
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
            if (remainingTime.isNotEmpty)  // فقط إذا كان الوقت المتبقي موجودًا
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Text(
                      "الوقت المتبقي على الصلاة: $remainingTime",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 24),  // المسافة بين النص والخط
                    Container(
                      height: 2,  // سماكة الخط
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
