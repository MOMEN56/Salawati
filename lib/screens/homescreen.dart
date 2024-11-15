import 'package:flutter/material.dart';
import 'package:salawati/models/prayers_model.dart';
import 'package:salawati/widgits/custom_app_bar.dart';
import 'package:salawati/widgits/quranic_verse.dart';

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
        padding: EdgeInsets.only(right: 16, left: 16, top: 28, bottom: 18),
        child: Column(
          children: [
            Expanded(  // استخدام Expanded لتوزيع المحتوى بشكل متوازن
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
            SizedBox(height: 20), // مسافة بين الصلوات والآية القرآنية
            QuranicVerse(),
          ],
        ),
      ),
    );
  }
}
