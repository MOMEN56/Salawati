import 'package:flutter/material.dart';


class TimeFormatterWidget extends StatelessWidget {
  final String remainingTime;

  const TimeFormatterWidget({super.key, required this.remainingTime});

  // دالة لتحويل الوقت المتبقي لعرضه بشكل صحيح
  String convertRemainingTime(String time) {
    // تحديد أجزاء الوقت المتبقي
    List<String> parts = time.split(" ");
    String hours = parts[0];
    String minutes = parts[1];

    // تحويل الساعات والدقائق بناءً على القيمة
    String hourText = '';
    String minuteText = '';

    // تحديد النص المناسب للساعات
    if (int.parse(hours) > 2) {
      hourText = '$hours ساعات';
    } else if (int.parse(hours) == 1) {
      hourText = 'ساعة';
    } else if (int.parse(hours) == 2) {
      hourText = 'ساعتان';
    } else if (int.parse(hours) == 0) {
      hourText = '';
    }

    // تحديد النص المناسب للدقائق
    if (int.parse(minutes) == 1) {
      minuteText = 'دقيقة';
    } else if (int.parse(minutes) == 2) {
      minuteText = 'دقيقتان';
    } else if (int.parse(minutes) > 2) {
      minuteText = '$minutes دقائق';
    } else if (int.parse(minutes) == 0) {
      minuteText = '';
    }

    // دمج الساعات والدقائق معًا بشكل مناسب
    if (hourText.isNotEmpty && minuteText.isNotEmpty) {
      return '$hourText و $minuteText';
    } else {
      return '$hourText$minuteText';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "الوقت المتبقي على الصلاة: ${convertRemainingTime(remainingTime)}", // استخدام الدالة لتحويل الوقت
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
