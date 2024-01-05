import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/ogawaComReq.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

class ProductionReceiptApi  {
  Future<List<DropdownMenuItem<String>>> pGetSchedOptionList(
      BuildContext context, Box<ApiSettings> database) async {
    ApiSettings apiData = ApiSettings();
    List<ApiSettings> dataSetting = [];
    List<DropdownMenuItem<String>> dropdownItems = [];
    dataSetting = database.values.toList();
    for (var item in dataSetting) {
      if (item.baseName == ApiProxyParameter.dataBaseSelect) {
        apiData = item;
      }
    }
    EasyLoading.show(status: 'loading...');

    AllApiProxy proxy = AllApiProxy();
    proxy.host = '${apiData.apiUrl}';
    proxy.dbName = '${apiData.serviceName}';
    proxy.dbHost = '${apiData.serviceIp}';
    proxy.dbPort = int.parse('${apiData.port}');
    proxy.dbUser = ApiProxyParameter.userLogin;
    proxy.dbPass = ApiProxyParameter.passLogin;
    var req = OgawaComReq();
    req.reportedQty = 0;
    req.stdPackSize = 0;
    req.numberOfLabels = 0;
    var response = await proxy.pGetSchedOptionList(req);
    if (response.errorMessage == null) {
      var data = "${response.schedOptionList}";
      if (data != "") {
        var list = data.split(";");
        for (var i = 0; i < list.length; i++) {
          if (list[i] != "") {
            dropdownItems
                .add(DropdownMenuItem(child: Text(list[i]), value: list[i]));
          }
        }
      }
    }

    EasyLoading.dismiss();
    return dropdownItems;
  }
}
