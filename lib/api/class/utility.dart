import 'package:intl/intl.dart';

class Utility {
  //Formate Number xx,xxx.00
  static String formatNumber(double _number) {
    String result;
    final formatNum = NumberFormat("#,###.##", "en_US");
    result = formatNum.format(_number);
    return result;
  }

  static String formNum(String s) {
    if (s.isEmpty) return '0';
    try {
      return NumberFormat.decimalPattern().format(
        int.parse(s),
      );
    } on Exception catch (_) {
      return '0';
    }
  }
}
