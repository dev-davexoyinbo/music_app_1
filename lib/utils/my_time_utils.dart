class MyTimeUtils {
  static String convertMillisecondsStringToTimeString(String milString) {
    Duration duration;
    try{
      duration = Duration(milliseconds: int.parse(milString));
    }catch(e){
      return "";
    }

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if(duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";

    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}