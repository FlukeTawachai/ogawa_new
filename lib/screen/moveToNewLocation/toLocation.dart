import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/moveToNewLocation/listToBarcodeID.dart';
import 'package:ogawa_nec/api/response/moveToNewLocationResp.dart';

import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/api/request/moveToNewLocationRep.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ToLocation extends StatefulWidget {
  const ToLocation({Key? key}) : super(key: key);

  @override
  State<ToLocation> createState() => _ToLocationState();
}

class _ToLocationState extends State<ToLocation> {
  final TextEditingController _location = TextEditingController();
  final TextEditingController _barcode = TextEditingController();
  // String _txtLocation = '';
  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];

  List<MoveToNewLocationRep> boxnowDataRort = [];
  late Box<MoveToNewLocationRep> zboxnowDataRort;

  // List<moveToNewLocationResp> ApiProxyParameter.dataListJCustBarcodeFrom = [];
  List<moveToNewLocationResp> fnowDataRort = [];

  List<moveToNewLocationResp> nowDataRortF = [];
  List<LocationJFromAndTo> locationJFromAndTo = [];
  late Box<LocationJFromAndTo> zlocationJFromAndTo;
  double heightScreen = 0;

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();

    zboxnowDataRort = Hive.box('MoveToNewLocationRep');
    boxnowDataRort = zboxnowDataRort.values.toList();

    zlocationJFromAndTo = Hive.box('LocationJFromAndTo');
    locationJFromAndTo = zlocationJFromAndTo.values.toList();

    // makeData_();
    ApiProxyParameter.dataListJCustBarcodeTo.clear();
    ApiProxyParameter.dataListJCustBarcodeFrom.clear();
    if (boxnowDataRort.isNotEmpty) {
      ApiProxyParameter.countBarcodeToFrom = boxnowDataRort.length;
      formatDataDBtoCast();
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

  formatDataDBtoCast() async {
    for (int b = 0; b < locationJFromAndTo.length; b++) {
      if (locationJFromAndTo[b].userLogin == ApiProxyParameter.userLogin &&
          (locationJFromAndTo[b].classBox == 'T')) {
        ApiProxyParameter.jBarcodeTo = locationJFromAndTo[b].locationFrom ?? '';
        break;
      }
    }
    for (int a = 0; a < boxnowDataRort.length; a++) {
      if ((boxnowDataRort[a].userLogin == ApiProxyParameter.userLogin) ==
          (boxnowDataRort[a].classBox == 'T')) {
        // if (true) {
        ApiProxyParameter.dataListJCustBarcodeTo
            .add(moveToNewLocationResp.fromJson({
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "FromLocation": boxnowDataRort[a].fromLocation,
          "ToLocation": boxnowDataRort[a].toLocation,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "MovedQty": boxnowDataRort[a].movedQty,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
          "UserLogin": boxnowDataRort[a].userLogin,
          "ClassBox": boxnowDataRort[a].classBox
        }));
        // nowDataRort.add(_);
      } else if ((boxnowDataRort[a].userLogin == ApiProxyParameter.userLogin) ==
          (boxnowDataRort[a].classBox == 'F')) {
        ApiProxyParameter.dataListJCustBarcodeFrom
            .add(moveToNewLocationResp.fromJson({
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "FromLocation": boxnowDataRort[a].fromLocation,
          "ToLocation": boxnowDataRort[a].toLocation,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "MovedQty": boxnowDataRort[a].movedQty,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
          "UserLogin": boxnowDataRort[a].userLogin,
          "ClassBox": boxnowDataRort[a].classBox
        }));
      } else {
        fnowDataRort.add(moveToNewLocationResp.fromJson({
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "FromLocation": boxnowDataRort[a].fromLocation,
          "ToLocation": boxnowDataRort[a].toLocation,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "MovedQty": boxnowDataRort[a].movedQty,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
          "UserLogin": boxnowDataRort[a].userLogin,
          "ClassBox": boxnowDataRort[a].classBox
        }));
      }
    }
  }

  funcRemoveData(index) async {
    moveToNewLocationResp data =
        ApiProxyParameter.dataListJCustBarcodeTo[index];
    ApiProxyParameter.dataListJCustBarcodeTo.removeAt(index);

    boxnowDataRort = zboxnowDataRort.values.toList();
    for (int i = 0; i < boxnowDataRort.length; i++) {
      if (boxnowDataRort[i].classBox == "T") {
        if (boxnowDataRort[i].barcodeId == data.barcodeId) {
          if (boxnowDataRort[i].lotNo == data.lotNo) {
            if (boxnowDataRort[i].partNo == data.partNo) {
              if (boxnowDataRort[i].wdrNo == data.wdrNo) {
                zboxnowDataRort.delete(boxnowDataRort[i].key);
              }
            }
          }
        }
      }
    }

    setState(() {
      ApiProxyParameter.dataListJCustBarcodeTo;
    });
  }

  cDataSuccess() async {
    await zboxnowDataRort.clear();

    for (int index = 0;
        index < ApiProxyParameter.dataListJCustBarcodeTo.length;
        index++) {
      ApiProxyParameter.dataListJCustBarcodeFrom.removeWhere((element) =>
          element.barcodeId.toString() ==
          ApiProxyParameter.dataListJCustBarcodeTo[index].barcodeId.toString());
    }

    for (int index = 0;
        index < ApiProxyParameter.dataListJCustBarcodeFrom.length;
        index++) {
      await zboxnowDataRort.put(
          '${zboxnowDataRort.values.toList().length + index + 1}',
          MoveToNewLocationRep(
            barcodeId:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].barcodeId,
            partNo: ApiProxyParameter.dataListJCustBarcodeFrom[index].partNo,
            partDesc:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].partDesc,
            fromLocation:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].fromLocation,
            toLocation:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].toLocation,
            lotNo: ApiProxyParameter.dataListJCustBarcodeFrom[index].lotNo,
            wdrNo: ApiProxyParameter.dataListJCustBarcodeFrom[index].wdrNo,
            movedQty:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].movedQty,
            errorMessage:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].errorMessage,
            userLogin:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].userLogin,
            classBox:
                ApiProxyParameter.dataListJCustBarcodeFrom[index].classBox,
          ));
    }

    for (int index = 0; index < fnowDataRort.length; index++) {
      await zboxnowDataRort.put(
          '${zboxnowDataRort.values.toList().length + index + 1}',
          MoveToNewLocationRep(
            barcodeId: fnowDataRort[index].barcodeId,
            partNo: fnowDataRort[index].partNo,
            partDesc: fnowDataRort[index].partDesc,
            fromLocation: fnowDataRort[index].fromLocation,
            toLocation: fnowDataRort[index].toLocation,
            lotNo: fnowDataRort[index].lotNo,
            wdrNo: fnowDataRort[index].wdrNo,
            movedQty: fnowDataRort[index].movedQty,
            errorMessage: fnowDataRort[index].errorMessage,
            userLogin: fnowDataRort[index].userLogin,
            classBox: fnowDataRort[index].classBox,
          ));
    }

    setState(() {
      ApiProxyParameter.dataListJCustBarcodeTo.clear();
    });
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

  checkFromLocation() async {
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

      var result = await proxy.checkToLocationExist(moveToNewLocationRep(
          barcodeId: 0, toLocation: _location.text, movedQty: 0.0));
      if (result.errorMessage == null) {
        ApiProxyParameter.jBarcodeTo = _location.text;
        await zlocationJFromAndTo.put(
            '1',
            LocationJFromAndTo(
                userLogin: ApiProxyParameter.userLogin,
                classBox: 'T',
                locationFrom: ApiProxyParameter.jBarcodeTo,
                id: 0));
      } else {
        // wrongDialog();
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

  checkFromBarcodeID(String locationFrom) async {
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

      var result = await proxy.getDataByBarcodeIdMTNLR(moveToNewLocationRep(
        barcodeId: int.parse(_barcode.text),
        movedQty: 0.0,
      ));
      if (result.errorMessage == null) {
        EasyLoading.dismiss();
        result.fromLocation = locationFrom;
        result.toLocation = ApiProxyParameter.jBarcodeTo;
        result.userLogin = ApiProxyParameter.userLogin;
        result.classBox = 'T';
        List<String> barcodeCheck = [];
        boxnowDataRort = zboxnowDataRort.values.toList();
        for (int i = 0; i < boxnowDataRort.length; i++) {
          barcodeCheck.add('${boxnowDataRort[i].key}');
        }

        await zboxnowDataRort.put(
            generateId(barcodeCheck),
            MoveToNewLocationRep(
              barcodeId: result.barcodeId,
              partNo: result.partNo,
              partDesc: result.partDesc,
              fromLocation: result.fromLocation,
              toLocation: result.toLocation,
              lotNo: result.lotNo,
              wdrNo: result.wdrNo,
              movedQty: result.movedQty,
              errorMessage: result.errorMessage,
              userLogin: ApiProxyParameter.userLogin,
              classBox: 'T',
            ));
        ApiProxyParameter.countBarcodeToFrom++;

        setState(() {
          ApiProxyParameter.dataListJCustBarcodeTo.add(result);
        });
        await _addBarcodeIDDialog();
      } else {
        // wrongDialog();
        var text = '${result.errorMessage}';
        var textList = text.split("|");
        Tdialog.errorDialog(
          context,
          'Error',
          textList[0],
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
    _barcode.clear();
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(0),
          // ignore: prefer_const_constructors
          child: ListToBarcodeID(func_remove: funcRemoveData),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height / 9,
        child: Column(
          children: [
            Expanded(
              child: _bottomSheet(),
            ),
            const BottomBarFooter(),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          activeBackgroundColor: HexColor("#4e73be"),
          activeForegroundColor: Colors.white,
          buttonSize: const Size(60.0, 60.0),
          childrenButtonSize: const Size(65.0, 65.0),
          visible: true,
          closeManually: false,
          renderOverlay: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          backgroundColor: Colors.white,
          foregroundColor: HexColor("#515152"),
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(
                Icons.playlist_add,
                color: Colors.black54,
                size: 30.0,
              ),
              backgroundColor: Colors.white,
              onTap: () async {
                _addBarcodeIDDialog();
              },
              onLongPress: () async {
                _addBarcodeIDDialog();
              },
            ),
            ApiProxyParameter.jBarcodeTo.isEmpty
                ? SpeedDialChild(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(
                        Icons.unarchive_rounded,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    onTap: () async {
                      _addFromLocationDialog();
                    },
                    onLongPress: () async {
                      _addFromLocationDialog();
                    },
                  )
                : ApiProxyParameter.dataListJCustBarcodeTo.isEmpty
                    ? SpeedDialChild(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            LineAwesomeIcons.alternate_trash,
                            color: Colors.black54,
                            size: 30.0,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        onTap: () async {
                          setState(() {
                            ApiProxyParameter.jBarcodeTo = '';
                          });
                          zlocationJFromAndTo.delete('1');
                          _location.clear();
                        },
                        onLongPress: () async {
                          setState(() {
                            ApiProxyParameter.jBarcodeTo = '';
                          });

                          zlocationJFromAndTo.delete('1');
                          _location.clear();
                        },
                      )
                    : SpeedDialChild(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            LineAwesomeIcons.alternate_trash,
                            color: Colors.black54,
                            size: 30.0,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade300,
                        onTap: () async {
                          // setState(() {
                          //   ApiProxyParameter.jBarcodeTo = '';
                          // });
                          // zlocationJFromAndTo.delete('1');
                          // _location.clear();
                        },
                        onLongPress: () async {
                          // setState(() {
                          //   ApiProxyParameter.jBarcodeTo = '';
                          // });

                          // zlocationJFromAndTo.delete('1');
                          // _location.clear();
                        },
                      ),
            SpeedDialChild(
              child: const Icon(
                Icons.save,
                color: Colors.black54,
                size: 30.0,
              ),
              backgroundColor: Colors.white,
              onTap: () async {
                Tdialog.infoDialog(
                  context,
                  'Confirm moveed Qty?',
                  'Are you sure to confirm moved Qty to\nthis location?',
                  acceptButton(),
                  cancelButton(),
                );
              },
              onLongPress: () async {
                //_addBarcodeIDDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  clickComfirm() async {
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

      List<moveToNewLocationRep> reqList = [];
      List<String> pathList = [];
      for (int i = 0;
          i < ApiProxyParameter.dataListJCustBarcodeTo.length;
          i++) {
        pathList.add("${ApiProxyParameter.dataListJCustBarcodeTo[i].partNo}");
      }

      var distinctPath = pathList.toSet().toList();

      for (int j = 0; j < distinctPath.length; j++) {
        var str = "";
        for (int i = 0;
            i < ApiProxyParameter.dataListJCustBarcodeTo.length;
            i++) {
          if (ApiProxyParameter.dataListJCustBarcodeTo[i].partNo ==
              distinctPath[j]) {
            if (str == "") {
              str = "${ApiProxyParameter.dataListJCustBarcodeTo[i].barcodeId}";
            } else {
              str =
                  "$str,${ApiProxyParameter.dataListJCustBarcodeTo[i].barcodeId}";
            }
          }
        }

        for (int i = 0;
            i < ApiProxyParameter.dataListJCustBarcodeTo.length;
            i++) {
          if (ApiProxyParameter.dataListJCustBarcodeTo[i].partNo ==
              distinctPath[j]) {
            ApiProxyParameter.dataListJCustBarcodeTo[i].listBarcodeId = str;
          }
        }
      }

      for (int i = 0;
          i < ApiProxyParameter.dataListJCustBarcodeTo.length;
          i++) {
        var datalist = ApiProxyParameter
            .dataListJCustBarcodeTo[i].listBarcodeId!
            .split(",");
        var distinctBarcodeId = datalist.toSet().toList();
        var text = "";
        for (int j = 0; j < distinctBarcodeId.length; j++) {
          if (j == 0) {
            text = distinctBarcodeId[j];
          } else {
            text = "$text,${distinctBarcodeId[j]}";
          }
        }
        reqList.add(moveToNewLocationRep(
            barcodeId: 0,
            partNo: ApiProxyParameter.dataListJCustBarcodeTo[i].partNo,
            fromLocation:
                ApiProxyParameter.dataListJCustBarcodeTo[i].fromLocation,
            toLocation: ApiProxyParameter.dataListJCustBarcodeTo[i].toLocation,
            lotNo: ApiProxyParameter.dataListJCustBarcodeTo[i].lotNo,
            wdrNo: ApiProxyParameter.dataListJCustBarcodeTo[i].wdrNo,
            movedQty: ApiProxyParameter.dataListJCustBarcodeTo[i].movedQty,
            listBarcodeId: text));
      }
      var result = await proxy.moveNewLocation(reqList);
      if (result.errorMessage == null) {
        boxnowDataRort = zboxnowDataRort.values.toList();
        for (int i = 0; i < boxnowDataRort.length; i++) {
          for (int j = 0;
              j < ApiProxyParameter.dataListJCustBarcodeTo.length;
              j++) {
            var data = ApiProxyParameter.dataListJCustBarcodeTo[j];
            if (boxnowDataRort[i].barcodeId == data.barcodeId) {
              if (boxnowDataRort[i].lotNo == data.lotNo) {
                if (boxnowDataRort[i].partNo == data.partNo) {
                  if (boxnowDataRort[i].wdrNo == data.wdrNo) {
                    zboxnowDataRort.delete(boxnowDataRort[i].key);
                  }
                }
              }
            }
          }
        }

        // Tdialog.successDialog(
        //   context,
        //   'Information',
        //   'All parts/materials have been moved to the new location.',
        //   TextButton(
        //     onPressed: () {
        //       cDataSuccess();
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
            context,
            'Counted Quantity has been reported.\nPlease contact to approver to get approval',
            heightScreen));
        cDataSuccess();
        Navigator.pop(context, 'OK');
      } else {
        // wrongDialog();
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

  Widget acceptButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'ACCEPT');
        clickComfirm();
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

  checkDataForInsert() async {
    if (ApiProxyParameter.jBarcodeTo.isNotEmpty) {
      List checkBarcodeID = ApiProxyParameter.dataListJCustBarcodeTo
          .where((x) => x.barcodeId.toString() == _barcode.text)
          .toList();
      if (checkBarcodeID.isNotEmpty) {
        Tdialog.errorDialog(
          context,
          'Error',
          'Duplicate barcode id data',
          okButton(),
        );
      } else {
        List checkData_ = ApiProxyParameter.dataListJCustBarcodeFrom
            .where((x) => x.barcodeId.toString() == _barcode.text)
            .toList();
        if (checkData_.isNotEmpty) {
          await checkFromBarcodeID(checkData_[0].fromLocation);
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            'Is no BarcodeID information in From Location.',
            okButton(),
          );
        }
      }
    } else {
      Tdialog.errorDialog(
        context,
        'Error',
        'No data Location , Please enter Location',
        okButton(),
      );
    }
  }

  _delete() {
    var a = 'Delete Data....';
    print(a);
    return a;
  }

  Widget _bottomSheet() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.black38,
          )),
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                height: 40.0,
                // color: Colors.amber,
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        //width: 80.0,
                        padding: const EdgeInsets.all(0),
                        child: AutoSizeText(
                          'To: ${ApiProxyParameter.jBarcodeTo}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#0070c0"),
                          ),
                          maxLines: 1,
                          minFontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      width: 120.0,
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: AutoSizeText(
                        'No. of Barcode',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#a10515"),
                        ),
                        maxLines: 1,
                        minFontSize: 14.0,
                      ),
                    ),
                    Container(
                      width: 80.0,
                      padding: const EdgeInsets.all(0),
                      child: AutoSizeText(
                        ApiProxyParameter.dataListJCustBarcodeTo.length
                            .toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#a10515"),
                        ),
                        minFontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _addFromLocationDialog() {
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
            child: Row(
              children: [
                Expanded(
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
                        margin: const EdgeInsets.only(left: 10.0, top: 10.0),
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
                          controller: _location,
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
                          onFieldSubmitted: (value) async {
                            Navigator.pop(context, 'Save');
                            await checkFromLocation();
                            setState(() {
                              ApiProxyParameter.jBarcodeTo;
                            });
                          },
                        ),
                      ),
                    ],
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
                    _location.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Save');
                    await checkFromLocation();
                    setState(() {
                      ApiProxyParameter.jBarcodeTo;
                    });
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

  _addBarcodeIDDialog() {
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
            child: Row(
              children: [
                Expanded(
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
                        margin: const EdgeInsets.only(left: 10.0, top: 10.0),
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
                          controller: _barcode,
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

                              _barcode.text = textList[0];
                              _barcode.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _barcode.text.length));
                            });
                          },
                          onFieldSubmitted: (value) async {
                            Navigator.pop(context, 'Save');

                            checkDataForInsert();
                            _barcode.clear();
                          },
                        ),
                      ),
                    ],
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
                    _barcode.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Save');

                    checkDataForInsert();
                    _barcode.clear();
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
}
