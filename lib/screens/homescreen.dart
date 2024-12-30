import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:salawati/services/format_duration.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';
import 'package:salawati/services/prayer_api.dart';
import 'package:salawati/models/prayers_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Map<String, String>> prayerTimes = [];
  bool isLoading = true;
  bool hasError = false;
  String remainingTime = "";
  bool isConnected = true;

  final PrayerApi _prayerApi = PrayerApi(Dio());

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    fetchPrayerTimes();
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> fetchPrayerTimes() async {
    try {
      var times =
          await _prayerApi.fetchPrayerTimes('18-12-2024', '31.2156', '29.9553');
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
      calculateRemainingTime();
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print('Error fetching prayer times: $e');
    }
  }

  void calculateRemainingTime() {
    DateTime now = DateTime.now();
    List<DateTime> prayerDateTimes = [];

    for (var prayer in prayerTimes) {
      if (prayer['time'] != "00") {
        var timeString = prayer['time']!;
        try {
          DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
          DateTime prayerDateTime = DateTime(
              now.year, now.month, now.day, prayerTime.hour, prayerTime.minute);
          prayerDateTimes.add(prayerDateTime);
        } catch (e) {
          print("Error parsing time: ${prayer['time']}");
        }
      }
    }

    prayerDateTimes.sort((a, b) => a.compareTo(b));

    bool allPrayersPassed = true;
    for (var prayerDateTime in prayerDateTimes) {
      if (prayerDateTime.isAfter(now)) {
        allPrayersPassed = false;
        Duration remainingDuration = prayerDateTime.difference(now);
        setState(() {
          remainingTime = formatDuration(remainingDuration);
        });
        break;
      }
    }

    if (allPrayersPassed) {
      DateTime nextDay = now.add(const Duration(days: 1));
      List<DateTime> nextDayPrayerTimes = [];

      for (var prayer in prayerTimes) {
        if (prayer['time'] != "00") {
          var timeString = prayer['time']!;
          try {
            DateTime prayerTime = DateFormat("HH:mm").parse(timeString);
            DateTime nextDayPrayerDateTime = DateTime(nextDay.year,
                nextDay.month, nextDay.day, prayerTime.hour, prayerTime.minute);
            nextDayPrayerTimes.add(nextDayPrayerDateTime);
          } catch (e) {
            print("Error parsing time: ${prayer['time']}");
          }
        }
      }

      nextDayPrayerTimes.sort((a, b) => a.compareTo(b));

      Duration remainingDuration = nextDayPrayerTimes.first.difference(now);
      setState(() {
        remainingTime = formatDuration(remainingDuration);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding:
EdgeInsets.only(
  right: MediaQuery.of(context).size.height * 0.02,
  left: MediaQuery.of(context).size.height * 0.02,
  top: MediaQuery.of(context).size.height * 0.04,
  bottom: MediaQuery.of(context).size.height * 0.02,
),
        child: Column(
          children: [
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFFD8BC78)),
                ),
              ),
            if (!isLoading && !hasError)
              Expanded(
                child: Prayers(
                  prayerTimes: prayerTimes,
                ),
              ),
            if (hasError)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.wifi_off,
                        color: Colors.red,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'حدث خطأ أثناء جلب البيانات\n، تحقق من الاتصال بالإنترنت.',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.red,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          hasError = false;
                        });
                        fetchPrayerTimes();
                      },
                      child: Text(
                        'إعادة المحاولة',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!isLoading && remainingTime.isNotEmpty)
              Column(
                children: [
                  Center(
                    child: Text(
                      "الوقت المتبقي على الصلاة: $remainingTime",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.021,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.006),
                  Container(
                   height: MediaQuery.of(context).size.height * 0.003,
                    color: Colors.grey,
                  ),
                ],
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0190),
            const QuranicVerse(),
          ],
        ),
      ),
    );
  }
}