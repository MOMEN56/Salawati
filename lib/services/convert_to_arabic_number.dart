String convertToArabicNumber(String number) {
    String res = '';

    // الأرقام العربية
    final arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    // التكرار عبر الأرقام في النص
    for (int i = 0; i < number.length; i++) {
      String element = number[i];
      if (element.contains(RegExp(r'[0-9]'))) { // التحقق من أن العنصر هو رقم
        int index = int.parse(element); // تحويل الرقم إلى فهرس
        res += arabics[index]; // إضافة الرقم العربي
      } else {
        res += element; // إضافة أي حرف آخر كما هو
      }
    }

    return res;
  }
