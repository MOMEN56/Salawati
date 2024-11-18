import 'package:hive/hive.dart';

part 'prayer_times.g.dart';

@HiveType(typeId: 0)
class PrayerTime {
  @HiveField(0)
  final String time;

  @HiveField(1)
  final String prayerName;

  PrayerTime({
    required this.time,
    required this.prayerName,
  });
}
