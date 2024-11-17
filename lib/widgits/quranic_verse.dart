import 'package:flutter/material.dart';

class QuranicVerse extends StatelessWidget {
  const QuranicVerse({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min, // لتقليص العرض حسب المحتوى
          children: [
            Text(
              "﴾",
              style: TextStyle(fontSize: 14), // حجم الخط للقوس
            ),
            SizedBox(width: 4), // مسافة بين القوس والنص
            Text(
              "إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَوْقُوتًا",
              style: TextStyle(fontSize: 15), // حجم الخط للنص
            ),
            SizedBox(width: 4), // مسافة بين النص والقوس الآخر
            Text(
              "﴿",
              style: TextStyle(fontSize: 14), // حجم الخط للقوس الآخر
            ),
            SizedBox(width: 2),
            Text(
              ":",
              style: TextStyle(fontSize: 15), // حجم الخط لكلمة "قال تعالى"
            ),
            SizedBox(width: 2), // مسافة بين الآية وكلمة "قال تعالى"
            Text(
              "قال تعالى",
              style: TextStyle(fontSize: 15), // حجم الخط لكلمة "قال تعالى"
            ),
          ],
        ),
        //SizedBox(height: 4), // مسافة بين الأقسام
      ],
    );
  }
}
