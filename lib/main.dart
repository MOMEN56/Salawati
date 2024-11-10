import 'package:flutter/material.dart';

void main() {
  runApp(const Salawati());
}

class Salawati extends StatelessWidget {
  const Salawati({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.center,
            child: Text(
              "صلوات المسلم",
              style: TextStyle(
                fontFamily: 'Amiri-Regular', 
                fontSize: 28,
              ),
            ),
          ),
        ),
          ),
    );
  }
}
