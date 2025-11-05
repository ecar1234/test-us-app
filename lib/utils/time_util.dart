class TimeUtil {
  String getDateTimeString(DateTime time, bool addTime){
    final year = time.year.toString();
    final month = time.month.toString().padLeft(2, '0');
    final day = time.day.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final second = time.second.toString().padLeft(2, '0');
    if(addTime) {
      return '$year.$month.$day $hour:$minute:$second';
    } else {
      return '$year.$month.$day';
    }
  }
}