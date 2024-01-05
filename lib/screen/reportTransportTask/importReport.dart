import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/response/reportTransportTaskResp.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';

import 'boxInsertData.dart';
import 'partCard.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/api/request/reportTransportTaskReq.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

// import 'package:ogawa_nec/countPerCountReport.dart/countPerCountReportD2.dart';

var searchInput = "Please input Count Report No";

class ImportReportTransportTask extends StatefulWidget {
  final String titlename;
  final String partNo_;
  final String partDESC_;
  final String utm_;
  final String lotNo_;
  final String wdrNo_;
  final String qty_;
  final String transportTaskId_;
  final String transportTaskLineNo_;
  const ImportReportTransportTask({
    Key? key,
    required this.titlename,
    required this.partNo_,
    required this.partDESC_,
    required this.utm_,
    required this.lotNo_,
    required this.wdrNo_,
    required this.qty_,
    required this.transportTaskId_,
    required this.transportTaskLineNo_,
  }) : super(key: key);

  @override
  State<ImportReportTransportTask> createState() =>
      _ImportReportTransportTaskState();
}

class _ImportReportTransportTaskState extends State<ImportReportTransportTask> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  final FocusNode nodeBarcodeID = FocusNode();
  final FocusNode nodenewQuantity = FocusNode();
  final TextEditingController barcodeID = TextEditingController();
  final TextEditingController newQuantity = TextEditingController();
  var search = TextEditingController();
  int counter = 0;
  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  List<reportTransportTaskResp> nowDataRort = [];
  List<reportTransportTaskResp> fnowDataRort = [];

  List<ReportTransportTaskDB> boxnowDataRort = [];
  late Box<ReportTransportTaskDB> zboxnowDataRort;
  double totalRes = 0;
  double totalRep = 0;
  double totalRem = 0;
  bool success = false;
  String appliedDate = "";
  var numFormat = NumberFormat("#,###.######", "en_US");
  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    // makeData_();

    zboxnowDataRort = Hive.box('ReportTransportTaskDB');
    boxnowDataRort = zboxnowDataRort.values.toList();
    // makeData_();
    if (boxnowDataRort.isNotEmpty) {
      formatDataDBtoCast();
    }
    resetvaluereportedQty();
    print(widget.titlename + '-' + widget.lotNo_);
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

  Widget actionSave(Function func_) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'OK');
        await func_();
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

  resetvaluereportedQty() {
    totalRep = 0;
    for (var ix = 0; ix < nowDataRort.length; ix++) {
      totalRep += nowDataRort[ix].reportedQty!;
    }
    totalRem = double.parse(widget.qty_) - totalRep;
  }

  formatDataDBtoCast() async {
    for (int a = 0; a < boxnowDataRort.length; a++) {
      if ((boxnowDataRort[a].id) == (widget.titlename + '-' + widget.lotNo_)) {
        // if (true) {
        nowDataRort.add(reportTransportTaskResp.fromJson({
          "Id": boxnowDataRort[a].id,
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "TransportTaskId": boxnowDataRort[a].transportTaskId,
          "TransportTaskLineNo": boxnowDataRort[a].transportTaskLineNo,
          "ShopOrderNo": boxnowDataRort[a].shopOrderNo,
          "ExpListNo": boxnowDataRort[a].expListNo,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "Qty": boxnowDataRort[a].qty,
          "ReportedQty": boxnowDataRort[a].reportedQty,
          "RemainingQty": boxnowDataRort[a].remainingQty,
          "Uom": boxnowDataRort[a].uom,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
        }));
        // nowDataRort.add(_);
      } else {
        fnowDataRort.add(reportTransportTaskResp.fromJson({
          "Id": boxnowDataRort[a].id,
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "TransportTaskId": boxnowDataRort[a].transportTaskId,
          "TransportTaskLineNo": boxnowDataRort[a].transportTaskLineNo,
          "ShopOrderNo": boxnowDataRort[a].shopOrderNo,
          "ExpListNo": boxnowDataRort[a].expListNo,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "Qty": boxnowDataRort[a].qty,
          "ReportedQty": boxnowDataRort[a].reportedQty,
          "RemainingQty": boxnowDataRort[a].remainingQty,
          "Uom": boxnowDataRort[a].uom,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
        }));
      }
    }
  }

  getDataByBarcodeIdRTT(int v) async {
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

      var result = await proxy.getDataByBarcodeIdRTT(reportTransportTaskReq(
        barcodeId: v,
        partNo: widget.partNo_,
        lotNo: widget.lotNo_,
        wdrNo: widget.wdrNo_,
        // partNo: 'PA056',
        // lotNo: "330583-*-*-1",
        // wdrNo: "*",
        qty: 0,
        reportedQty: 0,
        remainingQty: 0,
      ));
      if (result.errorMessage == null) {
        setState(() {
          // charLength = value.length;
          result.id = widget.titlename + '-' + widget.lotNo_;
          nowDataRort.add(result);
        });
        zboxnowDataRort.put(
            getRandomString(30),
            ReportTransportTaskDB(
              id: widget.titlename + '-' + widget.lotNo_,
              barcodeId: result.barcodeId,
              transportTaskId: result.transportTaskId,
              transportTaskLineNo: result.transportTaskLineNo,
              shopOrderNo: result.shopOrderNo,
              expListNo: result.expListNo,
              partNo: result.partNo,
              partDesc: result.partDesc,
              lotNo: result.lotNo,
              wdrNo: result.wdrNo,
              qty: result.qty,
              reportedQty: result.reportedQty,
              remainingQty: result.remainingQty,
              uom: result.uom,
              errorMessage: result.errorMessage,
            ));
        addBarcodeIDDialog(context, addNewData);
        FocusScope.of(context).requestFocus(nodeBarcodeID);
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        FocusScope.of(context).requestFocus(nodeBarcodeID);
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

  funcAddReportTransportTaskDB(add_, List app) async {
    for (var a = 0; a < app.length; a++) {
      add_.put(
          getRandomString(30),
          ReportTransportTaskDB(
            id: app[a].id,
            barcodeId: app[a].barcodeId,
            transportTaskId: app[a].transportTaskId,
            transportTaskLineNo: app[a].transportTaskLineNo,
            shopOrderNo: app[a].shopOrderNo,
            expListNo: app[a].expListNo,
            partNo: app[a].partNo,
            partDesc: app[a].partDesc,
            lotNo: app[a].lotNo,
            wdrNo: app[a].wdrNo,
            qty: app[a].qty,
            reportedQty: app[a].reportedQty,
            remainingQty: app[a].remainingQty,
            uom: app[a].uom,
            errorMessage: app[a].errorMessage,
          ));
    }
  }

  reportTransportTask() async {
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

      var result = await proxy.reportTransportTask(reportTransportTaskReq(
        barcodeId: 0,
        transportTaskId: widget.transportTaskId_,
        transportTaskLineNo: widget.transportTaskLineNo_,
        qty: 0,
        reportedQty: 0,
        remainingQty: totalRem,
      ));
      if (result.errorMessage == null) {
        // Tdialog.successDialog(
        //   context,
        //   'Information',
        //   'Transport task line has executed.',
        //   TextButton(
        //     onPressed: () async {
        //       setState(() {
        //         nowDataRort.clear();
        //         success = true;
        //         totalRep = 0.0;
        //         totalRem = 0;
        //       });
        //       zboxnowDataRort.clear();
        //       await funcAddReportTransportTaskDB(zboxnowDataRort, fnowDataRort);
        //       await resetvaluereportedQty();
        //       Navigator.pop(context, 'OK');
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
            context, 'Transport task line has executed.', heightScreen));
        setState(() {
          nowDataRort.clear();
          success = true;
          totalRep = 0.0;
          totalRem = 0;
        });
        zboxnowDataRort.clear();
        await funcAddReportTransportTaskDB(zboxnowDataRort, fnowDataRort);
        await resetvaluereportedQty();
        Navigator.pop(context, 'OK');
      } else {
        // wrongDialog();
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        FocusScope.of(context).requestFocus(nodeBarcodeID);
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

  addNewData(_newData) async {
    print("### barcode ####");
    print(_newData);
    bool check = false;
    for (int i = 0; i < nowDataRort.length; i++) {
      if (nowDataRort[i].barcodeId == int.parse(_newData)) {
        check = true;
      }
    }
    if (check == false && _newData != '') {
      await getDataByBarcodeIdRTT(int.parse(_newData));
      resetvaluereportedQty();
    } else {
      Tdialog.errorDialog(
        context,
        'Error',
        'Barcode ID in repeat.',
        okButton(),
      );
    }

    print("-------------");
  }

  applyDate(_newData) async {
    setState(() {
      appliedDate = "$_newData";
    });
  }

  actionDelete(delbarcodeID, int i) async {
    print("// action delete //");
    print(delbarcodeID);

    List<reportTransportTaskResp> listNew = [];
    for (int ix = 0; ix < nowDataRort.length; ix++) {
      if ((nowDataRort[ix].barcodeId.toString()) != delbarcodeID.toString() &&
          ix != i) {
        listNew.add(nowDataRort[ix]);
      }
    }
    await zboxnowDataRort.clear();
    await funcAddReportTransportTaskDB(zboxnowDataRort, listNew);
    await funcAddReportTransportTaskDB(zboxnowDataRort, fnowDataRort);

    setState(() {
      nowDataRort = [];
      nowDataRort.addAll(listNew);
      resetvaluereportedQty();
    });

    print("// ------------ //");

    Navigator.pop(context, 'OK');
    // return okButton();
  }

  editDataQty(String loc, _barcodeId, int i) async {
    print("### editDataQty ####");
    print(_barcodeId);
    print(loc);
    String num = loc.replaceAll(',', '');
    if (double.parse(num) <= 0) {
      Tdialog.errorDialog(
        context,
        'Error',
        'Quantity need more than zero.',
        okButton(),
      );
    } else {
      List<reportTransportTaskResp> arrayNew = nowDataRort;
      for (int ix = 0; ix < arrayNew.length; ix++) {
        if ((arrayNew[ix].barcodeId.toString()) == _barcodeId.toString() &&
            ix == i) {
          arrayNew[ix].reportedQty = double.parse(num);
          // print('OK');
        }
      }
      await zboxnowDataRort.clear();
      await funcAddReportTransportTaskDB(zboxnowDataRort, arrayNew);
      await funcAddReportTransportTaskDB(zboxnowDataRort, fnowDataRort);

      setState(() {
        nowDataRort = [];
        nowDataRort.addAll(arrayNew);
        resetvaluereportedQty();
      });
    }

    print("-------------");
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.titlename,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        backgroundColor: HexColor('2056AE'),
      ),
      drawer: const MenuSide(),
      body: Column(
        children: [
          Container(
            // height: heightScreen * 0.03,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${nowDataRort.length} record found',
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
            height: (heightScreen - 130) * .8,
            width: widthScreen * .98,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nowDataRort.length,
                    itemBuilder: (context, index) {
                      return PathCardNewData(
                        nowDataRort[index].barcodeId.toString(),
                        nowDataRort[index].lotNo.toString(),
                        nowDataRort[index].wdrNo.toString(),
                        nowDataRort[index].partNo.toString(),
                        nowDataRort[index].partDesc.toString(),
                        numFormat.format(nowDataRort[index].reportedQty),
                        index,
                        Container(),
                        boxNewData,
                        editDataQty,
                        actionDelete,
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 130,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.58,
                    child: Text(widget.partNo_,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.2,
                    child: const Text(
                      'Reserved:',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: widthScreen * 0.15,
                    child: AutoSizeText(
                      success == true
                          ? "0"
                          : NumberFormat("#,###.########", "en_US")
                              .format(double.parse(widget.qty_)),
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      maxFontSize: 16.0,
                      minFontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.58,
                    child: Text(widget.partDESC_,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.2,
                    child: const Text('Reported:',
                        style: TextStyle(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                            fontSize: 14),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.15,
                    child: AutoSizeText(
                      success == true
                          ? "0"
                          : NumberFormat("#,###.########", "en_US")
                              .format(totalRep),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        color: Colors.red,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      maxFontSize: 14.0,
                      minFontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.58,
                    child: Text(widget.utm_,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.2,
                    child: const Text('Remaining:',
                        style: TextStyle(color: Colors.green, fontSize: 14),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.15,
                    child: AutoSizeText(
                      success == true
                          ? "0"
                          : NumberFormat("#,###.########", "en_US")
                              .format(totalRem),
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      maxFontSize: 14.0,
                      minFontSize: 10.0,
                    ),
                  ),
                ],
              ),
            ),
            const BottomBarFooter()
          ],
        ),
      ),
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
          success == true
              ? SpeedDialChild(
                  child: const Icon(Icons.playlist_add),
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey,
                )
              : SpeedDialChild(
                  child: const Icon(Icons.playlist_add),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                  // label: 'First Menu Child',
                  // labelStyle:  TextStyle(fontSize: 18.0),

                  onTap: () => addBarcodeIDDialog(context, addNewData),
                  // onLongPress: () => print('FIRST CHILD LONG PRESS'),
                ),
          success == true
              ? SpeedDialChild(
                  child: const Icon(Icons.save),
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.grey,
                )
              : SpeedDialChild(
                  child: const Icon(Icons.save),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                  // label: 'Third Menu Child',
                  // labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () => {
                    Tdialog.infoDialog(
                      context,
                      'Confirm Reported Qty?',
                      'Are you sure to confirm reported Qty to Transport task line?',
                      actionSave(reportTransportTask),
                      cancelButton(),
                    )
                  },
                  // onLongPress: () => print('THIRD CHILD LONG PRESS'),
                ),
        ],
      ),
    );
  }
}
