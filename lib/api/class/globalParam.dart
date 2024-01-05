import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/api/response/countPerCountReportResp.dart';
import 'package:ogawa_nec/api/response/deliveryConfirmationResp.dart';
import 'package:ogawa_nec/api/response/reportTransportTaskResp.dart';
import 'package:ogawa_nec/api/response/moveToNewLocationResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

class ApiProxyParameter {
  static String host = 'http://172.28.19.60:8088/TOMYWebService/';
  static String dbHost = '172.28.19.53';
  static int dbPort = 1521;
  static String dbName = 'OGW10';
  static String userLogin = "";
  static String passLogin = "";
  static String settingName = "TEST";
  static ApiSettings apiData = ApiSettings();
  static List<CommonResp> partNo = [];
  static List<CommonResp> partLocationNo = [];
  static List<CommonResp> partLotNo = [];
  static List<CommonResp> splPartNo = [];
  static List<CommonResp> splPartLocationNo = [];
  static List<CommonResp> splPartLotNo = [];
  static List<CountPerCountReportResp> dataListF = [];
  static List<CountPerCountReportResp> dataListFBarcodeId = [];
  static List<DeliveryConfirmationResp> dataListK = [];
  static List<DeliveryConfirmationResp> dataListKCustBarcode = [];
  static List<reportTransportTaskResp> dataListG = [];
  static List<reportTransportTaskResp> dataListGCustBarcode = [];
  static List<moveToNewLocationResp> dataListJCustBarcodeFrom = [];
  static List<moveToNewLocationResp> dataListJCustBarcodeTo = [];
  static int countBarcodeToFrom = 0;
  static String jBarcodeFrom = '';
  static String jBarcodeTo = '';
  static String dataBaseSelect = '';
}

class AppVersionClass {
  static String appVersion = "1.0.3";
}
