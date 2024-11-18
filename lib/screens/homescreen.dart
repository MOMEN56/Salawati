import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:salawati/services/format_duration.dart';
import 'package:salawati/services/prayer_times.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';
import 'package:salawati/services/prayer_api.dart'; // استيراد PrayerApi
import 'package:salawati/models/prayers_model.dart'; // استيراد PrayerApi
import 'package:hive/hive.dart'; // استيراد Hive

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> prayerTimes = [];
  bool isLoading = true;
  bool hasError = false; // متغير لتتبع حالة الخطأ
  String remainingTime = ""; // لحفظ الوقت المتبقي على الصلاة القادمة

  final PrayerApi _prayerApi = PrayerApi(Dio()); // استخدام PrayerApi

  @override
  void initState() {
    super.initState();
    fetchPrayerTimes();
  }

  Future<void> fetchPrayerTimes() async {
    var box = await Hive.openBox('prayerTimesBox'); // فتح الـ Box

    // التحقق من وجود البيانات المخزنة
    var storedPrayerTimes = box.get('prayerTimes');
    if (storedPrayerTimes != null) {
      setState(() {
        prayerTimes = List<Map<String, String>>.from(storedPrayerTimes);
        isLoading = false;
        hasError = false;
      });
      calculateRemainingTime(); // حساب الوقت المتبقي بعد تحميل الأوقات
    } else {
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
          hasError = false;
        });

        savePrayerTimesToHive(); // حفظ البيانات في Hive
        calculateRemainingTime(); // حساب الوقت المتبقي بعد تحميل الأوقات
      } catch (e) {
        setState(() {
          isLoading = false;
          hasError = true; // تحديد حالة الخطأ
        });
      }
    }
  }

  // حفظ بيانات الصلاة في Hive
  Future<void> savePrayerTimesToHive() async {
    var box = await Hive.openBox('prayerTimesBox');
    var prayerTimesList = prayerTimes.map((prayer) {
      return PrayerTime(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        fajr: prayer['time']!,
        sunrise: prayer['time']!,
        dhuhr: prayer['time']!,
        asr: prayer['time']!,
        maghrib: prayer['time']!,
        isha: prayer['time']!,
      );
    }).toList();
    await box.put('prayerTimes', prayerTimesList);
  }

  // دالة لحساب الوقت المتبقي على الصلاة القادمة
  void calculateRemainingTime() {
    DateTime now = DateTime.now(); // الوقت الحالي
    List<DateTime> prayerDateTimes = [];

    // تحويل أوقات الصلاة إلى DateTime
    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        // تحويل الوقت إلى DateTime
        DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
        DateTime prayerDateTime = DateTime(
            now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
        prayerDateTimes.add(prayerDateTime);
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
          DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
          DateTime nextDayPrayerDateTime = DateTime(nextDay.year,
              nextDay.month, nextDay.day, prayerTime.hour, prayerTime.minute);
          nextDayPrayerTimes.add(nextDayPrayerDateTime);
        }
      }

      nextDayPrayerTimes
          .sort((a, b) => a.compareTo(b)); // ترتيب أوقات الصلاة للغد

      Duration remainingDuration = nextDayPrayerTimes.first.difference(now);
      setState(() {
        remainingTime =
            formatDuration(remainingDuration); // تنسيق الوقت المتبقي
      });
    }
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
            if (!isLoading && hasError)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "حدث خطأ أثناء جلب البيانات. يرجى المحاولة لاحقًا.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                            hasError = false;
                          });
                          fetchPrayerTimes(); // إعادة المحاولة
                        },
                        child: const Text("إعادة المحاولة"),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isLoading && !hasError)
              Expanded(
                child: Prayers(
                  prayerTimes: prayerTimes,
                ),
              ),
            if (remainingTime.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'الوقت المتبقي للصلاة القادمة: $remainingTime',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
