import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD8BC78), // تغيير لون الخلفية
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // لون الظل مع الشفافية
            blurRadius: 8,  // تأثير الضبابية للظل
            offset: const Offset(0,8),  // إزاحة الظل للأسفل
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,  // شفافية الخلفية داخل الـ AppBar
        elevation: 5,  // إزالة الظل الافتراضي من الـ AppBar
        title: const Align(
          alignment: Alignment.topCenter,  // محاذاة النص في الأعلى
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),  // تحريك النص للأعلى
            child: Text(
              "صلوات المسلم",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Amiri-Regular', // استخدام الخط المخصص
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);  // الحفاظ على الحجم الافتراضي للـ AppBar
}
