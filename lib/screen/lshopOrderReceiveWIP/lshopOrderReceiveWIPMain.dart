// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:ogawa_nec/CountPerInventoryPart.dart/sweetAlert/aweetAlert.dart';

import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ogawa_nec/api/request/ShopOrderReceiveWIPReq.dart';

class ShopOrdernReceiveWIPMain extends StatefulWidget {
  const ShopOrdernReceiveWIPMain({Key? key}) : super(key: key);

  @override
  State<ShopOrdernReceiveWIPMain> createState() =>
      _ShopOrdernReceiveWIPMainState();
}

class _ShopOrdernReceiveWIPMainState extends State<ShopOrdernReceiveWIPMain> {
  final FocusNode _nodeBarcodeID = FocusNode();
  final FocusNode _nodeLocationNo = FocusNode();
  final FocusNode _nodeReportedQty = FocusNode();
  final TextEditingController _barcodeID = TextEditingController();
  final TextEditingController _partNo = TextEditingController();
  final TextEditingController _partName = TextEditingController();
  final TextEditingController _lotNo = TextEditingController();
  final TextEditingController _fgNo = TextEditingController();
  final TextEditingController _locationNo = TextEditingController();
  final TextEditingController _parentOrder = TextEditingController();
  final TextEditingController _locationDesc = TextEditingController();
  final TextEditingController _remainQty = TextEditingController();
  final TextEditingController _uom1 = TextEditingController();
  final TextEditingController _uom2 = TextEditingController();
  final TextEditingController _reportedQty = TextEditingController();
  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  int charLength = 0;
  bool isLastBarcode = false;
  bool? isOverRemaining;
  bool ischeckbarcode = false;
  bool ischecklocationNo = false;
  // var disActivenodeLocationNo = false;
  // var disActivenodebarcode = false;
  double stdPackSize = 0.0;

  int countBarcodeID = 0;
  int countLocationNo = 0;

  bool disActivenodeBarcode = false;
  bool disActivenodelocationNo = false;
  bool disActivenodeQty = false;

  bool barcodeIdSuccess = false;
  bool locationNoSuccess = false;
  bool qtySuccess = false;
  bool disbutton = false;
  double heightScreen = 0;

  var isError = {
    'barcodeIdSuccess': 'Please check the information is correct.',
    'locationNoSuccess': 'Please check the information is correct.',
    'qtySuccess': 'Please check the information is correct.',
  };

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    _nodeLocationNo.addListener(_setActiveNode);
    _nodeBarcodeID.addListener(_setActiveNode);
    _nodeReportedQty.addListener(_setActiveNode);
  }

  // void _setReportedQty() async {
  //   if (_nodeReportedQty.hasFocus.toString() == 'true') {
  //     disActivenodeLocationNo = true;
  //   }
  //   if (disActivenodeLocationNo &&
  //       _nodeReportedQty.hasFocus.toString() == 'false') {
  //     disActivenodeLocationNo = false;
  //     await _onChangedreportedQty(_reportedQty.text);
  //   }
  // }

  void _setActiveNode() async {
    if (_nodeBarcodeID.hasFocus.toString() == 'true') {
      disActivenodeBarcode = true;
      disActivenodelocationNo = false;
      disActivenodeQty = false;
      disbutton = true;
    } else if (_nodeLocationNo.hasFocus.toString() == 'true') {
      disActivenodeBarcode = false;
      disActivenodelocationNo = true;
      disActivenodeQty = false;
      disbutton = true;
    } else if (_nodeReportedQty.hasFocus.toString() == 'true') {
      disActivenodeBarcode = false;
      disActivenodelocationNo = false;
      disActivenodeQty = false;
    }

    if (disActivenodeBarcode && _nodeBarcodeID.hasFocus.toString() == 'false') {
      disActivenodeBarcode = false;
      disActivenodelocationNo = false;
      disActivenodeQty = false;
      if (_barcodeID.text != '') {
        await getDataByBarcodeIdWIP(_barcodeID.text, true);
      }
    } else if (disActivenodelocationNo &&
        _nodeLocationNo.hasFocus.toString() == 'false') {
      disActivenodeBarcode = false;
      disActivenodelocationNo = false;
      disActivenodeQty = false;
      if (_locationNo.text != '') {
        await getLocationDescriptionWIP(_locationNo.text, true);
      }
    } else if (disActivenodeQty &&
        _nodeReportedQty.hasFocus.toString() == 'false') {
      disActivenodeBarcode = false;
      disActivenodelocationNo = false;
      disActivenodeQty = false;
      double qty = double.tryParse(_reportedQty.text) ?? 0;
      _reportedQty.text = qty.toString();
      disbutton = false;
      qtySuccess = true;
      if (qty < 1) {
        qtySuccess = false;
        isError['qtySuccess'] = 'Reported Qty is zero.';
      } else if (qty > stdPackSize) {
        qtySuccess = false;
        isError['qtySuccess'] =
            'Max of Reported Qty ${stdPackSize.toString()}.';
        Tdialog.errorDialog(
          context,
          'Error',
          'Max of Reported Qty ${stdPackSize.toString()}.',
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              setState(() {
                _reportedQty.text = stdPackSize.toString();
              });
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: HexColor("#5b9bd5"),
              ),
            ),
          ),
        );
      } else {}
    }

    setState(() {
      print('cejc : ' +
          (disActivenodeBarcode || disActivenodelocationNo || disActivenodeQty)
              .toString());
    });
  }

  _onChangedreportedQty(String value) {
    try {
      if (value != '') {
        print(value);
        double txt =
            double.tryParse(value.replaceAll(',', '').replaceAll('-', '0')) ??
                0;
        _reportedQty.text = 0.toString();
        if (txt > 0) {
          if (isLastBarcode == false) {
            if (txt > stdPackSize) {
              if (isOverRemaining != true) {
                Tdialog.errorDialog(
                  context,
                  'Error',
                  'Max of Reported Qty ${stdPackSize.toString()}.',
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        _reportedQty.text = stdPackSize.toString();
                      });
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: HexColor("#5b9bd5"),
                      ),
                    ),
                  ),
                );
              }
            } else {
              // value = Utility.formNum(
              //   value.replaceAll(',', '').replaceAll('-', ''),
              // );
              _reportedQty.value = TextEditingValue(
                text: value,
                selection: TextSelection.collapsed(
                  offset: value.length,
                ),
              );
            }
          } else {
            // value = Utility.formNum(
            //   value.replaceAll(',', '').replaceAll('-', ''),
            // );
            _reportedQty.value = TextEditingValue(
              text: value,
              selection: TextSelection.collapsed(
                offset: value.length,
              ),
            );
          }
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            'Reported Qty is zero.',
            okButton(),
          );
        }
      } else {
        setState(() {
          _reportedQty.text = '0';
        });
        Tdialog.errorDialog(
          context,
          'Error',
          'Reported Qty is zero.',
          okButton(),
        );
      }
    } on Exception catch (e) {
      setState(() {
        _reportedQty.text = '1';
      });
    }
    setState(() {
      charLength = value.length;
    });
  }

  _resetData() {
    setState(() {
      // charLength = value.length;
      // _barcodeID.text = "";
      _partNo.text = "";
      _partName.text = "";
      _lotNo.text = "";
      _fgNo.text = "";
      _locationNo.text = "";
      _parentOrder.text = "";
      _locationDesc.text = "";
      _remainQty.text = "";
      _uom1.text = "";
      _uom2.text = "";
      _reportedQty.text = "";
    });
  }

  getDataByBarcodeIdWIP(String value, next) async {
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

      var result = await proxy.getDataByBarcodeIdWIP(shopOrderReceiveWIPReq(
          barcodeId:
              (_barcodeID.text.isNotEmpty ? int.parse(_barcodeID.text) : 0),
          remainingQty: 0.0,
          reportedQty: 0.0,
          stdPackSize: 0.0));

      if (result.errorMessage == null) {
        barcodeIdSuccess = true;
        setState(() {
          // charLength = value.length;
          _barcodeID.text = result.barcodeId.toString();
          _partNo.text = result.partNo.toString();
          _partName.text = result.partDesc.toString();
          _lotNo.text = result.lotNo.toString();
          _fgNo.text = result.fgNo ?? "";
          _locationNo.text = result.locationNo.toString();
          _parentOrder.text = result.parentOrder ?? "";
          _locationDesc.text = result.locationDesc.toString();
          _remainQty.text = result.remainingQty.toString();
          _uom1.text = result.uom.toString();
          _uom2.text = result.uom.toString();
          stdPackSize = result.stdPackSize!;
          _reportedQty.text = result.reportedQty.toString();
          isOverRemaining = result.isOverRemaining;

          if (result.isLastBarcode != null) {
            isLastBarcode = result.isLastBarcode!;
            // isLastBarcode = true;
          }

          if (next) {
            FocusScope.of(context).requestFocus(_nodeLocationNo);
          }
        });
      } else {
        barcodeIdSuccess = false;
        isError['barcodeIdSuccess'] = '${result.errorMessage}';

        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        _resetData();
        if (next) {
          // FocusScope.of(context).requestFocus(_nodeBarcodeID);
        }
      }

      EasyLoading.dismiss();
    } on SocketException catch (e) {
      barcodeIdSuccess = false;
      isError['barcodeIdSuccess'] = '$e';
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
      _resetData();
      if (next) {
        // FocusScope.of(context).requestFocus(_nodeBarcodeID);
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
      _resetData();
      if (next) {
        // FocusScope.of(context).requestFocus(_nodeBarcodeID);
      }
    }

    countBarcodeID = countBarcodeID + 1;
  }

  checkData() async {
    var datareturn = true;
    var massage = '';
    ApiSettings apiData = ApiSettings();
    dataSetting = database.values.toList();
    for (var item in dataSetting) {
      if (item.baseName == ApiProxyParameter.dataBaseSelect) {
        apiData = item;
      }
    }
    EasyLoading.show(status: 'loading...');

    // check Location
    AllApiProxy proxy = AllApiProxy();
    proxy.host = '${apiData.apiUrl}';
    proxy.dbName = '${apiData.serviceName}';
    proxy.dbHost = '${apiData.serviceIp}';
    proxy.dbPort = int.parse('${apiData.port}');
    proxy.dbUser = ApiProxyParameter.userLogin;
    proxy.dbPass = ApiProxyParameter.passLogin;

    var result = await proxy.getLocationDescriptionWIP(shopOrderReceiveWIPReq(
        barcodeId: 0,
        locationNo: (_locationNo.text.isNotEmpty ? _locationNo.text : ''),
        remainingQty: 0.0,
        reportedQty: 0.0,
        stdPackSize: 0.0));

    // check barcode

    proxy.host = '${apiData.apiUrl}';
    proxy.dbName = '${apiData.serviceName}';
    proxy.dbHost = '${apiData.serviceIp}';
    proxy.dbPort = int.parse('${apiData.port}');
    proxy.dbUser = ApiProxyParameter.userLogin;
    proxy.dbPass = ApiProxyParameter.passLogin;

    var result2 = await proxy.getDataByBarcodeIdWIP(shopOrderReceiveWIPReq(
        barcodeId:
            (_barcodeID.text.isNotEmpty ? int.parse(_barcodeID.text) : 0),
        remainingQty: 0.0,
        reportedQty: 0.0,
        stdPackSize: 0.0));

    double txt = double.tryParse(
            _reportedQty.text.replaceAll(',', '').replaceAll('-', '0')) ??
        0;
    _reportedQty.text = txt.toString();
    if (result.errorMessage != null) {
      datareturn = false;
      massage = result.errorMessage!;
    } else if (result2.errorMessage != null) {
      _resetData();
      datareturn = false;
      massage = result2.errorMessage!;
    } else if (txt == 0) {
      datareturn = false;
      massage = 'Reported Qty is zero.';
    } else {
      // checkLocationNo = true;
    }
    EasyLoading.dismiss();
    return [datareturn, massage];
  }

  getLocationDescriptionWIP(String value, next) async {
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

      var result = await proxy.getLocationDescriptionWIP(shopOrderReceiveWIPReq(
          barcodeId: 0,
          locationNo: (_locationNo.text.isNotEmpty ? _locationNo.text : ''),
          remainingQty: 0.0,
          reportedQty: 0.0,
          stdPackSize: 0.0));
      locationNoSuccess = false;
      if (result.errorMessage == null) {
        locationNoSuccess = true;
        setState(() {
          // _locationNo.text = result.locationNo.toString();
          _locationDesc.text = result.locationDesc.toString();
        });

        if (next) {
          FocusScope.of(context).requestFocus(_nodeReportedQty);
        }
      } else {
        isError['locationNoSuccess'] = '${result.errorMessage}';
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        _locationDesc.text = "";
        // FocusScope.of(context).requestFocus(_nodeLocationNo);
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
      _locationDesc.text = "";
      // FocusScope.of(context).requestFocus(_nodeLocationNo);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
      _locationDesc.text = "";
      // FocusScope.of(context).requestFocus(_nodeLocationNo);
    }
    countLocationNo = countLocationNo + 1;
  }

  shopOrderReceivedWIP() async {
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

      var result = await proxy.shopOrderReceivedWIP(shopOrderReceiveWIPReq(
          barcodeId:
              (_barcodeID.text.isNotEmpty ? int.parse(_barcodeID.text) : 0),
          locationNo: _locationNo.text,
          reportedQty: double.parse(
              _reportedQty.text.replaceAll(',', '').replaceAll('-', '')),
          remainingQty: 0.0,
          stdPackSize: 0.0,
          isOverRemaining: isOverRemaining,
          isLastBarcode: isLastBarcode));
      if (result.errorMessage == null) {
        // setState(() {
        //   // charLength = value.length;
        //   locationNo.text = result.partNo ?? '';
        //   locationDESC.text = result.partDesc ?? '';
        // });
        EasyLoading.dismiss();
        return true;
      } else {
        // wrongDialog('${result.errorMessage}');
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
      }
      EasyLoading.dismiss();
      return false;
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      // wrongDialog(e.message);
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
      return false;
    } on Exception catch (e) {
      EasyLoading.dismiss();
      // wrongDialog(e.toString());
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Shop Order Receive for WIP'),
        ),
        drawer: const MenuSide(),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: barCodeID(),
                    ),
                    Expanded(
                      child: partNo(),
                    ),
                  ],
                ),
                partName(),
                Row(
                  children: [
                    Expanded(
                      child: lotNo(),
                    ),
                    Expanded(
                      child: fgNo(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: locationNo(),
                    ),
                    Expanded(
                      child: parentOrder(),
                    ),
                  ],
                ),
                locationDesc(),
                Row(
                  children: [
                    Expanded(
                      child: remainQty(),
                    ),
                    uom1(),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: reportedQty(),
                    ),
                    uom2(),
                  ],
                ),
                saveButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBarFooter(),
      ),
    );
  }

  Widget barCodeID() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: true,
        autofocus: true,
        focusNode: _nodeBarcodeID,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _barcodeID,
        style: const TextStyle(
          fontSize: 16,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#ed7d31"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#ed7d31"),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: HexColor("#ed7d31"),
              width: 2.0,
            ),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a8a8a8"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          labelText: 'Barcode ID',
          labelStyle: TextStyle(
            color: HexColor("#ed7d31"),
          ),
          counterText: '',
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _barcodeID.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      // disActivenodeLocationNo = false;
                      setState(() {
                        _barcodeID.clear();
                        _partNo.clear();
                        _partName.clear();
                        _lotNo.clear();
                        _fgNo.clear();
                        _locationNo.clear();
                        _parentOrder.clear();
                        _locationDesc.clear();
                        _remainQty.clear();
                        _uom1.clear();
                        _uom2.clear();
                        _reportedQty.clear();
                        disActivenodelocationNo = false;
                        disActivenodeQty = false;
                      });
                      FocusScope.of(context).requestFocus(_nodeBarcodeID);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            var text = value;
            var textList = text.split("|");

            _barcodeID.text = textList[0];
            _barcodeID.selection = TextSelection.fromPosition(
                TextPosition(offset: _barcodeID.text.length));
          });
          barcodeIdSuccess = false;
          isError['barcodeIdSuccess'] = 'Please check the information again.';
        },
        onFieldSubmitted: (v) async {
          // await getDataByBarcodeIdWIP(v, true)
        },
      ),
    );
  }

  Widget partNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _partNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Part No',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget partName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _partName,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Part Name',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget lotNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _lotNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Lot No',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget fgNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _fgNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'FG No',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget locationNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: true,
        //autofocus: true,
        focusNode: _nodeLocationNo,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _locationNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#9dc3e6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#9dc3e6"),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: HexColor("#9dc3e6"),
              width: 2.0,
            ),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a8a8a8"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          labelText: 'Location No',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          counterText: '',
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _locationNo.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _locationNo.clear();
                      });
                      FocusScope.of(context).requestFocus(_nodeLocationNo);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _locationNo.text = value;
            _locationNo.selection = TextSelection.fromPosition(
                TextPosition(offset: _locationNo.text.length));
          });
          locationNoSuccess = false;
          isError['locationNoSuccess'] = 'Please check the information again.';
        },
        onSubmitted: (v) async {
          // FocusScope.of(context).requestFocus(_nodeReportedQty);
          // await getLocationDescriptionWIP(_locationNo.text, true);
          // countBarcodeID = 0;
          // countLocationNo = 0;
        },
      ),
    );
  }

  Widget parentOrder() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _parentOrder,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Parent Order',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget locationDesc() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _locationDesc,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Location Desc',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget remainQty() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _remainQty,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Remaining Qty',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget uom1() {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _uom1,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Uom',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget uom2() {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _uom2,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Uom',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget reportedQty() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          enabled: true,
          //autofocus: true,
          focusNode: _nodeReportedQty,
          enableInteractiveSelection: false,
          readOnly: false,
          controller: _reportedQty,
          style: const TextStyle(
            fontSize: 16,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
          ],
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#ed7d31"))),
            enabledBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: HexColor("#ed7d31"),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: HexColor("#ed7d31"),
                width: 2.0,
              ),
            ),
            hintText: '',
            hintStyle: TextStyle(
              color: HexColor("#a8a8a8"),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            labelText: 'Reported Qty',
            labelStyle: TextStyle(
              color: HexColor("#ed7d31"),
            ),
            counterText: '',
            suffixIcon: Container(
              padding: const EdgeInsets.all(0),
              width: 15.0,
              height: 15.0,
              child: _reportedQty.text.isNotEmpty
                  ? IconButton(
                      alignment: Alignment.centerLeft,
                      icon: Image.asset(
                        'assets/images/close.png',
                        scale: 1.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _reportedQty.clear();
                        });
                        FocusScope.of(context).requestFocus(_nodeReportedQty);
                        // disActivenodeBarcode = false;
                        // disActivenodelocationNo = false;
                      },
                    )
                  : null,
            ),
          ),
          onChanged: (value) {
            setState(() {
              var text = value;

              _reportedQty.text = text;
              _reportedQty.selection = TextSelection.fromPosition(
                  TextPosition(offset: _reportedQty.text.length));

              if ((double.tryParse(text) ?? 0.0) > 0.0) {
                qtySuccess = true;
              } else {
                qtySuccess = false;
                isError['qtySuccess'] = 'Please check the information again.';
              }
            });
          },
          // onSubmitted: _onChangedreportedQty,
          onFieldSubmitted: (v) {
            // _onChangedreportedQty,
          }
          // onChanged: _onChangedreportedQty,
          ),
    );
  }

  Widget saveButton() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        child: const Text(
          'Confirm Reported Qty',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: HexColor('#4472c4'),
          minimumSize: const Size.fromHeight(
              50), // fromHeight use double.infinity as width and 40 is the height
        ),
        onPressed: (disActivenodeBarcode ||
                disActivenodelocationNo ||
                disActivenodeQty)
            ? null
            : () async {
                try {
                  /// check data //
                  ApiSettings apiData = ApiSettings();
                  dataSetting = database.values.toList();
                  for (var item in dataSetting) {
                    if (item.baseName == ApiProxyParameter.dataBaseSelect) {
                      apiData = item;
                    }
                  }

                  AllApiProxy proxy = AllApiProxy();
                  proxy.host = '${apiData.apiUrl}';
                  proxy.dbName = '${apiData.serviceName}';
                  proxy.dbHost = '${apiData.serviceIp}';
                  proxy.dbPort = int.parse('${apiData.port}');
                  proxy.dbUser = ApiProxyParameter.userLogin;
                  proxy.dbPass = ApiProxyParameter.passLogin;

                  var result = await proxy.getDataByBarcodeIdWIP(
                      shopOrderReceiveWIPReq(
                          barcodeId: (_barcodeID.text.isNotEmpty
                              ? int.parse(_barcodeID.text)
                              : 0),
                          remainingQty: 0.0,
                          reportedQty: 0.0,
                          stdPackSize: 0.0));

                  if (result.errorMessage == null) {
                    barcodeIdSuccess = true;
                  } else {
                    barcodeIdSuccess = false;
                    isError['barcodeIdSuccess'] = '${result.errorMessage}';
                  }

                  var result2 = await proxy.getLocationDescriptionWIP(
                      shopOrderReceiveWIPReq(
                          barcodeId: 0,
                          locationNo: (_locationNo.text.isNotEmpty
                              ? _locationNo.text
                              : ''),
                          remainingQty: 0.0,
                          reportedQty: 0.0,
                          stdPackSize: 0.0));

                  if (result2.errorMessage == null) {
                    locationNoSuccess = true;
                  } else {
                    locationNoSuccess = false;
                    isError['locationNoSuccess'] = '${result2.errorMessage}';
                  }
                } on SocketException catch (e) {
                  barcodeIdSuccess = false;
                  isError['barcodeIdSuccess'] = '$e';
                } on Exception catch (e) {
                  barcodeIdSuccess = false;
                  isError['barcodeIdSuccess'] = '$e';
                }

                print('null : ' + disbutton.toString());
                print(disActivenodeBarcode);
                print(disActivenodelocationNo);
                print(disActivenodeQty);
                print(isError);
                print('barcodeIdSuccess :' + barcodeIdSuccess.toString());
                print('locationNoSuccess :' + locationNoSuccess.toString());
                print('qtySuccess :' + qtySuccess.toString());
                _reportedQty.text =
                    (double.tryParse(_reportedQty.text) ?? 0.0).toString();
                if ((double.tryParse(_reportedQty.text) ?? 0.0) > 0) {
                  qtySuccess = true;
                } else {
                  if ((double.tryParse(_reportedQty.text) ?? 0.0) < 1) {
                    qtySuccess = false;
                    isError['qtySuccess'] = 'Reported Qty is zero.';
                  } else if ((double.tryParse(_reportedQty.text) ?? 0.0) >
                      stdPackSize) {
                    qtySuccess = false;
                    isError['qtySuccess'] =
                        'Max of Reported Qty ${stdPackSize.toString()}.';
                  }
                }

                if (disActivenodeBarcode == true ||
                    disActivenodelocationNo == true ||
                    disActivenodeQty == true) {
                } else {
                  if (barcodeIdSuccess == false ||
                      locationNoSuccess == false ||
                      qtySuccess == false) {
                    String txtError = '';
                    if (!barcodeIdSuccess) {
                      txtError = isError['barcodeIdSuccess'] ?? '';
                    } else if (!locationNoSuccess) {
                      txtError = isError['locationNoSuccess'] ?? '';
                    } else if (!qtySuccess) {
                      txtError = isError['qtySuccess'] ?? '';
                    }
                    Tdialog.errorDialog(
                      context,
                      'Error',
                      txtError,
                      okButton(),
                    );

                    // isError

                  } else {
                    Tdialog.infoDialog(
                      context,
                      'Confirm reported Qty',
                      'Are you sure to confirm reported Qty',
                      acceptButton(shopOrderReceivedWIP),
                      cancelButton(),
                    );
                  }
                }
              },
      ),
    );
  }

  Widget acceptButton(function_) {
    return TextButton(
      onPressed: () async {
        // if (_onChangedreportedQty(_reportedQty.text))
        Navigator.pop(context, 'ACCEPT');
        if (isOverRemaining == true) {
          if (isLastBarcode == true) {
            Tdialog.infoDialog(
              context,
              'Confirm reported Qty',
              'Reported qty is over than the remaining qty. Are you sure to report this qty?',
              acceptRemainTrue(shopOrderReceivedWIP),
              cancelButton(),
            );
          }
        } else {
          double value = double.parse(
              _reportedQty.text.replaceAll(',', '').replaceAll('-', ''));
          if (stdPackSize == value) {
            if (await function_()) {
              // Tdialog.successDialog(
              //   context,
              //   'Information',
              //   'Reported Quantity has been confirmed.',
              //   TextButton(
              //     onPressed: () {
              //       Navigator.pop(context, 'OK');
              //       _barcodeID.text = '';
              //       _resetData();
              //       FocusScope.of(context).requestFocus(_nodeBarcodeID);
              //     },
              //     child: Text(
              //       'OK',
              //       style: TextStyle(
              //         color: HexColor("#5b9bd5"),
              //       ),
              //     ),
              //   ),
              // );

              ScaffoldMessenger.of(context).showSnackBar(
                  Tdialog.successSnackbar(context,
                      'Reported Quantity has been confirmed.', heightScreen));
              Navigator.pop(context, 'OK');
              _barcodeID.text = '';
              _resetData();
              FocusScope.of(context).requestFocus(_nodeBarcodeID);
            } else {
              FocusScope.of(context).requestFocus(_nodeBarcodeID);
            }
          } else {
            if (stdPackSize > value) {
              Tdialog.infoDialog(
                context,
                'Confirm reported Qty',
                'Reported qty is lower than the original qty. Are you sure to report this qty?',
                acceptRemainFalse(shopOrderReceivedWIP),
                cancelButton(),
              );
            } else {
              if (isLastBarcode == true) {
                Tdialog.infoDialog(
                  context,
                  'Confirm reported Qty',
                  'Reported qty is over than the remaining qty. Are you sure to report this qty?',
                  acceptRemainTrue(shopOrderReceivedWIP),
                  cancelButton(),
                );
              } else {
                Tdialog.errorDialog(
                  context,
                  'Error',
                  'Max of Reported Qty ${stdPackSize.toString()}.',
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        _reportedQty.text = stdPackSize.toString();
                      });
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: HexColor("#5b9bd5"),
                      ),
                    ),
                  ),
                );
              }
            }
          }
        }

        //_save();
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget acceptRemainFalse(function_) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'ACCEPT');
        if (await function_()) {
          // Tdialog.successDialog(
          //   context,
          //   'Information',
          //   'Reported Quantity has been confirmed. There is a new generated Barcode ID.',
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context, 'OK');
          //       _barcodeID.text = '';
          //       _resetData();
          //       FocusScope.of(context).requestFocus(_nodeBarcodeID);
          //     },
          //     child: Text(
          //       'OK',
          //       style: TextStyle(
          //         color: HexColor("#5b9bd5"),
          //       ),
          //     ),
          //   ),
          // );

          ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
              context,
              'Reported Quantity has been confirmed. There is a new generated Barcode ID.',
              heightScreen));
          Navigator.pop(context, 'OK');
          _barcodeID.text = '';
          _resetData();
          FocusScope.of(context).requestFocus(_nodeBarcodeID);
        } else {
          FocusScope.of(context).requestFocus(_nodeBarcodeID);
        }
        //_save();
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget acceptRemainTrue(function_) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'ACCEPT');
        if (await function_()) {
          // Tdialog.successDialog(
          //   context,
          //   'Information',
          //   'Reported Quantity has been confirmed.',
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context, 'OK');
          //       _barcodeID.text = '';
          //       _resetData();
          //       FocusScope.of(context).requestFocus(_nodeBarcodeID);
          //     },
          //     child: Text(
          //       'OK',
          //       style: TextStyle(
          //         color: HexColor("#5b9bd5"),
          //       ),
          //     ),
          //   ),
          // );

          ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
              context, 'Reported Quantity has been confirmed.', heightScreen));
          Navigator.pop(context, 'OK');
          _barcodeID.text = '';
          _resetData();
          FocusScope.of(context).requestFocus(_nodeBarcodeID);
        } else {
          FocusScope.of(context).requestFocus(_nodeBarcodeID);
        }
        //_save();
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget cancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'CANCEL');
      },
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget okButton() {
    return TextButton(
      onPressed: () {
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
