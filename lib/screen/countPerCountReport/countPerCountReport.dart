import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/countPerCountReportReq.dart';
import 'package:ogawa_nec/api/response/countPerCountReportResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/countPerCountReport/countPerCountReportSort.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/countPerCountReport/importCountPerCountReport.dart';
import 'package:ogawa_nec/screen/countPerCountReport/partCard.dart';

var searchInput = "Please input Count Report No";

class CountPerCountReport extends StatefulWidget {
  final bool reset;
  const CountPerCountReport({Key? key, required this.reset}) : super(key: key);

  @override
  State<CountPerCountReport> createState() => _CountPerCountReportState();
}

class _CountPerCountReportState extends State<CountPerCountReport> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  final FocusNode _nodesearchOption = FocusNode();
  final TextEditingController searchOptionNo = TextEditingController();
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  bool searchByCRN = true;
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  String search = '';

  int charLength = 0;

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
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    if (userSearchDefault.isNotEmpty) {
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_F') {
          if (userSearchDefault[i].searchBy == 'CRN') {
            setState(() {
              searchInput = "Please input Count Report No";
              searchByCRN = true;
            });
          } else {
            setState(() {
              searchInput = "Please input Part No";
              searchByCRN = false;
            });
          }
        }
      }
    }
    if (widget.reset == true) {
      ApiProxyParameter.dataListF = [];
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
      endDrawer: const CountPerCountReportSort(),
      body: Column(
        children: [
          Container(
            // height: heightScreen * 0.03,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${ApiProxyParameter.dataListF.length} record found',
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
                      itemCount: ApiProxyParameter.dataListF.length,
                      itemBuilder: (context, index) {
                        return PathCard(
                          double.parse(
                              '${ApiProxyParameter.dataListF[index].countReportNo}'),
                          double.parse(
                              '${ApiProxyParameter.dataListF[index].countReportSeq}'),
                          '${ApiProxyParameter.dataListF[index].lotNo}',
                          '${ApiProxyParameter.dataListF[index].wdrNo}',
                          '${ApiProxyParameter.dataListF[index].partNo}',
                          '${ApiProxyParameter.dataListF[index].partDesc}',
                          '${ApiProxyParameter.dataListF[index].locationNo}',
                          '${ApiProxyParameter.dataListF[index].locationDesc}',
                          index,
                          // Container() // name title next page
                          ImportcountPerCountReport(
                            titlename:
                                '${ApiProxyParameter.dataListF[index].countReportNo}-${ApiProxyParameter.dataListF[index].countReportSeq}|${ApiProxyParameter.dataListF[index].partNo}|${ApiProxyParameter.dataListF[index].locationNo}',
                            data: ApiProxyParameter.dataListF[index],
                            reset: true,
                          ),
                        );
                      })
                ],
              ),
            ),
          )
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
      child: TextField(
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
              if (searchByCRN == true) {
                getDataByCountReportNo(search);
              } else {
                getDataByPartNo(search);
              }
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
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: _onChanged,
        onSubmitted: (value) {
          if (searchByCRN == true) {
            getDataByCountReportNo(search);
          } else {
            getDataByPartNo(search);
          }
        },
      ),
    );
  }

  getDataByCountReportNo(String countReportNo) async {
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

      var result = await proxy.getDataByCountReportNo(CountPerCountReportReq(
          countReportNo: countReportNo, barcodeId: 0, countQty: 0));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.dataListF = [];
          ApiProxyParameter.dataListF.addAll(result);
        });
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

      var result = await proxy.getDataByPartNo(
          CountPerCountReportReq(partNo: partNo, barcodeId: 0, countQty: 0));
      if (result.isNotEmpty) {
        ApiProxyParameter.dataListF = [];
        ApiProxyParameter.dataListF.addAll(result);
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
