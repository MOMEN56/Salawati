import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:salawati/screens/homescreen.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const Salawati(), // Wrap your app with DevicePreview
    ),
  );
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
      home: const Homescreen(),
      useInheritedMediaQuery: true, // Use DevicePreview's media query
      locale: DevicePreview.locale(context), // Get locale from DevicePreview
      builder: DevicePreview.appBuilder, // Apply DevicePreview's app builder
    );
  }
}
