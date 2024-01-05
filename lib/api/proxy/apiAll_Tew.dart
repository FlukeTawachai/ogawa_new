import 'dart:convert';

import 'package:ogawa_nec/api/proxy/apiProxy.dart';
import 'package:ogawa_nec/api/request/countPerInventoryPartReq.dart';
import 'package:ogawa_nec/api/response/countPerInventoryPartResp.dart';

import 'package:ogawa_nec/api/request/ShopOrderReceiveWIPReq.dart';
import 'package:ogawa_nec/api/response/ShopOrderReceiveWIPResp.dart';

import 'package:ogawa_nec/api/request/reportTransportTaskReq.dart';
import 'package:ogawa_nec/api/response/reportTransportTaskResp.dart';

import 'package:ogawa_nec/api/request/moveToNewLocationRep.dart';
import 'package:ogawa_nec/api/response/moveToNewLocationResp.dart';

class AllApiProxy extends ApiProxy {
  Future<countPerInventoryPartResp> getDataByBarcodeId(
      countPerInventoryPartReq req) async {
    print('Request to api/CountPart/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/CountPart/GetDataByBarcodeId', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = countPerInventoryPartResp();
      return resp;
    } else {
      var resp = countPerInventoryPartResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<countPerInventoryPartResp> getPartDescription(
      countPerInventoryPartReq req) async {
    print('Request to api/CountPart/GetPartDescription');
    String? result;
    result = await processPostRequest(
        'api/CountPart/GetPartDescription', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = countPerInventoryPartResp();
      return resp;
    } else {
      var resp = countPerInventoryPartResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<countPerInventoryPartResp> getLocationDescription(
      countPerInventoryPartReq req) async {
    print('Request to api/CountPart/GetLocationDescription');
    String? result;
    result = await processPostRequest(
        'api/CountPart/GetLocationDescription', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = countPerInventoryPartResp();
      return resp;
    } else {
      var resp = countPerInventoryPartResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<countPerInventoryPartResp> reportCountPart(
      countPerInventoryPartReq req) async {
    print('Request to api/CountPart/ReportCountPart');
    String? result;
    result = await processPostRequest(
        'api/CountPart/ReportCountPart', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = countPerInventoryPartResp();
      return resp;
    } else {
      var resp = countPerInventoryPartResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  // WIP

  Future<shopOrderReceiveWIPResp> getDataByBarcodeIdWIP(
      shopOrderReceiveWIPReq req) async {
    print('Request to api/ShopOrderWip/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderWip/GetDataByBarcodeId', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = shopOrderReceiveWIPResp();
      return resp;
    } else {
      var resp = shopOrderReceiveWIPResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<shopOrderReceiveWIPResp> getLocationDescriptionWIP(
      shopOrderReceiveWIPReq req) async {
    print('Request to api/ShopOrderWip/GetLocationDescription');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderWip/GetLocationDescription', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = shopOrderReceiveWIPResp();
      return resp;
    } else {
      var resp = shopOrderReceiveWIPResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<shopOrderReceiveWIPResp> shopOrderReceivedWIP(
      shopOrderReceiveWIPReq req) async {
    print('Request to api/ShopOrderWip/ShopOrderReceived');
    String? result;
    result = await processPostRequest(
        'api/ShopOrderWip/ShopOrderReceived', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = shopOrderReceiveWIPResp();
      return resp;
    } else {
      var resp = shopOrderReceiveWIPResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<List<reportTransportTaskResp>> getDataByTransportId(
      reportTransportTaskReq req) async {
    print('Request to api/ReportTransportTask/GetDataByTransportId');
    String? result;
    result = await processPostRequest(
        'api/ReportTransportTask/GetDataByTransportId',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<reportTransportTaskResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(reportTransportTaskResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<reportTransportTaskResp>> getDataByExpListNo(
      reportTransportTaskReq req) async {
    print('Request to api/ReportTransportTask/GetDataByExpListNo');
    String? result;
    result = await processPostRequest(
        'api/ReportTransportTask/GetDataByExpListNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<reportTransportTaskResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(reportTransportTaskResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<reportTransportTaskResp>> getDataByPartNo(
      reportTransportTaskReq req) async {
    print('Request to api/ReportTransportTask/GetDataByPartNo');
    String? result;
    result = await processPostRequest(
        'api/ReportTransportTask/GetDataByPartNo', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<reportTransportTaskResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(reportTransportTaskResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<List<reportTransportTaskResp>> getDataByShopOrderNo(
      reportTransportTaskReq req) async {
    print('Request to api/ReportTransportTask/GetDataByShopOrderNo');
    String? result;
    result = await processPostRequest(
        'api/ReportTransportTask/GetDataByShopOrderNo',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result != 'null') {
      List<reportTransportTaskResp> returnValue = [];

      List<dynamic> json = jsonDecode(result);

      if (json.isNotEmpty) {
        for (var item in json) {
          returnValue.add(reportTransportTaskResp.fromJson(item));
        }
      }
      return returnValue;
    } else {
      return [];
    }
  }

  Future<reportTransportTaskResp> getDataByBarcodeIdRTT(
      reportTransportTaskReq req) async {
    print('Request to api/ReportTransportTask/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/ReportTransportTask/GetDataByBarcodeId', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = reportTransportTaskResp();
      return resp;
    } else {
      var resp = reportTransportTaskResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<reportTransportTaskResp> reportTransportTask(
      reportTransportTaskReq req) async {
    print('Request to api/ReportTransportTask/ReportTransportTask');
    String? result;
    result = await processPostRequest(
        'api/ReportTransportTask/ReportTransportTask',
        jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = reportTransportTaskResp();
      return resp;
    } else {
      var resp = reportTransportTaskResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<moveToNewLocationResp> checkFromLocationExist(
      moveToNewLocationRep req) async {
    print('Request to api/MoveNewLocation/CheckFromLocationExist');
    String? result;
    result = await processPostRequest(
        'api/MoveNewLocation/CheckFromLocationExist', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = moveToNewLocationResp();
      return resp;
    } else {
      var resp = moveToNewLocationResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<moveToNewLocationResp> getDataByBarcodeIdMTNLR(
      moveToNewLocationRep req) async {
    print('Request to api/MoveNewLocation/GetDataByBarcodeId');
    String? result;
    result = await processPostRequest(
        'api/MoveNewLocation/GetDataByBarcodeId', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = moveToNewLocationResp();
      return resp;
    } else {
      var resp = moveToNewLocationResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<moveToNewLocationResp> checkToLocationExist(
      moveToNewLocationRep req) async {
    print('Request to api/MoveNewLocation/CheckToLocationExist');
    String? result;
    result = await processPostRequest(
        'api/MoveNewLocation/CheckToLocationExist', jsonEncode(req.toJson()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = moveToNewLocationResp();
      return resp;
    } else {
      var resp = moveToNewLocationResp.fromJson(jsonDecode(result));

      return resp;
    }
  }

  Future<moveToNewLocationResp> moveNewLocation(
      List<moveToNewLocationRep> req) async {
    print('Request to api/MoveNewLocation/MoveNewLocation');
    String? result;
    result = await processPostRequest('api/MoveNewLocation/MoveNewLocation',
        jsonEncode(req.map((i) => i.toJson()).toList()));
    print('API Response : ' + result);
    // ignore: unnecessary_null_comparison
    if (result == 'null') {
      var resp = moveToNewLocationResp();
      return resp;
    } else {
      var resp = moveToNewLocationResp.fromJson(jsonDecode(result));
      return resp;
    }
  }
}
