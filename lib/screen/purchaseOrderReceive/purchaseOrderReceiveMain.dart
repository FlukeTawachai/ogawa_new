import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/purchaseOrderReceiveReq.dart';
import 'package:ogawa_nec/api/response/purchaseOrderReceiveResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/purchaseOrderReceive/listPO.dart';
import 'package:ogawa_nec/screen/purchaseOrderReceive/purchaseOrderReceiveSort.dart';

class PurchaseOrderReceiveMain extends StatefulWidget {
  final bool reset;
  const PurchaseOrderReceiveMain({Key? key, required this.reset})
      : super(key: key);

  @override
  State<PurchaseOrderReceiveMain> createState() =>
      _PurchaseOrderReceiveMainState();
}

class _PurchaseOrderReceiveMainState extends State<PurchaseOrderReceiveMain> {
  final FocusNode _nodesearchOption = FocusNode();
  final TextEditingController _searchOptionNo = TextEditingController();
  int charLength = 0;
  String _search = '';
  String search = '';
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  String searchBy = "PON";
  String searchInput = "Please Input Purchase Order No";

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      search = value;
      if (value == '') {
        GlobalParam.dataListN = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    if (widget.reset == true) {
      GlobalParam.dataListN = [];
    }
    if (userSearchDefault.isNotEmpty) {
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_N') {
          if (userSearchDefault[i].searchBy == 'PON') {
            setState(() {
              searchInput = "Please Input Purchase Order No";
              searchBy = 'PON';
            });
          } else if (userSearchDefault[i].searchBy == 'SN') {
            setState(() {
              searchInput = "Please Input Supplier No";
              searchBy = 'SN';
            });
          } else if (userSearchDefault[i].searchBy == 'PN') {
            setState(() {
              searchInput = "Please Input Part No";
              searchBy = 'PN';
            });
          } else if (userSearchDefault[i].searchBy == 'SON') {
            setState(() {
              searchInput = "Please Input Shop order No";
              searchBy = 'SON';
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchAppbar(),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  Scaffold.of(context).openDrawer();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor("#4e73be"),
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: const MenuSide(),
      // ignore: prefer_const_constructors
      endDrawer: PurchaseOrderReceiveSort(),
      // ignore: prefer_const_constructors
      body: ListPO(),
      bottomNavigationBar: const BottomBarFooter(),
    );
  }

  Widget _searchAppbar() {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      height: 40,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        enabled: true,
        autofocus: true,
        focusNode: _nodesearchOption,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _searchOptionNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.all(0.0),
          hintText: searchInput,
          hintStyle: TextStyle(
            color: HexColor("#a8a8a8"),
            fontSize: 12,
          ),
          counterText: '',
          prefixIcon: IconButton(
            alignment: Alignment.center,
            icon: const Icon(
              Icons.search,
              color: Colors.black,
              //size: 35.0,
            ),
            onPressed: () {
              setState(() {
                _searchOptionNo.clear();
                GlobalParam.dataListN = [];
              });
            },
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _searchOptionNo.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchOptionNo.clear();
                        GlobalParam.dataListN = [];
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: _onChanged,
        onFieldSubmitted: (value) {
          if (searchBy == 'PON') {
            getDataByPurchaseOrder(search);
          } else if (searchBy == 'SN') {
            getDataBySupplierNo(search);
          } else if (searchBy == 'PN') {
            getDataByPartNo(search);
          } else if (searchBy == 'SON') {
            getDataByShopOrderNo(search);
          }
        },
      ),
    );
  }

  getDataByPurchaseOrder(String purchaseOrderNo) async {
    try {
      ApiSettings apiData = ApiSettings();
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
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');

      var result = await proxy.nGetDataByPurchaseOrder(PurchaseOrderReceiveReq(
          purchaseOrderNo: purchaseOrderNo,
          barcodeId: 0,
          purchReceivedQty: 0,
          purchOrderQty: 0,
          invOrderQty: 0,
          invReceivedQty: 0,
          conversionFactor: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListN = [];
            GlobalParam.dataListN.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListN = [];
          GlobalParam.dataListN.addAll(result);
        }

        setState(() {});
      }
      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }

  getDataBySupplierNo(String supplierNo) async {
    try {
      ApiSettings apiData = ApiSettings();
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
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');

      var result = await proxy.nGetDataBySupplierNo(PurchaseOrderReceiveReq(
          supplierNo: supplierNo,
          barcodeId: 0,
          purchReceivedQty: 0,
          purchOrderQty: 0,
          invOrderQty: 0,
          invReceivedQty: 0,
          conversionFactor: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListN = [];
            GlobalParam.dataListN.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListN = [];
          GlobalParam.dataListN.addAll(result);
        }
        setState(() {});
      }
      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }

  getDataByPartNo(String partNo) async {
    try {
      ApiSettings apiData = ApiSettings();
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
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');

      var result = await proxy.nGetDataByPartNo(PurchaseOrderReceiveReq(
          partNo: partNo,
          barcodeId: 0,
          purchReceivedQty: 0,
          purchOrderQty: 0,
          invOrderQty: 0,
          invReceivedQty: 0,
          conversionFactor: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListN = [];
            GlobalParam.dataListN.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListN = [];
          GlobalParam.dataListN.addAll(result);
        }
        setState(() {});
      }
      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }

  getDataByShopOrderNo(String shopOrderNo) async {
    try {
      ApiSettings apiData = ApiSettings();
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
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');

      var result = await proxy.nGetDataByShopOrderNo(PurchaseOrderReceiveReq(
          shopOrderNo: shopOrderNo,
          barcodeId: 0,
          purchReceivedQty: 0,
          purchOrderQty: 0,
          invOrderQty: 0,
          invReceivedQty: 0,
          conversionFactor: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListN = [];
            GlobalParam.dataListN.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListN = [];
          GlobalParam.dataListN.addAll(result);
        }
        setState(() {});
      }
      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }

  Widget okButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }
}
