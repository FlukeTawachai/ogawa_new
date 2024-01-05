import 'package:intl/intl.dart';

class FormatData {
  var numberFormat1 = NumberFormat("#,###", "en_US");
  var numberFormat2 = NumberFormat("#,###.0#", "en_US");

  DateFormat dateFormat1 = DateFormat('dd/MM/yyyy');
  DateFormat dateFormat2 = DateFormat('yyyy-MM-dd');
  DateFormat dateFormat3 = DateFormat('dd/MM/yyyy HH:mm:ss');
  DateFormat dateFormat4 = DateFormat('yyyy-MM-dd HH:mm:ss');

  String intNumberFormat(double number) {
    return numberFormat1.format(number);
  }

  String doubleNumberFormat(double number) {
    return numberFormat2.format(number);
  }

  double stringToDouble(String str) {
    if (str == "") {
      str = "0";
    }
    var text = str.replaceAll(",", "");
    return double.parse(text);
  }

  String getDateFormat1(DateTime date) {
    return dateFormat1.format(date);
  }

  String getDateFormat2(DateTime date) {
    return dateFormat2.format(date);
  }

  String getDateFormat3(DateTime date) {
    return dateFormat3.format(date);
  }

  String getDateFormat4(DateTime date) {
    return dateFormat4.format(date);
  }
}
