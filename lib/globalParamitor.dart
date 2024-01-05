import 'package:ogawa_nec/api/response/getDataByShopBarcodeResp.dart';
import 'package:ogawa_nec/api/response/moveFromIQC_AQCResp.dart';
import 'package:ogawa_nec/api/response/purchaseOrderReceiveResp.dart';
import 'package:ogawa_nec/api/response/reportMaterialRequisitionResp.dart';

class GlobalParam {
  static String appVersion = "Ver.1.0.0";
  static String databaseName = "TEST";
  static String userId = "User01";
  static List<ReportMaterialRequisitionResp> dataListH = [];
  static List<ReportMaterialRequisitionResp> dataListHBarcode = [];
  static List<ReportMaterialRequisitionResp> dataListHReserve = [];
  static List<ReportMaterialRequisitionResp> dataListHRemain = [];
  static List<MoveFromIQC_AQCResp> dataListI = [];
  static List<PurchaseOrderReceiveResp> dataListN = [];
  static List<PurchaseOrderReceiveResp> dataListNBarcode = [];
  static double dataListNBarcodePurQty = 0;
  static double dataListNBarcodeInvQty = 0;
  static String menuKContainerNo = "";
  static GetDataByShopBarcodeResp oSelectProductionLine =
      GetDataByShopBarcodeResp();

  static DateTime reportTransportTaskAppliedDay = DateTime.now();
  static DateTime reportTransportTaskAppliedDaySave = DateTime.now();

  //----------Search hint N---------
  static int searchHintNIndex = 0;
  //----------Search hint K---------
  static int searchHintKIndex = 0;
  //-------------------------

}
