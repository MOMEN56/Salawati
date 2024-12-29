import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuranicVerse extends StatelessWidget {
  const QuranicVerse({super.key});

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height * 0.02;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "﴾",
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 4),
            Text(
              "إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَوْقُوتًا",
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 4),
            Text(
              "﴿",
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 2),
            Text(
              ":",
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(width: 2),
            Text(
              "قال تعالى",
              style: TextStyle(fontSize: fontSize),
            ),
          ],
        ),
      ],
    );
  }
}
