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
  String getChatDateTimeString(DateTime time) {
    String period = time.hour >= 12 ? "오후" : "오전";

    // 12시간제로 변환 (0은 12로 처리)
    int displayHour = time.hour % 12;
    displayHour = displayHour == 0 ? 12 : displayHour;

    // 분이 한 자릿수일 경우 앞에 0 추가
    String displayMinute = time.minute.toString().padLeft(2, '0');

    return "$period $displayHour:$displayMinute";
  }
  String getChatRoomLastMessageAt(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return "오늘";
    } else if (messageDate == yesterday) {
      return "어제";
    } else {
      return "${date.year}년 ${date.month}월 ${date.day}일";
    }
  }
}