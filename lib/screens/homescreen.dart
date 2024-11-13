import 'package:flutter/material.dart';
import 'package:salawati/models/prayers_model.dart';
import 'package:salawati/widgits/custom_app_bar.dart';

void main() {
  runApp(const MaterialApp(home: Homescreen()));
}

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.only(right: 16,left: 16,top: 28,bottom: 16),
        child: Prayers(   // تمرير البيانات هنا
          prayerTimes: [
            {"time": "00", "prayerName": "الوقت المتبقي علي الصلاة"},
            {"time": "00", "prayerName": "الفجر"},
            {"time": "00", "prayerName": "الشروق"},
            {"time": "00", "prayerName": "الظهر"},
            {"time": "00", "prayerName": "العصر"},
            {"time": "00", "prayerName": "المغرب"},
            {"time": "00", "prayerName": "العشاء"},
          ],
        ),
      ),
    );
  }
}