String formatDuration(Duration duration) {
  String hours = duration.inHours > 0
      ? (duration.inHours == 1
          ? "ساعة"
          : (duration.inHours == 2
              ? "ساعتان"
              : "${duration.inHours} ساعات"))
      : "";

  String minutes = duration.inMinutes.remainder(60) > 0
      ? (duration.inMinutes.remainder(60) == 1
          ? "دقيقة"
          : (duration.inMinutes.remainder(60) == 2
              ? "دقيقتان"
              : (duration.inMinutes.remainder(60) >= 3 && duration.inMinutes.remainder(60) <= 10
                  ? "${duration.inMinutes.remainder(60)} دقائق"
                  : "${duration.inMinutes.remainder(60)} دقيقة")))
      : "";
 if(duration.inHours >0&&duration.inMinutes>0)
  return "$hours و $minutes".trim();
 else if(duration.inHours >0&&duration.inMinutes==0)
  return "$hours".trim();
  else 
  return "$hours $minutes".trim();

}
