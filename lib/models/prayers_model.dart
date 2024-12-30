import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salawati/services/convert_to_arabic_number.dart';

class Prayers extends StatelessWidget {
  final List<Map<String, String>> prayerTimes;

  const Prayers({super.key, required this.prayerTimes});

  String formatTime12Hour(String time) {
    try {
      DateTime dateTime = DateFormat("HH:mm").parse(time);
      String formattedTime = DateFormat("h:mm a").format(dateTime);

      formattedTime = formattedTime.replaceAll('AM', 'ص').replaceAll('PM', 'م');

      return formattedTime;
    } catch (e) {
      print("Error formatting time: $e");
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prayerTimes.map((prayer) {
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    convertToArabicNumber(formatTime12Hour(prayer['time']!)),
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        prayer['prayerName']!,
                        style:  TextStyle(fontSize: MediaQuery.of(context).size.height * 0.033),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.027),
            Container(
                   height: MediaQuery.of(context).size.height * 0.003,
              color: Colors.grey,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ],
        );
      }).toList(),
    );
  }
}