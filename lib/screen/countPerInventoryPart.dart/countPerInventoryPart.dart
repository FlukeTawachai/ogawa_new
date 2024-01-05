import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
// import 'package:ogawa_nec/CountPerInventoryPart.dart/sweetAlert/aweetAlert.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';

import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ogawa_nec/api/request/countPerInventoryPartReq.dart';

class CountPerInventoryPart extends StatefulWidget {
  const CountPerInventoryPart({Key? key}) : super(key: key);

  @override
  State<CountPerInventoryPart> createState() => _CountPerInventoryPartState();
}

class _CountPerInventoryPartState extends State<CountPerInventoryPart> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  final FocusNode nodeBarcodeID = FocusNode();
  final FocusNode nodePartNo = FocusNode();
  final FocusNode nodeLotNo = FocusNode();
  final FocusNode nodeWDRNo = FocusNode();
  final FocusNode nodeLocationNo = FocusNode();
  final FocusNode nodeCountedQty = FocusNode();
  final TextEditingController barcodeID = TextEditingController();
  final TextEditingController partNo = TextEditingController();
  final TextEditingController partName = TextEditingController();
  final TextEditingController lotNo = TextEditingController();
  final TextEditingController wDRNo = TextEditingController();
  final TextEditingController locationNo = TextEditingController();
  final TextEditingController locationDESC = TextEditingController();
  final TextEditingController countedQty = TextEditingController();
  final TextEditingController uom = TextEditingController();
  var activeFocus = 1;
  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  bool warning = false;

  var disActivenodeBarcodeID = false;
  var disActivenodePartNo = false;
  var disActivenodeLotNo = false;
  var disActivenodeWDRNo = false;
  var disActivenodeLocationNo = false;
  var disActivenodeCountedQty = false;

  var barcodeIdSuccess = false;
  var partNoSuccess = false;
  var locationNoSuccess = false;
  var countedQtyNoSuccess = false;
  var countgetDataByBarcodeId = 0;
  var isError = {
    'barcodeIdSuccess': 'Please check the information is correct.',
    'partNoSuccess': 'Please check the information is correct.',
    'locationNoSuccess': 'Please check the information is correct.',
    'countedQtyNoSuccess': 'Please check the information is correct.',
  };

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    nodeBarcodeID.addListener(_setActiveNode);
    nodeLotNo.addListener(_setActiveNode);
    nodePartNo.addListener(_setActiveNode);
    nodeWDRNo.addListener(_setActiveNode);
    nodeLocationNo.addListener(_setActiveNode);
    nodeCountedQty.addListener(_setActiveNode);
  }

  void _setActiveNode() async {
    if (nodeBarcodeID.hasFocus.toString() == 'true') {
      disActivenodeBarcodeID = true;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      countgetDataByBarcodeId = 0;
    } else if (nodeLocationNo.hasFocus.toString() == 'true') {
      disActivenodeBarcodeID = false;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = true;
      countgetDataByBarcodeId = 0;
    } else if (nodeCountedQty.hasFocus.toString() == 'true') {
      disActivenodeBarcodeID = false;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      countgetDataByBarcodeId = 0;
    } else if (nodePartNo.hasFocus.toString() == 'true') {
      disActivenodeBarcodeID = false;
      disActivenodePartNo = true;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      countgetDataByBarcodeId = 0;
    }

    if (disActivenodeBarcodeID &&
        nodeBarcodeID.hasFocus.toString() == 'false') {
      disActivenodeBarcodeID = false;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      var text = barcodeID.text;
      var textList = text.split("|");
      if (barcodeID.text != '') {
        await getDataByBarcodeId(textList[0]);
      }
    } else if (disActivenodeLocationNo &&
        nodeLocationNo.hasFocus.toString() == 'false') {
      disActivenodeBarcodeID = false;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      if (locationNo.text != '') {
        await getLocationDescription(locationNo.text, false);
      }
    } else if (disActivenodeCountedQty &&
        nodeCountedQty.hasFocus.toString() == 'false') {
      countedQtyNoSuccess = false;
      disActivenodeBarcodeID = false;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      double txt = double.tryParse(
              countedQty.text.replaceAll(',', '').replaceAll('-', '0')) ??
          0;
      setState(() {
        countedQty.text = txt.toString();
      });
      isError['barcodeIdSuccess'] = 'Please check the information again.';
      countedQtyNoSuccess = (txt > 0);
      // await getLocationDescription(locationNo.text, false);
    } else if (disActivenodePartNo &&
        nodePartNo.hasFocus.toString() == 'false') {
      disActivenodeBarcodeID = false;
      disActivenodePartNo = false;
      disActivenodeLotNo = false;
      disActivenodeWDRNo = false;
      disActivenodeCountedQty = false;
      disActivenodeLocationNo = false;
      if (partNo.text != '') {
        await getPartDescription(partNo.text, false);
      }
    }
  }

  reportCountPart() async {
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

      var result = await proxy.reportCountPart(countPerInventoryPartReq(
          barcodeId:
              (barcodeID.text.isNotEmpty ? int.parse(barcodeID.text) : 0),
          partNo: partNo.text,
          locationNo: locationNo.text,
          lotNo: lotNo.text,
          wdrNo: wDRNo.text,
          countQty: double.parse(countedQty.text.isNotEmpty
              ? countedQty.text.replaceAll(',', '')
              : '0')));
      countedQtyNoSuccess = false;
      if (result.errorMessage == null) {
        countedQtyNoSuccess = true;
        // setState(() {
        //   // charLength = value.length;
        //   // locationNo.text = result.partNo ?? '';
        //   // locationDESC.text = result.partDesc ?? '';
        // });

        EasyLoading.dismiss();
        if (result.warningMessage != null) {
          Tdialog.infoDialog(context, "Warning", "${result.warningMessage}",
              okButton(), Container());
          warning = true;
        }
        setState(() {
          barcodeID.clear();
          partNo.clear();
          partName.clear();
          lotNo.clear();
          wDRNo.clear();
          locationNo.clear();
          locationDESC.clear();
          countedQty.clear();
          uom.clear();
        });
        FocusScope.of(context).requestFocus(nodeBarcodeID);
        return true;
      } else {
        isError['countedQtyNoSuccess'] = result.errorMessage ?? '';
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

  getLocationDescription(String value, bool fousNext) async {
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

      var result = await proxy.getLocationDescription(countPerInventoryPartReq(
          barcodeId:
              (barcodeID.text.isNotEmpty ? int.parse(barcodeID.text) : 0),
          partNo: partNo.text,
          countQty: double.parse(countedQty.text.isNotEmpty
              ? countedQty.text.replaceAll(',', '')
              : '0'),
          locationNo: locationNo.text,
          lotNo: lotNo.text,
          wdrNo: wDRNo.text));
      locationNoSuccess = false;
      if (result.errorMessage == null) {
        locationNoSuccess = true;
        setState(() {
          // charLength = value.length;
          locationNo.text = result.locationNo ??
              (locationNo.text.isNotEmpty ? locationNo.text : '');
          locationDESC.text = result.locationDesc ?? '';
        });
        if (fousNext) FocusScope.of(context).requestFocus(nodeCountedQty);
      } else {
        isError['locationNoSuccess'] = result.errorMessage ?? '';
        locationDESC.text = '';
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        // if (fousNext) FocusScope.of(context).requestFocus(nodeLocationNo);
        // wrongDialog();
      }
      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      // wrongDialog(e.message);
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
      // if (fousNext) FocusScope.of(context).requestFocus(nodeLocationNo);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      // wrongDialog(e.toString());
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
      // if (fousNext) FocusScope.of(context).requestFocus(nodeLocationNo);
    }
  }

  getPartDescription(String value, bool fousNext) async {
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
      partNoSuccess = false;
      var result = await proxy.getPartDescription(countPerInventoryPartReq(
          barcodeId:
              (barcodeID.text.isNotEmpty ? int.parse(barcodeID.text) : 0),
          partNo: partNo.text,
          countQty: double.parse(countedQty.text.isNotEmpty
              ? countedQty.text.replaceAll(',', '')
              : '0')));
      if (result.errorMessage == null) {
        partNoSuccess = true;
        setState(() {
          // charLength = value.length;
          partNo.text =
              result.partNo ?? (partNo.text.isNotEmpty ? partNo.text : '');
          partName.text = result.partDesc ?? '';
        });
        if (fousNext) FocusScope.of(context).requestFocus(nodeLotNo);
      } else {
        isError['partNoSuccess'] = result.errorMessage ?? '';
        partName.text = '';
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        // if (fousNext) FocusScope.of(context).requestFocus(nodePartNo);
        // wrongDialog();
      }
      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      // wrongDialog(e.message);
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
      // if (fousNext) FocusScope.of(context).requestFocus(nodePartNo);
    } on Exception catch (e) {
      EasyLoading.dismiss();
      // wrongDialog(e.toString());
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
      // if (fousNext) FocusScope.of(context).requestFocus(nodePartNo);
    }
  }

  getDataByBarcodeId(String value) async {
    try {
      print('check' + (countgetDataByBarcodeId < 1).toString());
      if (countgetDataByBarcodeId < 1) {
        countgetDataByBarcodeId = countgetDataByBarcodeId + 1;
        print('dddd : ' + countgetDataByBarcodeId.toString());
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

        var result = await proxy.getDataByBarcodeId(countPerInventoryPartReq(
            barcodeId: int.parse(barcodeID.text),
            countQty: double.parse(countedQty.text.isNotEmpty
                ? countedQty.text.replaceAll(',', '')
                : '0')));
        barcodeIdSuccess = false;
        partNoSuccess = false;
        if (result.errorMessage == null) {
          barcodeIdSuccess = true;
          partNoSuccess = true;
          setState(() {
            // charLength = value.length;
            barcodeID.text = value;
            partNo.text = result.partNo ?? '';
            partName.text = result.partDesc ?? '';
            lotNo.text = result.lotNo ?? '';
            wDRNo.text = result.wdrNo ?? '';
            locationNo.text = result.locationNo ?? '';
            locationDESC.text = result.locationDesc ?? '';
            countedQty.text =
                Utility.formNum((result.countQty ?? '0').toString());
            uom.text = result.uom ?? '';
          });
          FocusScope.of(context).requestFocus(nodeLocationNo);
        } else {
          isError['barcodeIdSuccess'] = result.errorMessage ?? '';
          Tdialog.errorDialog(
            context,
            'Error',
            '${result.errorMessage}',
            okButton(),
          );

          // FocusScope.of(context).requestFocus(nodeBarcodeID);
        }
        EasyLoading.dismiss();
      }
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
      // FocusScope.of(context).requestFocus(nodeBarcodeID);
      // wrongDialog();
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
      // FocusScope.of(context).requestFocus(nodeBarcodeID);
      // wrongDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    clearData() {
      setState(() {
        barcodeID.clear();
        partNo.clear();
        partName.clear();
        lotNo.clear();
        wDRNo.clear();
        // locationNo.clear();
        locationDESC.clear();
        countedQty.clear();
        uom.clear();
        activeFocus = 1;
      });
    }

    autoAction(String value) {
      setState(() {
        if (!value.isNotEmpty) {
          setState(() {
            var text = value;
            var textList = text.split("|");
            partNo.clear();
            partName.clear();
            lotNo.clear();
            wDRNo.clear();
            // LocationNo.clear();
            locationDESC.clear();
            countedQty.clear();
            uom.clear();
            barcodeID.text = textList[0];
            barcodeID.selection = TextSelection.fromPosition(
                TextPosition(offset: barcodeID.text.length));
            barcodeIdSuccess = false;
            isError['barcodeIdSuccess'] = 'Please check the information again.';
          });
        }
      });
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Count Per Inventory Part",
              style: TextStyle(fontSize: 16),
            ),
          ),
          backgroundColor: HexColor('2056AE'),
          // actions: const [ActionSort()],
        ),
        drawer: const MenuSide(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.search,
                        enabled: true,
                        autofocus: true,
                        focusNode: nodeBarcodeID,
                        enableInteractiveSelection: false,
                        keyboardType: TextInputType.number,
                        readOnly: false,
                        controller: barcodeID,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#ed7d31"))),
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
                            child: barcodeID.text.isNotEmpty
                                ? IconButton(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.cancel),
                                    onPressed: (() {
                                      disActivenodePartNo = false;
                                      disActivenodeLocationNo = false;
                                      clearData();
                                      barcodeIdSuccess = false;
                                      isError['barcodeIdSuccess'] =
                                          'Please check the information again.';
                                      FocusScope.of(context)
                                          .requestFocus(nodeBarcodeID);
                                    }),
                                  )
                                : null,
                          ),
                        ),
                        onChanged: autoAction,
                        onFieldSubmitted: (v) async {
                          var text = v;
                          var textList = text.split("|");
                          setState(() {
                            barcodeID.text = textList[0];
                            barcodeID.selection = TextSelection.fromPosition(
                                TextPosition(offset: barcodeID.text.length));
                          });
                          await getDataByBarcodeId(textList[0]);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        enabled: true,
                        //autofocus: true,
                        focusNode: nodePartNo,
                        enableInteractiveSelection: false,
                        readOnly: false,
                        controller: partNo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#9dc3e6"))),
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
                          labelText: 'Part No',
                          labelStyle: TextStyle(
                            color: HexColor("#9dc3e6"),
                          ),
                          counterText: '',
                          suffixIcon: Container(
                            padding: const EdgeInsets.all(0),
                            width: 15.0,
                            height: 15.0,
                            child: partNo.text.isNotEmpty
                                ? IconButton(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        partNo.clear();
                                        barcodeID.clear();
                                        barcodeIdSuccess = false;
                                        isError['barcodeIdSuccess'] =
                                            'Please check the information again.';
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(nodePartNo);
                                    },
                                  )
                                : null,
                          ),
                        ),
                        onChanged: ((value) {
                          setState(() {
                            barcodeID.clear();
                            barcodeIdSuccess = false;
                            isError['barcodeIdSuccess'] =
                                'Please check the information again.';
                          });
                          // autoNextCursur([partNo.text, 2], nodeLotNo);
                        }),
                        onFieldSubmitted: (v) async {
                          // await getPartDescription(v, true);
                          FocusScope.of(context).requestFocus(nodeLotNo);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    enabled: false,
                    //autofocus: true,
                    enableInteractiveSelection: false,
                    maxLength: 100,
                    readOnly: true,
                    controller: partName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
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
                      contentPadding:
                          const EdgeInsets.only(top: 15, left: 15.0),
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
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        enabled: true,
                        //autofocus: true,
                        focusNode: nodeLotNo,
                        enableInteractiveSelection: false,
                        readOnly: false,
                        controller: lotNo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#9dc3e6"))),
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
                          labelText: 'Lot No',
                          labelStyle: TextStyle(
                            color: HexColor("#9dc3e6"),
                          ),
                          counterText: '',
                          suffixIcon: Container(
                            padding: const EdgeInsets.all(0),
                            width: 15.0,
                            height: 15.0,
                            child: lotNo.text.isNotEmpty
                                ? IconButton(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        lotNo.clear();
                                        barcodeID.clear();
                                        barcodeIdSuccess = false;
                                        isError['barcodeIdSuccess'] =
                                            'Please check the information again.';
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(nodeLotNo);
                                    },
                                  )
                                : null,
                          ),
                        ),
                        onChanged: ((value) {
                          setState(() {
                            barcodeID.clear();
                            barcodeIdSuccess = false;
                            isError['barcodeIdSuccess'] =
                                'Please check the information again.';
                          });
                        }),
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(nodeWDRNo);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        enabled: true,
                        //autofocus: true,
                        focusNode: nodeWDRNo,
                        enableInteractiveSelection: false,
                        readOnly: false,
                        controller: wDRNo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#9dc3e6"))),
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
                          labelText: 'W/D/R No',
                          labelStyle: TextStyle(
                            color: HexColor("#9dc3e6"),
                          ),
                          counterText: '',
                          suffixIcon: Container(
                            padding: const EdgeInsets.all(0),
                            width: 15.0,
                            height: 15.0,
                            child: wDRNo.text.isNotEmpty
                                ? IconButton(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        wDRNo.clear();
                                        barcodeID.clear();
                                        barcodeIdSuccess = false;
                                        isError['barcodeIdSuccess'] =
                                            'Please check the information again.';
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(nodeWDRNo);
                                    },
                                  )
                                : null,
                          ),
                        ),
                        onChanged: ((value) {
                          setState(() {
                            barcodeID.clear();
                            barcodeIdSuccess = false;
                            isError['barcodeIdSuccess'] =
                                'Please check the information again.';
                          });
                        }),

                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(nodeLocationNo);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        enabled: true,
                        //autofocus: true,
                        focusNode: nodeLocationNo,
                        enableInteractiveSelection: false,
                        readOnly: false,
                        controller: locationNo,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#9dc3e6"))),
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
                            child: locationNo.text.isNotEmpty
                                ? IconButton(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        locationNo.clear();
                                        locationNoSuccess = false;
                                        isError['locationNoSuccess'] =
                                            'Please check the information again.';
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(nodeLocationNo);
                                    },
                                  )
                                : null,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            var text = value;

                            locationNo.text = text;
                            locationNo.selection = TextSelection.fromPosition(
                                TextPosition(offset: locationNo.text.length));
                            locationNoSuccess = false;
                            isError['locationNoSuccess'] =
                                'Please check the information again.';
                          });
                        },
                        onFieldSubmitted: (v) async {
                          // await getLocationDescription(v, false);
                          FocusScope.of(context).requestFocus(nodeCountedQty);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: Container()),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        //autofocus: true,
                        enableInteractiveSelection: false,
                        maxLength: 100,
                        readOnly: true,
                        controller: locationDESC,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
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
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#a6a6a6"))),
                          enabledBorder: OutlineInputBorder(
                            //borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: HexColor("#a6a6a6"),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        enabled: true,
                        //autofocus: true,
                        keyboardType: TextInputType.number,
                        focusNode: nodeCountedQty,
                        enableInteractiveSelection: false,
                        readOnly: false,
                        controller: countedQty,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#9dc3e6"))),
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
                          labelText: 'Counted Qty',
                          labelStyle: TextStyle(
                            color: HexColor("#9dc3e6"),
                          ),
                          counterText: '',
                          suffixIcon: Container(
                            padding: const EdgeInsets.all(0),
                            width: 15.0,
                            height: 15.0,
                            child: countedQty.text.isNotEmpty
                                ? IconButton(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.black54,
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        countedQty.clear();
                                        isError['countedQtyNoSuccess'] =
                                            'Please check the information again.';
                                      });
                                      FocusScope.of(context)
                                          .requestFocus(nodeCountedQty);
                                    },
                                  )
                                : null,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            var text = value;

                            countedQty.text = text;
                            countedQty.selection = TextSelection.fromPosition(
                                TextPosition(offset: countedQty.text.length));

                            countedQtyNoSuccess = false;
                            isError['countedQtyNoSuccess'] =
                                'Please check the information again.';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        enabled: false,
                        //autofocus: true,
                        enableInteractiveSelection: false,
                        maxLength: 100,
                        readOnly: true,
                        controller: uom,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
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
                          contentPadding:
                              const EdgeInsets.only(top: 15, left: 15.0),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: HexColor("#a6a6a6"))),
                          enabledBorder: OutlineInputBorder(
                            //borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: HexColor("#a6a6a6"),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text(
                            'Confirm Counted Qty',
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
                          onPressed: (disActivenodeBarcodeID == true ||
                                  disActivenodePartNo == true ||
                                  disActivenodeLotNo == true ||
                                  disActivenodeWDRNo == true ||
                                  disActivenodeCountedQty == true ||
                                  disActivenodeLocationNo == true)
                              ? null
                              : () async {
                                  // check
                                  try {
                                    ApiSettings apiData = ApiSettings();
                                    dataSetting = database.values.toList();
                                    for (var item in dataSetting) {
                                      if (item.baseName ==
                                          ApiProxyParameter.dataBaseSelect) {
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

                                    if (barcodeID.text != '') {
                                      var result = await proxy
                                          .getDataByBarcodeId(
                                              countPerInventoryPartReq(
                                                  barcodeId: int
                                                          .tryParse(
                                                              barcodeID.text) ??
                                                      0,
                                                  countQty: double
                                                      .tryParse(
                                                          countedQty.text
                                                                  .isNotEmpty
                                                              ? countedQty.text
                                                                  .replaceAll(
                                                                      ',', '')
                                                              : '0')));

                                      if (result.errorMessage == null) {
                                        barcodeIdSuccess = true;
                                      } else {
                                        barcodeIdSuccess = false;
                                        isError['barcodeIdSuccess'] =
                                            result.errorMessage ?? '';
                                      }

                                      var result2 =
                                          await proxy.getLocationDescription(
                                              countPerInventoryPartReq(
                                                  barcodeId:
                                                      (barcodeID.text.isNotEmpty
                                                          ? int.tryParse(
                                                              barcodeID.text)
                                                          : 0),
                                                  partNo: partNo.text,
                                                  countQty: double.tryParse(
                                                      countedQty.text.isNotEmpty
                                                          ? countedQty.text
                                                              .replaceAll(
                                                                  ',', '')
                                                          : '0'),
                                                  locationNo: locationNo.text,
                                                  lotNo: lotNo.text,
                                                  wdrNo: wDRNo.text));

                                      if (result2.errorMessage == null) {
                                        locationNoSuccess = true;
                                      } else {
                                        locationNoSuccess = false;
                                        isError['locationNoSuccess'] =
                                            result2.errorMessage ?? '';
                                      }
                                      var result3 =
                                          await proxy.getPartDescription(
                                              countPerInventoryPartReq(
                                                  barcodeId:
                                                      (barcodeID.text.isNotEmpty
                                                          ? int.parse(
                                                              barcodeID.text)
                                                          : 0),
                                                  partNo: partNo.text,
                                                  countQty: double.parse(
                                                      countedQty.text.isNotEmpty
                                                          ? countedQty.text
                                                              .replaceAll(
                                                                  ',', '')
                                                          : '0')));
                                      if (result3.errorMessage == null) {
                                        partNoSuccess = true;
                                      } else {
                                        partNoSuccess = false;
                                        isError['partNoSuccess'] =
                                            result3.errorMessage ?? '';
                                      }
                                    } else {
                                      barcodeIdSuccess = false;
                                      isError['barcodeIdSuccess'] =
                                          'Please check the information is correct.';
                                    }
                                  } on SocketException catch (e) {
                                    barcodeIdSuccess = false;
                                    isError['barcodeIdSuccess'] = '$e';
                                  } on Exception catch (e) {
                                    barcodeIdSuccess = false;
                                    isError['barcodeIdSuccess'] = '$e';
                                  }
                                  // end check //
                                  countedQty.text =
                                      (double.tryParse(countedQty.text) ?? 0.0)
                                          .toString();
                                  if ((double.tryParse(countedQty.text) ??
                                          0.0) >
                                      0) {
                                    countedQtyNoSuccess = true;
                                  } else {
                                    countedQtyNoSuccess = false;
                                  }
                                  if (disActivenodeBarcodeID == true ||
                                      disActivenodePartNo == true ||
                                      disActivenodeLotNo == true ||
                                      disActivenodeWDRNo == true ||
                                      disActivenodeCountedQty == true ||
                                      disActivenodeLocationNo == true) {
                                  } else {
                                    if (barcodeIdSuccess == false ||
                                        partNoSuccess == false ||
                                        locationNoSuccess == false ||
                                        countedQtyNoSuccess == false) {
                                      // isError

                                      String txtError = '';
                                      if (!barcodeIdSuccess) {
                                        txtError =
                                            isError['barcodeIdSuccess'] ?? '';
                                      } else if (!partNoSuccess) {
                                        txtError =
                                            isError['partNoSuccess'] ?? '';
                                      } else if (!locationNoSuccess) {
                                        txtError =
                                            isError['locationNoSuccess'] ?? '';
                                      } else if (!countedQtyNoSuccess) {
                                        txtError = 'Reported Qty is zero.';
                                      }
                                      Tdialog.errorDialog(
                                        context,
                                        'Error',
                                        txtError,
                                        okButton(),
                                      );
                                    } else {
                                      await Tdialog.infoDialog(
                                        context,
                                        'Confirm Counted Qty?',
                                        'Are you sure to confirm Counted Qty?',
                                        acceptButton(reportCountPart),
                                        cancelButton(),
                                      );
                                    }
                                  }

                                  // showAlertInfo(context, clearAll);
                                  // Tdialog.infoDialog(
                                  //   context,
                                  //   'Confirm reported Qty',
                                  //   'Are you sure to confirm reported Qty',
                                  //   Sample.save(),
                                  //   Sample.save(),
                                  // );
                                  // Comfirm Counted Qty ? Information : Error
                                },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget acceptButton(function_) {
    return TextButton(
      onPressed: () async {
        //go to function.....
        print("@@@@@@@@@@@@@@");
        Navigator.pop(context, 'ACCEPT');
        if (await function_()) {
          if (warning == false) {
            // Tdialog.successDialog(
            //   context,
            //   'Information',
            //   'Counted Quantity has been reported. Please contact to approver to get approval.',
            //   TextButton(
            //     onPressed: () {
            //       Navigator.pop(context, 'OK');
            //       setState(() {
            //         partNo.clear();
            //         partName.clear();
            //         lotNo.clear();
            //         wDRNo.clear();
            //         locationNo.clear();
            //         locationDESC.clear();
            //         countedQty.clear();
            //         uom.clear();
            //       });
            //       FocusScope.of(context).requestFocus(nodeBarcodeID);
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
                'Counted Quantity has been reported. Please contact to approver to get approval.',
                heightScreen));
            setState(() {
              partNo.clear();
              partName.clear();
              lotNo.clear();
              wDRNo.clear();
              locationNo.clear();
              locationDESC.clear();
              countedQty.clear();
              uom.clear();
            });
            Navigator.pop(context, 'OK');
          }
        } else {
          FocusScope.of(context).requestFocus(nodeBarcodeID);
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
