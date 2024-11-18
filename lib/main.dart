import 'package:flutter/material.dart';
import 'package:salawati/screens/homescreen.dart';

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
      home:const Homescreen(),
    );
  }
}
