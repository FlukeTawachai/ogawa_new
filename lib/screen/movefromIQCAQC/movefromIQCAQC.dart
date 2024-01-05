import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/moveFromIQC_AQCReq.dart';
import 'package:ogawa_nec/api/response/moveFromIQC_AQCResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/screen/movefromIQCAQC/movefromIQCAQCSort.dart';

class MovefromIQCAQC extends StatefulWidget {
  final bool reset;
  const MovefromIQCAQC({Key? key, required this.reset}) : super(key: key);

  @override
  State<MovefromIQCAQC> createState() => _MovefromIQCAQCState();
}

class _MovefromIQCAQCState extends State<MovefromIQCAQC> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  final FocusNode _nodesearchOption = FocusNode();
  final TextEditingController searchOptionNo = TextEditingController();
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  String searchBy = "PON";
  String search = "";
  final formatNum = NumberFormat("#,###.##", "en_US");
  String toLocation = '';
  var searchInput = "Please input Purchase Order No";

  int charLength = 0;
  _setDataCheckbox(
      String purchaseOrderNo, String lineNo, String relNo, String partNo) {
    setState(() {
      for (int i = 0; i < GlobalParam.dataListI.length; i++) {
        if (GlobalParam.dataListI[i].purchaseOrderNo == purchaseOrderNo) {
          if (GlobalParam.dataListI[i].lineNo == lineNo) {
            if (GlobalParam.dataListI[i].relNo == relNo) {
              if (GlobalParam.dataListI[i].partNo == partNo) {
                GlobalParam.dataListI[i].check != false ? false : true;
              }
            }
          }
        }
      }
    });
  }

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      search = value;
      if (value == '') {
        GlobalParam.dataListI = [];
      }
    });
  }

  searchAction() {
    print("searchAction : " + searchOptionNo.text);
  }

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    if (widget.reset == true) {
      GlobalParam.dataListI = [];
    }
    if (userSearchDefault.isNotEmpty) {
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_I') {
          if (userSearchDefault[i].searchBy == 'PON') {
            setState(() {
              searchInput = "Please Input Purchase Order No";
              searchBy = 'PON';
            });
          } else if (userSearchDefault[i].searchBy == 'PN') {
            setState(() {
              searchInput = "Please Input Part No";
              searchBy = 'PN';
            });
          } else if (userSearchDefault[i].searchBy == 'VN') {
            setState(() {
              searchInput = "Please Input Vender No";
              searchBy = 'VN';
            });
          } else if (userSearchDefault[i].searchBy == 'LN') {
            setState(() {
              searchInput = "Please Input Lot No";
              searchBy = 'LN';
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Container(child: searchBar()),
        backgroundColor: HexColor('2056AE'),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          )
        ],
      ),
      drawer: const MenuSide(),
      endDrawer: const MovefromIQCAQCSort(),
      body: Column(
        children: [
          Container(
            // height: heightScreen * 0.03,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${GlobalParam.dataListI.length} record found',
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
            height: (heightScreen - 36) * .84,
            width: widthScreen * .98,
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: GlobalParam.dataListI.length,
                      itemBuilder: (context, index) {
                        return dataCard(GlobalParam.dataListI[index], index);
                      })
                ],
              ),
            ),
          )
        ],
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
            child: const Icon(Icons.unarchive_rounded),
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey,
            // label: 'First Menu Child',
            // labelStyle:  TextStyle(fontSize: 18.0),

            onTap: () {
              addBarcodeIDDialog(context);
            },
            // onLongPress: () => print('FIRST CHILD LONG PRESS'),
          ),
        ],
      ),
      bottomNavigationBar: Container(
          height: 36,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          child: const BottomBarFooter()),
    );
  }

  Widget searchBar() {
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
        controller: searchOptionNo,
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
                searchAction();
                searchOptionNo.clear();
              });
            },
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: searchOptionNo.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        searchOptionNo.clear();
                        GlobalParam.dataListI = [];
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: _onChanged,
        onFieldSubmitted: (value) {
          if (value != '') {
            if (searchBy == 'PON') {
              getDataByPurchaseOrderNo(search);
            } else if (searchBy == 'PN') {
              getDataByPartNo(search);
            } else if (searchBy == 'VN') {
              getDataByVendorNo(search);
            } else if (searchBy == 'LN') {
              getDataByLotNo(search);
            }
          } else {
            setState(() {
              GlobalParam.dataListI = [];
            });
          }
        },
      ),
    );
  }

  moveIqcAqc(String toLocation) async {
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
      List<MoveFromIQC_AQCReq> reqList = [];
      for (int i = 0; i < GlobalParam.dataListI.length; i++) {
        if (GlobalParam.dataListI[i].check == true) {
          var data = MoveFromIQC_AQCReq(
              purchaseOrderNo: GlobalParam.dataListI[i].purchaseOrderNo,
              lineNo: GlobalParam.dataListI[i].lineNo,
              relNo: GlobalParam.dataListI[i].relNo,
              toLocation: toLocation,
              invQtyToMove: 0);
          reqList.add(data);
        }
      }
      var result = await proxy.moveIqcAqc(reqList);
      if (result.errorMessage != null) {
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
      } else {
        // Tdialog.successDialog(
        //   context,
        //   'Information',
        //   'All parts/materials have been moved to the destination location.',
        //   okButton(),
        // );

        ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
            context,
            'All parts/materials have been moved to the destination location.',
            heightScreen));
        Navigator.pop(context, 'OK');
        
        if (searchBy == 'PON') {
          getDataByPurchaseOrderNo(search);
        } else if (searchBy == 'PN') {
          getDataByPartNo(search);
        } else if (searchBy == 'VN') {
          getDataByVendorNo(search);
        } else if (searchBy == 'LN') {
          getDataByLotNo(search);
        }
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

  checkToLocationExist(String toLocation) async {
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

      var result = await proxy.iCheckToLocationExist(
          MoveFromIQC_AQCReq(toLocation: toLocation, invQtyToMove: 0));
      if (result.errorMessage != null) {
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
      } else {
        moveIqcAqc(toLocation);
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

  getDataByPurchaseOrderNo(String purchaseOrderNo) async {
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

      var result = await proxy.iGetDataByPurchaseOrderNo(MoveFromIQC_AQCReq(
          purchaseOrderNo: purchaseOrderNo, invQtyToMove: 0));
      if (result.isNotEmpty) {
        GlobalParam.dataListI = [];
        GlobalParam.dataListI.addAll(result);
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

      var result = await proxy.iGetDataByPartNo(
          MoveFromIQC_AQCReq(partNo: partNo, invQtyToMove: 0));
      if (result.isNotEmpty) {
        GlobalParam.dataListI = [];
        GlobalParam.dataListI.addAll(result);
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

  getDataByVendorNo(String vendorNo) async {
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

      var result = await proxy.iGetDataByVendorNo(
          MoveFromIQC_AQCReq(vendorNo: vendorNo, invQtyToMove: 0));
      if (result.isNotEmpty) {
        GlobalParam.dataListI = [];
        GlobalParam.dataListI.addAll(result);
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

  getDataByLotNo(String lotNo) async {
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

      var result = await proxy
          .iGetDataByLotNo(MoveFromIQC_AQCReq(lotNo: lotNo, invQtyToMove: 0));
      if (result.isNotEmpty) {
        GlobalParam.dataListI = [];
        GlobalParam.dataListI.addAll(result);
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
                    'To Location',
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
                    keyboardType: TextInputType.text,
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
                        toLocation = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      Navigator.pop(context, 'Save');

                      if (toLocation != '') {
                        Tdialog.infoDialog(
                          context,
                          'Confirm Moved Qty?',
                          'Are you sure to confirm moved Qty to $toLocation',
                          actionSave(checkToLocationExist(toLocation)),
                          cancelButton(),
                        );
                      } else {
                        Tdialog.errorDialog(
                          context,
                          'Error',
                          'To Location is entity.',
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
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Save');
                    if (toLocation != '') {
                      Tdialog.infoDialog(
                        context,
                        'Confirm Moved Qty?',
                        'Are you sure to confirm moved Qty to $toLocation',
                        actionSave(toLocation),
                        cancelButton(),
                      );
                    } else {
                      Tdialog.errorDialog(
                        context,
                        'Error',
                        'To Location is entity.',
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

  Widget dataCard(MoveFromIQC_AQCResp data, int i) {
    var widthScreen = MediaQuery.of(context).size.width;
    return Card(
      color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
      child: TextButton(
        onPressed: (() {}),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: 120,
                  // width: widthScreen * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      rowCord1('${data.purchaseOrderNo}', '${data.lineNo}',
                          '${data.relNo}', '${data.lotNo}', widthScreen),
                      rowCord2(
                          '${data.partNo}', '${data.partDesc}', widthScreen),
                      rowCord3(formatNum.format(data.invQtyToMove),
                          '${data.invUom}', widthScreen, i),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget rowCord1(cNo, sepNo, lotNo, wRDNo, widthScreen) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PO. No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  cNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Line',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  sepNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  lotNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    // fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lot No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  wRDNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.green,
                    fontSize: 16,
                    // fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rowCord2(partNo, description, widthScreen) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Part No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  partNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                AutoSizeText(
                  description,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                  maxFontSize: 16.0,
                  minFontSize: 4.0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget rowCord3(locationNo, locDesc, widthScreen, int index) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: widthScreen * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Inv Qty to Move',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  locationNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color.fromARGB(255, 102, 32, 128),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inv Uom',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  locDesc,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: widthScreen * 0.36,
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      alignment: Alignment.bottomCenter,
                      child: Checkbox(
                        value: GlobalParam.dataListI[index].check,
                        onChanged: (bool? value) {
                          // widget.setDataCheckbox(widget.cNo,widget.sepNo,widget.lotNo,widget.partNo);
                          setState(() {
                            GlobalParam.dataListI[index].check =
                                !GlobalParam.dataListI[index].check!;
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Confirm to Move',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget actionSave(String toLocation) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'OK');
        checkToLocationExist(toLocation);
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
}
