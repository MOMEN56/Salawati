String convertToArabicNumber(String number) {
  String res = '';

  final arabics = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

  for (int i = 0; i < number.length; i++) {
    String element = number[i];
    if (element.contains(RegExp(r'[0-9]'))) {
      int index = int.parse(element);
      res += arabics[index];
    } else {
      res += element;
    }
  }

  return res;
}
