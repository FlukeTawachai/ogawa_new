import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/reportMaterialRequisitionReq.dart';
import 'package:ogawa_nec/api/response/reportMaterialRequisitionResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/screen/reportMaterialRequisition/partCard.dart';

import 'boxInsertData.dart';

var searchInput = "Please input Count Report No";

class ImportReportMaterialRequisition extends StatefulWidget {
  final ReportMaterialRequisitionResp data;
  const ImportReportMaterialRequisition({Key? key, required this.data})
      : super(key: key);
  @override
  State<ImportReportMaterialRequisition> createState() =>
      _ImportReportMaterialRequisitionState();
}

class _ImportReportMaterialRequisitionState
    extends State<ImportReportMaterialRequisition> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  final FocusNode nodeBarcodeID = FocusNode();
  final FocusNode nodenewQuantity = FocusNode();
  final TextEditingController barcodeID = TextEditingController();
  final TextEditingController newQuantity = TextEditingController();
  var search = TextEditingController();
  int counter = 0;
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  List<ReportMaterialRequisitionBarcode> reportMaterialList = [];
  late Box<ReportMaterialRequisitionBarcode> reportMaterialData;
  var numFormat = NumberFormat("#,###.##", "en_US");
  String barcodeId = '';
  bool reAdd = true;
  String _newData = '';

  actionDelete(delbarcodeID) {
    return TextButton(
      onPressed: () {
        if (delbarcodeID != '') {
          setState(() {
            for (int i = 0; i < GlobalParam.dataListHBarcode.length; i++) {
              if (GlobalParam.dataListHBarcode[i].barcodeId ==
                  int.parse(delbarcodeID)) {
                setRemain(GlobalParam.dataListHBarcode[i], 0);
                GlobalParam.dataListHBarcode.removeAt(i);
              }
            }
          });

          reportMaterialList = reportMaterialData.values.toList();
          for (int i = 0; i < reportMaterialList.length; i++) {
            if (reportMaterialList[i].materialReqNo ==
                widget.data.materialReqNo) {
              if (reportMaterialList[i].internalCustomerNo ==
                  widget.data.internalCustomerNo) {
                if (reportMaterialList[i].barcodeId ==
                    int.parse(delbarcodeID)) {
                  reportMaterialData.delete(reportMaterialList[i].key);
                }
              }
            }
          }
        }
        Navigator.pop(context, 'OK');
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  // addNewData(_newData) {
  //   print("### barcode ####");
  //   print(_newData);
  //   print("-------------");

  //   if (_newData != '') {
  //     getDataByBarcodeId(int.parse(_newData));
  //   }
  // }

  editDataQty(String loc, _barcodeId) {
    print("### editDataQty ####");
    print(_barcodeId);
    print(loc);
    print("-------------");
    String num = loc.replaceAll(',', '');
    loc = num;
    if (loc != '') {
      if (double.parse(loc) > 0) {
        for (int i = 0; i < GlobalParam.dataListHBarcode.length; i++) {
          if (GlobalParam.dataListHBarcode[i].barcodeId ==
              int.parse(_barcodeId)) {
            GlobalParam.dataListHBarcode[i].reportedQty = double.parse(loc);
            setRemain(GlobalParam.dataListHBarcode[i], double.parse(loc));
          }
        }
        for (int i = 0; i < reportMaterialList.length; i++) {
          if (reportMaterialList[i].materialReqNo ==
              widget.data.materialReqNo) {
            if (reportMaterialList[i].internalCustomerNo ==
                widget.data.internalCustomerNo) {
              if (reportMaterialList[i].barcodeId == int.parse(_barcodeId)) {
                reportMaterialData.delete(reportMaterialList[i].key);
                reportMaterialList[i].reportedQty = double.parse(loc);
                reportMaterialData.put(
                    reportMaterialList[i].id, reportMaterialList[i]);
              }
            }
          }
        }
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          'New Quantity need more than zero.',
          okButton(),
        );
      }
    }
  }

  setRemain(ReportMaterialRequisitionResp data, double value) {
    setState(() {
      for (int i = 0; i < GlobalParam.dataListHRemain.length; i++) {
        if (GlobalParam.dataListHRemain[i].partNo == data.partNo) {
          for (int j = 0; j < GlobalParam.dataListHReserve.length; j++) {
            if (GlobalParam.dataListHReserve[j].partNo == data.partNo) {
              if (GlobalParam.dataListHReserve[j].lotNo == data.lotNo) {
                if (GlobalParam.dataListHReserve[j].wdrNo == data.wdrNo) {
                  var data2 = ReportMaterialRequisitionResp(
                    barcodeId: GlobalParam.dataListHRemain[j].barcodeId,
                    materialReqNo: GlobalParam.dataListHRemain[j].materialReqNo,
                    lineNo: GlobalParam.dataListHRemain[j].lineNo,
                    relNo: GlobalParam.dataListHRemain[j].relNo,
                    internalCustomerNo:
                        GlobalParam.dataListHRemain[j].internalCustomerNo,
                    internalCustomerName:
                        GlobalParam.dataListHRemain[j].internalCustomerName,
                    internalDestinationNo:
                        GlobalParam.dataListHRemain[j].internalDestinationNo,
                    internalDestinationName:
                        GlobalParam.dataListHRemain[j].internalDestinationName,
                    dueDate: GlobalParam.dataListHRemain[j].dueDate,
                    noOfLine: GlobalParam.dataListHRemain[j].noOfLine,
                    partNo: GlobalParam.dataListHRemain[j].partNo,
                    partDesc: GlobalParam.dataListHRemain[j].partDesc,
                    locationNo: GlobalParam.dataListHRemain[j].locationNo,
                    locationDesc: GlobalParam.dataListHRemain[j].locationDesc,
                    lotNo: GlobalParam.dataListHRemain[j].lotNo,
                    wdrNo: GlobalParam.dataListHRemain[j].wdrNo,
                    reservedQty:
                        GlobalParam.dataListHReserve[j].reservedQty! - value,
                    reportedQty: GlobalParam.dataListHRemain[j].reportedQty,
                  );

                  GlobalParam.dataListHRemain[i] = data2;
                }
              }

              // GlobalParam.dataListHRemain[i].reservedQty =
              //     GlobalParam.dataListHReserve[j].reservedQty! - value;
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    reportMaterialData = Hive.box('ReportMaterialRequisitionBarcode');
    reportMaterialList = reportMaterialData.values.toList();
    GlobalParam.dataListHBarcode = [];
    if (reportMaterialList.isNotEmpty) {
      for (int i = 0; i < reportMaterialList.length; i++) {
        if (reportMaterialList[i].materialReqNo == widget.data.materialReqNo) {
          if (reportMaterialList[i].internalCustomerNo ==
              widget.data.internalCustomerNo) {
            // if (reportMaterialList[i].partNo == widget.data.partNo) {
            //   if (reportMaterialList[i].lotNo == widget.data.lotNo) {
            //     if (reportMaterialList[i].wdrNo == widget.data.wdrNo) {
            var data = ReportMaterialRequisitionResp(
              barcodeId: reportMaterialList[i].barcodeId,
              materialReqNo: reportMaterialList[i].materialReqNo,
              lineNo: reportMaterialList[i].lineNo,
              relNo: reportMaterialList[i].relNo,
              internalCustomerNo: reportMaterialList[i].internalCustomerNo,
              internalCustomerName: reportMaterialList[i].internalCustomerName,
              internalDestinationNo:
                  reportMaterialList[i].internalDestinationNo,
              internalDestinationName:
                  reportMaterialList[i].internalDestinationName,
              dueDate: reportMaterialList[i].dueDate,
              noOfLine: reportMaterialList[i].noOfLine,
              partNo: reportMaterialList[i].partNo,
              partDesc: reportMaterialList[i].partDesc,
              locationNo: reportMaterialList[i].locationNo,
              locationDesc: reportMaterialList[i].locationDesc,
              lotNo: reportMaterialList[i].lotNo,
              wdrNo: reportMaterialList[i].wdrNo,
              reservedQty: reportMaterialList[i].reservedQty,
              reportedQty: reportMaterialList[i].reportedQty,
            );
            GlobalParam.dataListHBarcode.add(data);
            setRemain(data, data.reservedQty!);
            //     }
            //   }
            // }
          }
        }
      }
    }
    // delete barcode data
    // for (int i = 0; i < reportMaterialList.length; i++){
    //   reportMaterialData.delete(reportMaterialList[i].key);
    // }
    getDetail('${widget.data.materialReqNo}');
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "${widget.data.materialReqNo} | ${widget.data.internalCustomerNo}",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorWeight: 5,
            indicatorColor: Colors.white,
            // indicatorPadding: EdgeInsets.all(10),
            tabs: <Widget>[
              Tab(
                child: Text("RESERVED"),
              ),
              Tab(
                child: Text("CONFIRMED"),
              ),
              Tab(
                child: Text("REMAIN"),
              ),
            ],
          ),
          backgroundColor: HexColor('2056AE'),
        ),
        drawer: const MenuSide(),
        body: TabBarView(
          children: <Widget>[
            appMainReserved(),
            appMainImp(),
            appMainRemain(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 37,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: Column(
            children: const [BottomBarFooter()],
          ),
        ),
      ),
    );
  }

  Widget appMainRemain() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 25,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${GlobalParam.dataListHRemain.length} record found',
                  style: const TextStyle(
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
          SizedBox(
            height: (heightScreen - 25) * .77,
            width: widthScreen * .98,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: GlobalParam.dataListHRemain.length,
                      itemBuilder: (context, index) {
                        return PathCardReseved(
                            "${GlobalParam.dataListHRemain[index].lineNo}",
                            "${GlobalParam.dataListHRemain[index].relNo}",
                            "${GlobalParam.dataListHRemain[index].lotNo}",
                            numFormat.format(GlobalParam
                                    .dataListHRemain[index].reservedQty! -
                                GlobalParam
                                    .dataListHRemain[index].reportedQty!),
                            "${GlobalParam.dataListHRemain[index].partNo}",
                            "${GlobalParam.dataListHRemain[index].partDesc}",
                            "${GlobalParam.dataListHRemain[index].locationNo}",
                            index,
                            false);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appMainReserved() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 25,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${GlobalParam.dataListHReserve.length} record found',
                  style: const TextStyle(
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
          SizedBox(
            height: (heightScreen - 25) * .77,
            width: widthScreen * .98,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: GlobalParam.dataListHReserve.length,
                      itemBuilder: (context, index) {
                        return PathCardReseved(
                            "${GlobalParam.dataListHReserve[index].lineNo}",
                            "${GlobalParam.dataListHReserve[index].relNo}",
                            "${GlobalParam.dataListHReserve[index].lotNo}",
                            numFormat.format(GlobalParam
                                .dataListHReserve[index].reservedQty),
                            "${GlobalParam.dataListHReserve[index].partNo}",
                            "${GlobalParam.dataListHReserve[index].partDesc}",
                            "${GlobalParam.dataListHReserve[index].locationNo}",
                            index,
                            true);
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appMainImp() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey,
        activeBackgroundColor: Colors.blue,
        activeForegroundColor: Colors.white,
        buttonSize: const Size(60, 60),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        // onOpen: () => print('OPENING DIAL'), // action when menu opens
        // onClose: () => print('DIAL CLOSED'), //action when menu closes

        elevation: 8.0,
        shape: const CircleBorder(),

        children: [
          SpeedDialChild(
            child: const Icon(Icons.playlist_add),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            // label: 'First Menu Child',
            // labelStyle:  TextStyle(fontSize: 18.0),

            onTap: () => addBarcodeIDDialog(context),
            // onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.save),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            // label: 'Third Menu Child',
            // labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => {
              Tdialog.infoDialog(
                context,
                'Confirm Reported Qty?',
                'Are you sure to confirm reported Qty to Material Requisition line?',
                acceptSave(),
                cancelButton(),
              )
            },
            // onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 25,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${GlobalParam.dataListHBarcode.length} record found',
                  style: const TextStyle(
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer()
              ],
            ),
          ),
          SizedBox(
            height: (heightScreen - 47 - 25) * .8,
            width: widthScreen * .98,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: GlobalParam.dataListHBarcode.length,
                    itemBuilder: (context, index) {
                      return PathCardNewData(
                          '${GlobalParam.dataListHBarcode[index].barcodeId}',
                          '${GlobalParam.dataListHBarcode[index].lotNo}',
                          '${GlobalParam.dataListHBarcode[index].wdrNo}',
                          '${GlobalParam.dataListHBarcode[index].partNo}',
                          '${GlobalParam.dataListHBarcode[index].partDesc}',
                          numFormat.format(
                              GlobalParam.dataListHBarcode[index].reportedQty),
                          index,
                          Container(),
                          boxNewData,
                          editDataQty,
                          actionDelete,
                          cancelButton);
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget okButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        print("CCCCCCCCCCC");
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

  Widget acceptSave() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
        if (GlobalParam.dataListHBarcode.isNotEmpty) {
          reportMaterialRequisition();
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            "Report Materia lRequisition is entity.",
            okButton(),
          );
        }
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
        //go to function.....
        Navigator.pop(context, 'OK');
      },
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  addBarcodeIDDialog(context) {
    final TextEditingController searchOptionNo = TextEditingController();
    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: HexColor("#5b9bd5"),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        content: Container(
          //height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            top: 5.0,
            bottom: 10.0,
          ),
          child: Container(
            height: 70.0,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text(
                    'Barcode ID',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                    color: HexColor("#d9e1f2"),
                  ),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    controller: searchOptionNo,
                    autofocus: true,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        var text = value;
                        var textList = text.split("|");

                        _newData = textList[0];
                        searchOptionNo.text = textList[0];
                        searchOptionNo.selection = TextSelection.fromPosition(
                            TextPosition(offset: searchOptionNo.text.length));
                      });
                    },
                    onFieldSubmitted: (value) {
                      Navigator.pop(context, 'Save');
                      setState(() {
                        reAdd = true;
                      });
                      if (_newData != '') {
                        var text = _newData;
                        var textList = text.split("|");
                        var check = false;
                        for (var i = 0;
                            i < GlobalParam.dataListHBarcode.length;
                            i++) {
                          if (GlobalParam.dataListHBarcode[i].barcodeId ==
                              int.parse(textList[0])) {
                            check = true;
                          }
                        }
                        if (check == false) {
                          getDataByBarcodeId(int.parse(textList[0]));
                        } else {
                          Tdialog.errorDialog(
                            context,
                            'Error',
                            'Barcode ID is repeat.',
                            okButton(),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            height: 2.0,
            padding: const EdgeInsets.all(0),
            child: const Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 0.5,
              color: Colors.black,
            ),
          ),
          Container(
            height: 50.0,
            //color: Colors.amber,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                    searchOptionNo.clear();
                    setState(() {
                      reAdd = false;
                    });
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Save');
                    setState(() {
                      reAdd = true;
                    });
                    if (_newData != '') {
                      var text = _newData;
                      var textList = text.split("|");
                      var check = false;
                      for (var i = 0;
                          i < GlobalParam.dataListHBarcode.length;
                          i++) {
                        if (GlobalParam.dataListHBarcode[i].barcodeId ==
                            int.parse(textList[0])) {
                          check = true;
                        }
                      }
                      if (check == false) {
                        getDataByBarcodeId(int.parse(textList[0]));
                      } else {
                        Tdialog.errorDialog(
                          context,
                          'Error',
                          'Barcode ID is repeat.',
                          okButton(),
                        );
                      }
                    }
                  },
                  child: const Text('SAVE'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getDetail(String materialReqNo) async {
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

      var result = await proxy.hGetDetail(ReportMaterialRequisitionReq(
          materialReqNo: materialReqNo,
          barcodeId: 0,
          noOfLine: 0,
          reservedQty: 0,
          reportedQty: 0));
      if (result.isNotEmpty) {
        GlobalParam.dataListHReserve = [];
        GlobalParam.dataListHRemain = [];
        for (int i = 0; i < result.length; i++) {
          if (result[i].reservedQty! > result[i].reportedQty!) {
            GlobalParam.dataListHRemain.add(result[i]);
          }
          if (result[i].reservedQty! > 0) {
            GlobalParam.dataListHReserve.add(result[i]);
          }
        }
      } else {
        GlobalParam.dataListH = [];
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
    setState(() {});
  }

  reportMaterialRequisition() async {
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
      List<ReportMaterialRequisitionReq> reqList = [];
      for (int i = 0; i < GlobalParam.dataListHBarcode.length; i++) {
        var data = ReportMaterialRequisitionReq(
          barcodeId: GlobalParam.dataListHBarcode[i].barcodeId,
          materialReqNo: widget.data.materialReqNo,
          lineNo: widget.data.lineNo,
          relNo: widget.data.relNo,
          internalCustomerNo: widget.data.internalCustomerNo,
          internalCustomerName: widget.data.internalCustomerName,
          internalDestinationNo: widget.data.internalDestinationNo,
          internalDestinationName: widget.data.internalDestinationName,
          dueDate: GlobalParam.dataListHBarcode[i].dueDate,
          noOfLine: GlobalParam.dataListHBarcode[i].noOfLine,
          partNo: GlobalParam.dataListHBarcode[i].partNo,
          partDesc: GlobalParam.dataListHBarcode[i].partDesc,
          locationNo: GlobalParam.dataListHBarcode[i].locationNo,
          locationDesc: GlobalParam.dataListHBarcode[i].locationDesc,
          lotNo: GlobalParam.dataListHBarcode[i].lotNo,
          wdrNo: GlobalParam.dataListHBarcode[i].wdrNo,
          reservedQty: GlobalParam.dataListHBarcode[i].reservedQty,
          reportedQty: GlobalParam.dataListHBarcode[i].reportedQty,
        );
        reqList.add(data);
      }
      var result = await proxy.reportMaterialRequisition(reqList);
      if (result.errorMessage == null) {
        GlobalParam.dataListHBarcode = [];
        reportMaterialList = reportMaterialData.values.toList();
        for (int i = 0; i < reportMaterialList.length; i++) {
          if (reportMaterialList[i].materialReqNo ==
              widget.data.materialReqNo) {
            if (reportMaterialList[i].internalCustomerNo ==
                widget.data.internalCustomerNo) {
              reportMaterialData.delete(reportMaterialList[i].key);
            }
          }
        }
        getDetail('${widget.data.materialReqNo}');
        // Tdialog.successDialog(
        //   context,
        //   'Information',
        //   'Material Requisition line has been reported.',
        //   okButton(),
        // );

        ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
            context,
            'Material Requisition line has been reported.',
            heightScreen));
        Navigator.pop(context, 'OK');
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
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
    setState(() {});
  }

  getDataByBarcodeId(int barcodeId) async {
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

      var result = await proxy.hGetDataByBarcodeId(ReportMaterialRequisitionReq(
          materialReqNo: widget.data.materialReqNo,
          barcodeId: barcodeId,
          noOfLine: 0,
          reservedQty: 0,
          reportedQty: 0));
      // var result = await proxy.hGetDataByBarcodeId(ReportMaterialRequisitionReq(
      //     materialReqNo: "1617",
      //     barcodeId: barcodeId,
      //     noOfLine: 0,
      //     reservedQty: 0,
      //     reportedQty: 0));
      if (result.errorMessage == null) {
        GlobalParam.dataListHBarcode.add(result);
        reportMaterialList = reportMaterialData.values.toList();
        List<String> barcodeCheck = [];

        for (int i = 0; i < reportMaterialList.length; i++) {
          barcodeCheck.add('${reportMaterialList[i].id}');
        }
        var data = ReportMaterialRequisitionBarcode(
          id: generateId(barcodeCheck),
          barcodeId: result.barcodeId,
          materialReqNo: widget.data.materialReqNo,
          lineNo: widget.data.lineNo,
          relNo: widget.data.relNo,
          internalCustomerNo: widget.data.internalCustomerNo,
          internalCustomerName: widget.data.internalCustomerName,
          internalDestinationNo: widget.data.internalDestinationNo,
          internalDestinationName: widget.data.internalDestinationName,
          dueDate: widget.data.dueDate,
          noOfLine: widget.data.noOfLine,
          partNo: result.partNo,
          partDesc: result.partDesc,
          locationNo: widget.data.locationNo,
          locationDesc: widget.data.locationDesc,
          lotNo: result.lotNo,
          wdrNo: result.wdrNo,
          reservedQty: result.reportedQty,
          reportedQty: result.reportedQty,
        );
        reportMaterialData.put(data.id, data);
        setRemain(result, result.reportedQty!);

        if (reAdd == true) {
          addBarcodeIDDialog(context);
        }
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
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
    setState(() {});
  }

  String generateId(List<String> list) {
    List<String> checkId = [];
    for (int i = 0; i < 1000; i++) {
      String id = "";
      id = "$i";
      if (list.contains(id) == false) {
        checkId.add(id);
      }
    }
    return checkId[0];
  }
}
