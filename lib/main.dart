import 'package:flutter/material.dart';
import 'package:salawati/screens/homescreen.dart';
import 'package:salawati/widgits/custom_app_bar.dart';

void main() {
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
      home: const Scaffold(
        body: Homescreen(),
      ),
    );
  }
}
