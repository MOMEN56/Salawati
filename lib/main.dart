import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:salawati/screens/homescreen.dart';  // استيراد المكتبة الصحيحة

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Hive.initFlutter();  
  runApp(const Salawati());
}

class Salawati extends StatelessWidget {
  const Salawati({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Amiri-Regular',
      ),
      home: const Homescreen(),  // تأكد من أنك تستخدم هذا فقط
    );
  }
}
