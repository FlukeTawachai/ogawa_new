// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/countPerCountReportReq.dart';
import 'package:ogawa_nec/api/response/countPerCountReportResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/screen/countPerCountReport/boxInsertData.dart';
import 'package:ogawa_nec/screen/countPerCountReport/partCard.dart';

class ImportcountPerCountReport extends StatefulWidget {
  const ImportcountPerCountReport({
    Key? key,
    required this.titlename,
    required this.data,
    required this.reset,
  }) : super(key: key);
  final String titlename;
  final CountPerCountReportResp data;
  final bool reset;
  @override
  State<ImportcountPerCountReport> createState() =>
      _ImportcountPerCountReportState();
}

class _ImportcountPerCountReportState extends State<ImportcountPerCountReport> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  // final FocusNode nodeBarcodeID = FocusNode();
  // final FocusNode nodenewQuantity = FocusNode();
  // final TextEditingController barcodeID = TextEditingController();
  final TextEditingController newQuantity = TextEditingController();
  int counter = 0;
  final TextEditingController searchOptionNo = TextEditingController();
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  List<CountReportBarcode> barcodeList = [];
  late Box<CountReportBarcode> countReportBarcode;
  int barcodeId = 0;
  bool isCancel = false;
  bool canAdd = true;
  bool canSetZero = true;

  int charLength = 0;
  var searchInput = "Please input Count Report No";
  var numFormat = NumberFormat("#,###.##", "en_US");
  double totalQty = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  searchAction() {
    print("searchAction : " + searchOptionNo.text);
  }

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    countReportBarcode = Hive.box('CountReportBarcode');
    barcodeList = countReportBarcode.values.toList();
    if (widget.reset == true) {
      print('+++++++++++++${barcodeList.length}');
      ApiProxyParameter.dataListFBarcodeId = [];
      if (barcodeList.isNotEmpty) {
        for (int i = 0; i < barcodeList.length; i++) {
          if (barcodeList[i].countReportNo == widget.data.countReportNo) {
            if (barcodeList[i].partNo == widget.data.partNo) {
              if (barcodeList[i].lotNo == widget.data.lotNo) {
                if (barcodeList[i].wdrNo == widget.data.wdrNo) {
                  // countReportBarcode.delete(barcodeList[i].key);
                  var data = CountPerCountReportResp(
                    countReportNo: barcodeList[i].countReportNo,
                    countReportSeq: barcodeList[i].countReportSeq,
                    barcodeId: barcodeList[i].barcodeId,
                    partNo: barcodeList[i].partNo,
                    partDesc: barcodeList[i].partDesc,
                    locationNo: barcodeList[i].locationNo,
                    locationDesc: barcodeList[i].locationDesc,
                    lotNo: barcodeList[i].lotNo,
                    wdrNo: barcodeList[i].wdrNo,
                    countQty: barcodeList[i].countQty,
                    errorMessage: widget.data.errorMessage,
                  );
                  ApiProxyParameter.dataListFBarcodeId.add(data);
                  totalQty = 0;
                  for (int j = 0;
                      j < ApiProxyParameter.dataListFBarcodeId.length;
                      j++) {
                    totalQty +=
                        ApiProxyParameter.dataListFBarcodeId[j].countQty!;
                  }
                }
              }
            }
          }

          // if (barcodeList[i].partNo == "PA056") {
          //   if (barcodeList[i].lotNo == "330583-*-*-1") {
          //     if (barcodeList[i].wdrNo == "*") {
          //       var data = CountPerCountReportResp(
          //         countReportNo: barcodeList[i].countReportNo,
          //         countReportSeq: barcodeList[i].countReportSeq,
          //         barcodeId: barcodeList[i].barcodeId,
          //         partNo: barcodeList[i].partNo,
          //         partDesc: barcodeList[i].partDesc,
          //         locationNo: barcodeList[i].locationNo,
          //         locationDesc: barcodeList[i].locationDesc,
          //         lotNo: barcodeList[i].lotNo,
          //         wdrNo: barcodeList[i].wdrNo,
          //         countQty: barcodeList[i].countQty,
          //         errorMessage: widget.data.errorMessage,
          //       );
          //       ApiProxyParameter.dataListFBarcodeId.add(data);
          //       totalQty = 0;
          //       for (int j = 0;
          //           j < ApiProxyParameter.dataListFBarcodeId.length;
          //           j++) {
          //         totalQty += ApiProxyParameter.dataListFBarcodeId[j].countQty!;
          //       }
          //     }
          //   }
          // }
        }
      }
    } else {
      totalQty = 0;
      for (int j = 0; j < ApiProxyParameter.dataListFBarcodeId.length; j++) {
        totalQty += ApiProxyParameter.dataListFBarcodeId[j].countQty!;
      }
    }
    // for (int i = 0; i < barcodeList.length; i++) {
    //   countReportBarcode.delete(barcodeList[i].key);
    // }
    if (ApiProxyParameter.dataListFBarcodeId.isNotEmpty) {
      if (ApiProxyParameter.dataListFBarcodeId.length == 1) {
        if (ApiProxyParameter.dataListFBarcodeId[0].barcodeId == 999999999) {
          canSetZero = true;
          canAdd = false;
        }
      } else {
        canSetZero = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    addNewData(_newData) {
      print("### barcode ####");
      print(_newData);
      print("-------------");
    }

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.titlename,
          textAlign: TextAlign.left,
          style: const TextStyle(fontSize: 18),
        ),
        backgroundColor: HexColor('2056AE'),
        // actions: [
        //   Builder(
        //     builder: (context) {
        //       return IconButton(
        //         icon: const Icon(Icons.more_vert_rounded),
        //         onPressed: () {
        //           Scaffold.of(context).openEndDrawer();
        //         },
        //       );
        //     },
        //   )
        // ],
      ),
      // drawer: const MenuSide(),
      // endDrawer: BarcodeIdSort(
      //   titlename: widget.titlename,
      //   data: widget.data,
      // ),
      body: Column(
        children: [
          // Container(
          //   // height: heightScreen * 0.03,
          //   padding: const EdgeInsets.only(left: 16, top: 10),
          //   child: Row(
          //     children: [
          //       Text(
          //         '${ApiProxyParameter.dataListFBarcodeId.length} record found',
          //         style: const TextStyle(
          //           color: Colors.grey,
          //           overflow: TextOverflow.ellipsis,
          //         ),
          //       ),
          //       const Spacer()
          //     ],
          //   ),
          // ),
          SizedBox(
            height: (heightScreen - 72) * .82,
            width: widthScreen * .98,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ApiProxyParameter.dataListFBarcodeId.length,
                    itemBuilder: (context, index) {
                      return PathCardNewData(
                          '${ApiProxyParameter.dataListFBarcodeId[index].barcodeId}',
                          '${ApiProxyParameter.dataListFBarcodeId[index].lotNo}',
                          '${ApiProxyParameter.dataListFBarcodeId[index].wdrNo}',
                          '${ApiProxyParameter.dataListFBarcodeId[index].partNo}',
                          '${ApiProxyParameter.dataListFBarcodeId[index].partDesc}',
                          numFormat.format(ApiProxyParameter
                              .dataListFBarcodeId[index].countQty),
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
      bottomNavigationBar: Container(
        height: 72,
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
              height: 11,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.25,
                    child: const Text('No. of Barcode',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.2,
                    child: Text(
                      '${ApiProxyParameter.dataListFBarcodeId.length}',
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: widthScreen * 0.25,
                    child: const Text(
                      'Counted Qty:',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: widthScreen * 0.2,
                    child: Text(
                      numFormat.format(totalQty),
                      // ignore: prefer_const_constructors
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.end,
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
          SpeedDialChild(
            child: const Icon(Icons.playlist_add),
            backgroundColor:
                canAdd == true ? Colors.white : Colors.grey.shade400,
            foregroundColor: Colors.grey,
            // label: 'First Menu Child',
            // labelStyle:  TextStyle(fontSize: 18.0),

            onTap: () {
              if (canAdd == true) {
                addBarcodeIDDialog(context, addNewData);
              }
            },
            // onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.warning),

            backgroundColor:
                canSetZero == true ? Colors.white : Colors.grey.shade400,
            foregroundColor: Colors.grey,
            // label: 'Second Menu Child',
            // labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              if (canSetZero == true) {
                Tdialog.infoDialog(
                    context,
                    'Confirm lost material?',
                    'Are you sure to confirm to report 0 (Zero) for selected Part?',
                    confirmZeroButton(),
                    cancelButton());
              }
            },
            // onLongPress: () => print('SECOND CHILD LONG PRESS'),
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
                'Confirm Count Report?',
                'Are you sure to confirm Counted Quantity for this Part no?',
                actionSave(),
                cancelButton(),
              )
            },
            // onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
        ],
      ),
    );
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

      var result = await proxy.getDataByBarcodeId(CountPerCountReportReq(
          partNo: widget.data.partNo,
          barcodeId: barcodeId,
          lotNo: widget.data.lotNo,
          wdrNo: widget.data.wdrNo,
          countQty: 0));
      // var result = await proxy.getDataByBarcodeId(CountPerCountReportReq(
      //     partNo: 'PA056',
      //     barcodeId: barcodeId,
      //     lotNo: "330583-*-*-1",
      //     wdrNo: "*",
      //     countQty: 0));
      if (result.errorMessage == null) {
        var checkLength = 0;
        setState(() {
          // ApiProxyParameter.dataListFBarcodeId = [];
          result.countReportNo = widget.data.countReportNo;
          ApiProxyParameter.dataListFBarcodeId.add(result);
          totalQty = 0;
          for (int j = 0;
              j < ApiProxyParameter.dataListFBarcodeId.length;
              j++) {
            totalQty += ApiProxyParameter.dataListFBarcodeId[j].countQty!;
          }
          canSetZero = false;
          checkLength = countReportBarcode.values.toList().length;
        });
        List<String> barcodeCheck = [];
        barcodeList = countReportBarcode.values.toList();
        for (int i = 0; i < barcodeList.length; i++) {
          barcodeCheck.add('${barcodeList[i].id}');
        }
        var data = CountReportBarcode(
          id: generateId(barcodeCheck),
          countReportNo: widget.data.countReportNo,
          countReportSeq: result.countReportSeq,
          barcodeId: result.barcodeId,
          partNo: result.partNo,
          partDesc: result.partDesc,
          locationNo: result.locationNo,
          locationDesc: result.locationDesc,
          lotNo: result.lotNo,
          wdrNo: result.wdrNo,
          countQty: result.countQty,
          errorMessage: widget.data.errorMessage,
        );
        countReportBarcode.put(data.id, data);
        if (isCancel == false) {
          addBarcodeIDDialog(context, () {});
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
  }

  reportCountReport() async {
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

      List<CountPerCountReportReq> reqList = [];
      for (var i = 0; i < ApiProxyParameter.dataListFBarcodeId.length; i++) {
        var req = CountPerCountReportReq(
          countReportNo: widget.data.countReportNo,
          countReportSeq: widget.data.countReportSeq,
          barcodeId: ApiProxyParameter.dataListFBarcodeId[i].barcodeId,
          countQty: ApiProxyParameter.dataListFBarcodeId[i].countQty,
        );
        reqList.add(req);
      }
      var result = await proxy.reportCountReport(reqList);
      if (result.errorMessage == null) {
        setState(() {
          ApiProxyParameter.dataListFBarcodeId = [];
          totalQty = 0;
        });
        barcodeList = countReportBarcode.values.toList();
        if (barcodeList.isNotEmpty) {
          for (int i = 0; i < barcodeList.length; i++) {
            if (barcodeList[i].countReportNo == widget.data.countReportNo) {
              if (barcodeList[i].partNo == widget.data.partNo) {
                if (barcodeList[i].lotNo == widget.data.lotNo) {
                  if (barcodeList[i].wdrNo == widget.data.wdrNo) {
                    countReportBarcode.delete(barcodeList[i].key);
                  }
                }
              }

              // if (barcodeList[i].partNo == "PA056") {
              //   if (barcodeList[i].lotNo == "330583-*-*-1") {
              //     if (barcodeList[i].wdrNo == "*") {
              //       countReportBarcode.delete(barcodeList[i].key);
              //     }
              //   }
              // }
            }
          }
        }
        // Tdialog.successDialog(
        //   context,
        //   'Information',
        //   'Counted Quantity has been reported.\nPlease contact to approver to get approval',
        //   okButton(),
        // );
        ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
            context,
            'Counted Quantity has been reported.\nPlease contact to approver to get approval',
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
  }

  addBarcodeIDDialog(context, func) {
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
                      if (value != '') {
                        var text = value;
                        var textList = text.split("|");

                        barcodeId = int.parse(textList[0]);
                        setState(() {
                          searchOptionNo.text = textList[0];
                          searchOptionNo.selection = TextSelection.fromPosition(
                              TextPosition(offset: searchOptionNo.text.length));
                        });
                      }
                    },
                    onFieldSubmitted: (value) {
                      Navigator.pop(context, 'Save');
                      setState(() {
                        isCancel = false;
                      });
                      // func(searchOptionNo.text);
                      var check = false;
                      for (int i = 0;
                          i < ApiProxyParameter.dataListFBarcodeId.length;
                          i++) {
                        if (ApiProxyParameter.dataListFBarcodeId[i].barcodeId ==
                            barcodeId) {
                          check = true;
                        }
                      }
                      if (check == false) {
                        getDataByBarcodeId(barcodeId);
                      } else {
                        Tdialog.errorDialog(
                          context,
                          'Error',
                          'Barcode ID is repeat',
                          okButton(),
                        );
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
                      isCancel = true;
                    });
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Save');
                    setState(() {
                      isCancel = false;
                    });
                    // func(searchOptionNo.text);
                    var check = false;
                    for (int i = 0;
                        i < ApiProxyParameter.dataListFBarcodeId.length;
                        i++) {
                      if (ApiProxyParameter.dataListFBarcodeId[i].barcodeId ==
                          barcodeId) {
                        check = true;
                      }
                    }
                    if (check == false) {
                      getDataByBarcodeId(barcodeId);
                    } else {
                      Tdialog.errorDialog(
                        context,
                        'Error',
                        'Barcode ID is repeat',
                        okButton(),
                      );
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

  Widget actionDelete(String delbarcodeID) {
    return TextButton(
      onPressed: () {
        for (int i = 0; i < ApiProxyParameter.dataListFBarcodeId.length; i++) {
          // ignore: unrelated_type_equality_checks
          if (ApiProxyParameter.dataListFBarcodeId[i].barcodeId ==
              int.parse(delbarcodeID)) {
            setState(() {
              ApiProxyParameter.dataListFBarcodeId.removeAt(i);
              totalQty = 0;
              for (int j = 0;
                  j < ApiProxyParameter.dataListFBarcodeId.length;
                  j++) {
                totalQty += ApiProxyParameter.dataListFBarcodeId[j].countQty!;
              }
              if (ApiProxyParameter.dataListFBarcodeId.isEmpty) {
                canSetZero = true;
                canAdd = true;
              }
            });
          }
        }
        barcodeList = countReportBarcode.values.toList();
        if (barcodeList.isNotEmpty) {
          for (int i = 0; i < barcodeList.length; i++) {
            if (barcodeList[i].countReportNo == widget.data.countReportNo) {
              if (barcodeList[i].partNo == widget.data.partNo) {
                if (barcodeList[i].lotNo == widget.data.lotNo) {
                  if (barcodeList[i].wdrNo == widget.data.wdrNo) {
                    if (barcodeList[i].barcodeId == int.parse(delbarcodeID)) {
                      countReportBarcode.delete(barcodeList[i].key);
                    }
                  }
                }
              }
            }

            // if (barcodeList[i].partNo == "PA056") {
            //   if (barcodeList[i].lotNo == "330583-*-*-1") {
            //     if (barcodeList[i].wdrNo == "*") {
            //       if (barcodeList[i].barcodeId == int.parse(delbarcodeID)) {
            //         countReportBarcode.delete(barcodeList[i].key);
            //       }
            //     }
            //   }
            // }
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

  Widget actionSave() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'OK');
        reportCountReport();
        // if (totalQty > 0) {
        //   reportCountReport();
        // } else {
        //   Tdialog.errorDialog(
        //     context,
        //     'Error',
        //     'Counted Qty is zero.',
        //     okButton(),
        //   );
        // }
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

  Widget confirmZeroButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        // var data = CountReportBarcode(
        //   id: '${barcodeList.length + 1}',
        //   countReportNo: widget.data.countReportNo,
        //   countReportSeq: widget.data.countReportSeq,
        //   barcodeId: 999999999,
        //   partNo: widget.data.partNo,
        //   partDesc: widget.data.partDesc,
        //   locationNo: widget.data.locationNo,
        //   locationDesc: widget.data.locationDesc,
        //   lotNo: widget.data.locationNo,
        //   wdrNo: widget.data.wdrNo,
        //   countQty: 0,
        //   errorMessage: widget.data.errorMessage,
        // );
        barcodeList = countReportBarcode.values.toList();
        List<String> barcodeCheck = [];
        for (int i = 0; i < barcodeList.length; i++) {
          barcodeCheck.add('${barcodeList[i].id}');
        }

        var data = CountReportBarcode(
          id: generateId(barcodeCheck),
          countReportNo: widget.data.countReportNo,
          countReportSeq: widget.data.countReportSeq,
          barcodeId: 999999999,
          partNo: widget.data.partNo,
          partDesc: widget.data.partDesc,
          locationNo: widget.data.locationNo,
          locationDesc: widget.data.locationDesc,
          lotNo: widget.data.lotNo,
          wdrNo: widget.data.wdrNo,
          countQty: 0,
          errorMessage: widget.data.errorMessage,
        );
        countReportBarcode.put(data.id, data);

        setState(() {
          ApiProxyParameter.dataListFBarcodeId = [];
          var data = CountPerCountReportResp(
            countReportNo: widget.data.countReportNo,
            countReportSeq: widget.data.countReportSeq,
            barcodeId: 999999999,
            partNo: widget.data.partNo,
            partDesc: widget.data.partDesc,
            locationNo: widget.data.locationNo,
            locationDesc: widget.data.locationDesc,
            lotNo: widget.data.locationNo,
            wdrNo: widget.data.wdrNo,
            countQty: 0.0,
            errorMessage: widget.data.errorMessage,
          );
          ApiProxyParameter.dataListFBarcodeId.add(data);
          canAdd = false;
        });
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

  editDataQty(double loc, _barcodeId) {
    if (loc > 0) {
      for (int i = 0; i < ApiProxyParameter.dataListFBarcodeId.length; i++) {
        // ignore: unrelated_type_equality_checks
        if (ApiProxyParameter.dataListFBarcodeId[i].barcodeId ==
            int.parse(_barcodeId)) {
          setState(() {
            ApiProxyParameter.dataListFBarcodeId[i].countQty = loc;
            totalQty = 0;
            for (int j = 0;
                j < ApiProxyParameter.dataListFBarcodeId.length;
                j++) {
              totalQty += ApiProxyParameter.dataListFBarcodeId[j].countQty!;
            }
          });
          var dataList = countReportBarcode.values.toList();
          for (int i = 0; i < dataList.length; i++) {
            if (dataList[i].countReportNo == widget.data.countReportNo) {
              if (dataList[i].partNo == widget.data.partNo) {
                if (dataList[i].lotNo == widget.data.lotNo) {
                  if (dataList[i].wdrNo == widget.data.wdrNo) {
                    if (dataList[i].barcodeId == int.parse(_barcodeId)) {
                      countReportBarcode.delete(dataList[i].key);
                      dataList[i].countQty = loc;
                      countReportBarcode.put(dataList[i].id, dataList[i]);
                    }
                  }
                }
              }
            }
          }
        }
      }
    } else {
      Tdialog.errorDialog(
        context,
        'Error',
        'Qty Per Barcode is zero.',
        okButton(),
      );
    }
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
