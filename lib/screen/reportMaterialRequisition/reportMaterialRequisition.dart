// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/reportMaterialRequisitionReq.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/reportMaterialRequisition/importReportMaterialRequisition.dart';
import 'package:ogawa_nec/screen/reportMaterialRequisition/reportMaterialRequisitionSort.dart';

import 'partCard.dart';

class ReportMaterialRequisition extends StatefulWidget {
  final bool reset;
  const ReportMaterialRequisition({Key? key, required this.reset})
      : super(key: key);

  @override
  State<ReportMaterialRequisition> createState() =>
      _ReportMaterialRequisitionState();
}

class _ReportMaterialRequisitionState extends State<ReportMaterialRequisition> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  int charLength = 0;
  final FocusNode _nodesearchOption = FocusNode();
  final TextEditingController searchOptionNo = TextEditingController();
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  String search = '';
  var numFormat = NumberFormat("#,###.##", "en_US");
  final dateF = DateFormat('dd/MM/yyyy');
  String searchBy = 'MN';
  String searchInput = "Please Input Material Req No";

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      search = value;
    });
  }

  searchAction() {
    print("searchAction : " + searchOptionNo.text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.reset == true) {
      GlobalParam.dataListH = [];
    }
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    if (userSearchDefault.isNotEmpty) {
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_H') {
          if (userSearchDefault[i].searchBy == 'MN') {
            setState(() {
              searchInput = "Please Input Material Req No";
              searchBy = 'MN';
            });
          } else if (userSearchDefault[i].searchBy == 'CN') {
            setState(() {
              searchInput = "Please Input Internal Customer No";
              searchBy = 'CN';
            });
          } else if (userSearchDefault[i].searchBy == 'PN') {
            setState(() {
              searchInput = "Please Input Part No";
              searchBy = 'PN';
            });
          } else if (userSearchDefault[i].searchBy == 'DN') {
            setState(() {
              searchInput = "Please Input Internal Destination No";
              searchBy = 'DN';
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
      endDrawer: const ReportMaterialRequisitionSort(),
      body: Column(
        children: [
          Container(
            // height: heightScreen * 0.03,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${GlobalParam.dataListH.length} record found',
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
                      itemCount: GlobalParam.dataListH.length,
                      itemBuilder: (context, index) {
                        var date = GlobalParam.dataListH[index].dueDate ?? '';
                        return PathCard(
                          '${GlobalParam.dataListH[index].materialReqNo}',
                          date == ''
                              ? ""
                              : dateF.format(DateTime.parse('$date')),
                          numFormat
                              .format(GlobalParam.dataListH[index].noOfLine),
                          '${GlobalParam.dataListH[index].internalCustomerNo ?? ''}',
                          '${GlobalParam.dataListH[index].internalCustomerName ?? ''}',
                          '${GlobalParam.dataListH[index].internalDestinationNo ?? ""}',
                          '${GlobalParam.dataListH[index].internalDestinationName ?? ""}',
                          index,
                          // Container()
                          ImportReportMaterialRequisition(
                              data: GlobalParam.dataListH[index]),
                        );
                      })
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          // height: 132,
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
            fontSize: 10,
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
                        GlobalParam.dataListH = [];
                      });
                      FocusScope.of(context).requestFocus(_nodesearchOption);
                    },
                  )
                : null,
          ),
        ),
        onChanged: _onChanged,
        onFieldSubmitted: (value) {
          if (searchBy == 'MN') {
            getDataByMaterialReqNo(search);
          } else if (searchBy == 'CN') {
            getDataByInternalCustomerNo(search);
          } else if (searchBy == 'PN') {
            getDataByPartNo(search);
          } else if (searchBy == 'DN') {
            getDataByInternalDestinationNo(search);
          }
        },
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

  getDataByMaterialReqNo(String materialReqNo) async {
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

      var result = await proxy.hGetDataByMaterialReqNo(
          ReportMaterialRequisitionReq(
              materialReqNo: materialReqNo,
              barcodeId: 0,
              noOfLine: 0,
              reservedQty: 0,
              reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListH = [];
            GlobalParam.dataListH.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListH = [];
          GlobalParam.dataListH.addAll(result);
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

      var result = await proxy.hGetDataByPartNo(ReportMaterialRequisitionReq(
          partNo: partNo,
          barcodeId: 0,
          noOfLine: 0,
          reservedQty: 0,
          reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListH = [];
            GlobalParam.dataListH.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListH = [];
          GlobalParam.dataListH.addAll(result);
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

  getDataByInternalCustomerNo(String customerNo) async {
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

      var result = await proxy.hGetDataByInternalCustomerNo(
          ReportMaterialRequisitionReq(
              internalCustomerNo: customerNo,
              barcodeId: 0,
              noOfLine: 0,
              reservedQty: 0,
              reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListH = [];
            GlobalParam.dataListH.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListH = [];
          GlobalParam.dataListH.addAll(result);
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

  getDataByInternalDestinationNo(String destinationNo) async {
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

      var result = await proxy.hGetDataByInternalDestinationNo(
          ReportMaterialRequisitionReq(
              internalDestinationNo: destinationNo,
              barcodeId: 0,
              noOfLine: 0,
              reservedQty: 0,
              reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            GlobalParam.dataListH = [];
            GlobalParam.dataListH.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          GlobalParam.dataListH = [];
          GlobalParam.dataListH.addAll(result);
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
}
