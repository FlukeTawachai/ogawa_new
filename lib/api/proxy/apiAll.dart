import 'dart:convert';

import 'package:ogawa_nec/api/proxy/apiProxy.dart';
import 'package:ogawa_nec/api/request/commonReq.dart';
import 'package:ogawa_nec/api/request/countPerCountReportReq.dart';
import 'package:ogawa_nec/api/request/deliveryConfirmationReq.dart';
import 'package:ogawa_nec/api/request/getDataByShopBarcodeReq.dart';
import 'package:ogawa_nec/api/request/loginReq.dart';
import 'package:ogawa_nec/api/request/moveFromIQC_AQCReq.dart';
import 'package:ogawa_nec/api/request/purchaseOrderReceiveReq.dart';
import 'package:ogawa_nec/api/request/reportMaterialRequisitionReq.dart';
import 'package:ogawa_nec/api/request/shopOrderReceiveReq.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/api/response/countPerCountReportResp.dart';
import 'package:ogawa_nec/api/response/deliveryConfirmationResp.dart';
import 'package:ogawa_nec/api/response/getDataByShopBarcodeResp.dart';
import 'package:ogawa_nec/api/response/loginResp.dart';
import 'package:ogawa_nec/api/response/moveFromIQC_AQCResp.dart';
import 'package:ogawa_nec/api/response/purchaseOrderReceiveResp.dart';
import 'package:ogawa_nec/api/response/reportMaterialRequisitionResp.dart';
import 'package:ogawa_nec/api/response/shopOrderReceiveResp.dart';
import 'package:ogawa_nec/api/response/OgawaComResp.dart';
import 'package:ogawa_nec/api/request/ogawaComReq.dart';

class AllApiProxy extends ApiProxy {
  Future<LoginResponse?> login(String userName, String password) async {
    LoginRequest req = LoginRequest(userName: userName, passWord: password);

    print('Request to api/Common/Login');
    String? result;
    result =
        await processPostRequest('api/Common/Login', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      LoginResponse resp = LoginResponse();
      return resp;
    } else {
      LoginResponse resp = LoginResponse.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<List<CommonResp>> sppGetDataByPartNo(CommonReq req) async {
    print('Request to api/StockPerPart/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/StockPerPart/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CommonResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CommonResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<CommonResp>> sppGetDataByLocationNo(CommonReq req) async {
    print('Request to api/StockPerPart/GetDataByLocationNo');
    String? result;
    result = await processPostRequest(
        'api/StockPerPart/GetDataByLocationNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CommonResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CommonResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<CommonResp>> sppGetDataByLotNo(CommonReq req) async {
    print('Request to api/StockPerPart/GetDataByLotNo');
    String? result;
    result = await processPostRequest(
        'api/StockPerPart/GetDataByLotNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CommonResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CommonResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<CommonResp>> splGetDataByLocationNo(CommonReq req) async {
    print('Request to api/StockPerLocation/GetDataByLocationNo');
    String? result;
    result = await processPostRequest(
        'api/StockPerLocation/GetDataByLocationNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CommonResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CommonResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<CommonResp>> splGetDataByPartNo(CommonReq req) async {
    print('Request to api/StockPerLocation/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/StockPerLocation/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CommonResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CommonResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<CommonResp>> splGetDataByLotNo(CommonReq req) async {
    print('Request to api/StockPerLocation/GetDataByLotNo');
    String? result;
    result = await processPostRequest(
        'api/StockPerLocation/GetDataByLotNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CommonResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CommonResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<ShopOrderReceiveResp> getDataByShopBarcode(
      ShopOrderReceiveReq req) async {
    print('Request to api/ShopOrderFg/GetDataByShopBarcode');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderFg/GetDataByShopBarcode', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = ShopOrderReceiveResp(errorMessage: "Shop Barcode not found");
      return resp;
    } else {
      var resp = ShopOrderReceiveResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<ShopOrderReceiveResp> getDataByCustomerBarcode(
      ShopOrderReceiveReq req) async {
    print('Request to api/ShopOrderFg/GetDataByCustomerBarcode');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderFg/GetDataByCustomerBarcode', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = ShopOrderReceiveResp();
      return resp;
    } else {
      var resp = ShopOrderReceiveResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<ShopOrderReceiveResp> getLocationDescription(
      ShopOrderReceiveReq req) async {
    print('Request to api/ShopOrderFg/GetLocationDescription');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderFg/GetLocationDescription', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = ShopOrderReceiveResp();
      return resp;
    } else {
      var resp = ShopOrderReceiveResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<ShopOrderReceiveResp> shopOrderReceived(
      ShopOrderReceiveReq req) async {
    print('Request to api/ShopOrderFg/ShopOrderReceived');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderFg/ShopOrderReceived', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = ShopOrderReceiveResp();
      return resp;
    } else {
      var resp = ShopOrderReceiveResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<List<CountPerCountReportResp>> getDataByCountReportNo(
      CountPerCountReportReq req) async {
    print('Request to api/CountReport/GetDataByCountReportNo');
    String? result;
    result = await processPostRequest(
        'api/CountReport/GetDataByCountReportNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CountPerCountReportResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CountPerCountReportResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<CountPerCountReportResp>> getDataByPartNo(
      CountPerCountReportReq req) async {
    print('Request to api/CountReport/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/CountReport/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<CountPerCountReportResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(CountPerCountReportResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<CountPerCountReportResp> getDataByBarcodeId(
      CountPerCountReportReq req) async {
    print('Request to api/CountReport/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/CountReport/GetDataByBarcodeId', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = CountPerCountReportResp();
      return resp;
    } else {
      var resp = CountPerCountReportResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<CountPerCountReportResp> reportCountReport(
      List<CountPerCountReportReq> req) async {
    print('Request to api/CountReport/ReportCountReport');
    String? result;
    result = await processPostRequest('api/CountReport/ReportCountReport',
        jsonEncode(req.map((i) => i.toJson()).toList()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = CountPerCountReportResp();
      return resp;
    } else {
      var resp = CountPerCountReportResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<List<DeliveryConfirmationResp>> getDataByShipmentNo(
      DeliveryConfirmationReq req) async {
    print('Request to api/ConfirmDelivery/GetDataByShipmentNo');
    String? result;
    result = await processPostRequest(
        'api/ConfirmDelivery/GetDataByShipmentNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<DeliveryConfirmationResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(DeliveryConfirmationResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<DeliveryConfirmationResp>> kGetDataByCustomerNo(
      DeliveryConfirmationReq req) async {
    print('Request to api/ConfirmDelivery/GetDataByCustomerNo');
    String? result;
    result = await processPostRequest(
        'api/ConfirmDelivery/GetDataByCustomerNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<DeliveryConfirmationResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(DeliveryConfirmationResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<DeliveryConfirmationResp>> kGetDataByPartNo(
      DeliveryConfirmationReq req) async {
    print('Request to api/ConfirmDelivery/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/ConfirmDelivery/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<DeliveryConfirmationResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(DeliveryConfirmationResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<DeliveryConfirmationResp>> getDataByInvoiceNo(
      DeliveryConfirmationReq req) async {
    print('Request to api/ConfirmDelivery/GetDataByInvoiceNo');
    String? result;
    result = await processPostRequest(
        'api/ConfirmDelivery/GetDataByInvoiceNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<DeliveryConfirmationResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(DeliveryConfirmationResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<DeliveryConfirmationResp> kGetDataByCustomerBarcode(
      DeliveryConfirmationReq req) async {
    print('Request to api/ConfirmDelivery/GetDataByCustomerBarcode');
    String? result;
    result = await processPostRequest(
        'api/ConfirmDelivery/GetDataByCustomerBarcode',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = DeliveryConfirmationResp();
      return resp;
    } else {
      var resp = DeliveryConfirmationResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<DeliveryConfirmationResp> confirmDelivery(
      DeliveryConfirmationReq req) async {
    print('Request to api/ConfirmDelivery/ConfirmDelivery');
    String? result;
    result = await processPostRequest(
        'api/ConfirmDelivery/ConfirmDelivery', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = DeliveryConfirmationResp();
      return resp;
    } else {
      var resp = DeliveryConfirmationResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<List<ReportMaterialRequisitionResp>> hGetDataByMaterialReqNo(
      ReportMaterialRequisitionReq req) async {
    print('Request to api/ReportMaterialRequisition/GetDataByMaterialReqNo');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/GetDataByMaterialReqNo',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<ReportMaterialRequisitionResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(ReportMaterialRequisitionResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<ReportMaterialRequisitionResp>> hGetDataByPartNo(
      ReportMaterialRequisitionReq req) async {
    print('Request to api/ReportMaterialRequisition/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/GetDataByPartNo',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<ReportMaterialRequisitionResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(ReportMaterialRequisitionResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<ReportMaterialRequisitionResp>> hGetDataByInternalCustomerNo(
      ReportMaterialRequisitionReq req) async {
    print(
        'Request to api/ReportMaterialRequisition/GetDataByInternalCustomerNo');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/GetDataByInternalCustomerNo',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<ReportMaterialRequisitionResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(ReportMaterialRequisitionResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<ReportMaterialRequisitionResp>> hGetDataByInternalDestinationNo(
      ReportMaterialRequisitionReq req) async {
    print(
        'Request to api/ReportMaterialRequisition/GetDataByInternalDestinationNo');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/GetDataByInternalDestinationNo',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<ReportMaterialRequisitionResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(ReportMaterialRequisitionResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<ReportMaterialRequisitionResp>> hGetDetail(
      ReportMaterialRequisitionReq req) async {
    print('Request to api/ReportMaterialRequisition/GetDetail');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/GetDetail', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<ReportMaterialRequisitionResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(ReportMaterialRequisitionResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<ReportMaterialRequisitionResp> hGetDataByBarcodeId(
      ReportMaterialRequisitionReq req) async {
    print('Request to api/ReportMaterialRequisition/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/GetDataByBarcodeId',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = ReportMaterialRequisitionResp();
      return resp;
    } else {
      var resp = ReportMaterialRequisitionResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<ReportMaterialRequisitionResp> reportMaterialRequisition(
      List<ReportMaterialRequisitionReq> req) async {
    print('Request to api/ReportMaterialRequisition/ReportMaterialRequisition');
    String? result;
    result = await processPostRequest(
        'api/ReportMaterialRequisition/ReportMaterialRequisition',
        jsonEncode(req.map((i) => i.toJson()).toList()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = ReportMaterialRequisitionResp();
      return resp;
    } else {
      var resp = ReportMaterialRequisitionResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<MoveFromIQC_AQCResp> moveIqcAqc(List<MoveFromIQC_AQCReq> req) async {
    print('Request to api/MoveIqcAqc/MoveIqcAqc');
    String? result;
    result = await processPostRequest('api/MoveIqcAqc/MoveIqcAqc',
        jsonEncode(req.map((i) => i.toJson()).toList()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = MoveFromIQC_AQCResp();
      return resp;
    } else {
      var resp = MoveFromIQC_AQCResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<List<MoveFromIQC_AQCResp>> iGetDataByPurchaseOrderNo(
      MoveFromIQC_AQCReq req) async {
    print('Request to api/MoveIqcAqc/GetDataByPurchaseOrderNo');
    String? result;
    result = await processPostRequest(
        'api/MoveIqcAqc/GetDataByPurchaseOrderNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<MoveFromIQC_AQCResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(MoveFromIQC_AQCResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<MoveFromIQC_AQCResp>> iGetDataByPartNo(
      MoveFromIQC_AQCReq req) async {
    print('Request to api/MoveIqcAqc/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/MoveIqcAqc/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<MoveFromIQC_AQCResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(MoveFromIQC_AQCResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<MoveFromIQC_AQCResp>> iGetDataByVendorNo(
      MoveFromIQC_AQCReq req) async {
    print('Request to api/MoveIqcAqc/GetDataByVendorNo');
    String? result;
    result = await processPostRequest(
        'api/MoveIqcAqc/GetDataByVendorNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<MoveFromIQC_AQCResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(MoveFromIQC_AQCResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<MoveFromIQC_AQCResp>> iGetDataByLotNo(
      MoveFromIQC_AQCReq req) async {
    print('Request to api/MoveIqcAqc/GetDataByLotNo');
    String? result;
    result = await processPostRequest(
        'api/MoveIqcAqc/GetDataByLotNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<MoveFromIQC_AQCResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(MoveFromIQC_AQCResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<MoveFromIQC_AQCResp> iCheckToLocationExist(
      MoveFromIQC_AQCReq req) async {
    print('Request to api/MoveIqcAqc/CheckToLocationExist');
    String? result;
    result = await processPostRequest(
        'api/MoveIqcAqc/CheckToLocationExist', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = MoveFromIQC_AQCResp();
      return resp;
    } else {
      var resp = MoveFromIQC_AQCResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<List<PurchaseOrderReceiveResp>> nGetDataByPurchaseOrder(
      PurchaseOrderReceiveReq req) async {
    print('Request to api/PoReceived/GetDataByPurchaseOrder');
    String? result;
    result = await processPostRequest(
        'api/PoReceived/GetDataByPurchaseOrder', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<PurchaseOrderReceiveResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(PurchaseOrderReceiveResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<PurchaseOrderReceiveResp>> nGetDataBySupplierNo(
      PurchaseOrderReceiveReq req) async {
    print('Request to api/PoReceived/GetDataBySupplierNo');
    String? result;
    result = await processPostRequest(
        'api/PoReceived/GetDataBySupplierNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<PurchaseOrderReceiveResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(PurchaseOrderReceiveResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<PurchaseOrderReceiveResp>> nGetDataByPartNo(
      PurchaseOrderReceiveReq req) async {
    print('Request to api/PoReceived/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/PoReceived/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<PurchaseOrderReceiveResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(PurchaseOrderReceiveResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<PurchaseOrderReceiveResp>> nGetDataByShopOrderNo(
      PurchaseOrderReceiveReq req) async {
    print('Request to api/PoReceived/GetDataByShopOrderNo');
    String? result;
    result = await processPostRequest(
        'api/PoReceived/GetDataByShopOrderNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<PurchaseOrderReceiveResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(PurchaseOrderReceiveResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<PurchaseOrderReceiveResp> nGetDataByBarcodeId(
      PurchaseOrderReceiveReq req) async {
    print('Request to api/PoReceived/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/PoReceived/GetDataByBarcodeId', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = PurchaseOrderReceiveResp();
      return resp;
    } else {
      var resp = PurchaseOrderReceiveResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<PurchaseOrderReceiveResp> poReceived(
      List<PurchaseOrderReceiveReq> req) async {
    print('Request to api/PoReceived/PoReceived');
    String? result;
    result = await processPostRequest('api/PoReceived/PoReceived',
        jsonEncode(req.map((i) => i.toJson()).toList()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = PurchaseOrderReceiveResp();
      return resp;
    } else {
      var resp = PurchaseOrderReceiveResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<List<GetDataByShopBarcodeResp>> oGetDataByShopBarcode(
      GetDataByShopBarcodeReq req) async {
    print('Request to api/ShopOrderOper/GetDataByShopBarcode');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderOper/GetDataByShopBarcode', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<GetDataByShopBarcodeResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(GetDataByShopBarcodeResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<GetDataByShopBarcodeResp> oGetDataByProductionLine(
      GetDataByShopBarcodeReq req) async {
    print('Request to api/ShopOrderOper/GetDataByProductionLine');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderOper/GetDataByProductionLine', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = GetDataByShopBarcodeResp();
      return resp;
    } else {
      var resp = GetDataByShopBarcodeResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<GetDataByShopBarcodeResp> oShopOrderReported(
      GetDataByShopBarcodeReq req) async {
    print('Request to api/ShopOrderOper/ShopOrderReported');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderOper/ShopOrderReported', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = GetDataByShopBarcodeResp();
      return resp;
    } else {
      var resp = GetDataByShopBarcodeResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<OgawaComResp> pGetSchedOptionList(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/GetSchedOptionList');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/GetSchedOptionList', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<OgawaComResp> pGetDataByPartNo(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<OgawaComResp> pCheckProductionLineExist(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/CheckProductionLineExist');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/CheckProductionLineExist',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<OgawaComResp> pCheckLocationExist(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/CheckLocationExist');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/CheckLocationExist', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<OgawaComResp> pCheckAllowReviseQty(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/CheckAllowReviseQty');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/CheckAllowReviseQty', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

  Future<OgawaComResp> pCheckAuthorization(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/CheckAuthorization');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/CheckAuthorization', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }

    Future<OgawaComResp> pProductionReceipt(OgawaComReq req) async {
    print('Request to api/ProductionReceipt/ProductionReceipt');
    String? result;
    result = await processPostRequest(
        'api/ProductionReceipt/ProductionReceipt', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = OgawaComResp();
      return resp;
    } else {
      var resp = OgawaComResp.fromJson(jsonDecode(result));
      return resp;
    }
  }
}
