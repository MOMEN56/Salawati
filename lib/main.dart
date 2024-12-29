import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salawati/screens/homescreen.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const Salawati(),
    ),
  );
}

class Salawati extends StatelessWidget {
  const Salawati({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Amiri-Regular',
        ),
        home: const Homescreen(),
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
