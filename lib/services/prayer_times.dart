import 'package:hive/hive.dart';

part 'prayer_times.g.dart';  // لا تنسى هذا السطر

@HiveType(typeId: 0)
class PrayerTime {
  @HiveField(0)
  final String date; // إضافة التاريخ
  @HiveField(1)
  final String fajr;
  @HiveField(2)
  final String sunrise;
  @HiveField(3)
  final String dhuhr;
  @HiveField(4)
  final String asr;
  @HiveField(5)
  final String maghrib;
  @HiveField(6)
  final String isha;

  PrayerTime({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}
