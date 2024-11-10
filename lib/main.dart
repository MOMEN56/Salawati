import 'package:flutter/material.dart';

void main() {
  runApp(const Salawati());
}

class Salawati extends StatelessWidget {
  const Salawati({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('صلواتي'),
        ),
        body: const Center(
          child: Text('Welcome to Salawati!'),
        ),
      ),
    );
  }
}
