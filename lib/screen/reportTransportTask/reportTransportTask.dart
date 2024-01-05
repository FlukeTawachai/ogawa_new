import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/request/reportTransportTaskReq.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
// import 'package:ogawa_nec/menu/actionSort.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/screen/reportTransportTask/boxInsertData.dart';
import 'package:ogawa_nec/screen/reportTransportTask/calendarDialog.dart';
import 'package:ogawa_nec/screen/reportTransportTask/utils.dart';
import 'package:table_calendar/table_calendar.dart';

// import 'importReport.dart';
import 'partCard.dart';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/reportTransportTask/importReport.dart';

// import 'package:ogawa_nec/ReportTransportTask.dart/ReportTransportTaskD2.dart';
enum SortSortBy { transportTaskIdAndLineNo, partNo, location, lotNo }

enum SortDirection { aToz, zToa }

enum SortSearchOption { transportTaskId, exptListNo, partNo, shopOrderNo }

var _character = SortSortBy.transportTaskIdAndLineNo;
var _character2 = SortDirection.aToz;
var _character3 = SortSearchOption.transportTaskId;

// var _characterdef = SortSortBy.transportTaskIdAndLineNo;
// var _characterdef2 = SortDirection.aToz;
// var _characterdef3 = SortSearchOption.transportTaskId;

var searchInput = "Please input Transport Task ID";

class ReportTransportTask extends StatefulWidget {
  final bool reset;
  const ReportTransportTask({Key? key, required this.reset}) : super(key: key);

  @override
  State<ReportTransportTask> createState() => _ReportTransportTaskState();
}

class _ReportTransportTaskState extends State<ReportTransportTask> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  int charLength = 0;
  final FocusNode _nodesearchOption = FocusNode();
  final TextEditingController searchOptionNo = TextEditingController();
  late Box<ApiSettings> database;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  int arrayUserSearchDefault = -1;
  List<ApiSettings> dataSetting = [];
  String appliedDate = "";
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

  Widget actionSave() {
    return TextButton(
      onPressed: () {
        // shopOrderReceived();
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

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      if (value == '') {
        ApiProxyParameter.dataListG = [];
      }
    });
  }

  getDataByTransportId() async {
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

      var result = await proxy.getDataByTransportId(reportTransportTaskReq(
          transportTaskId: searchOptionNo.text,
          barcodeId: 0,
          qty: 0,
          reportedQty: 0,
          remainingQty: 0));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.dataListG = [];
          ApiProxyParameter.dataListG.addAll(result);
        });
      } else {
        setState(() {
          ApiProxyParameter.dataListG = [];
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

  getDataByExpListNo() async {
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

      var result = await proxy.getDataByExpListNo(reportTransportTaskReq(
          expListNo: searchOptionNo.text,
          barcodeId: 0,
          qty: 0,
          reportedQty: 0,
          remainingQty: 0));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.dataListG = [];
          ApiProxyParameter.dataListG.addAll(result);
        });
      } else {
        setState(() {
          ApiProxyParameter.dataListG = [];
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

  getDataByPartNo() async {
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

      var result = await proxy.getDataByPartNo(reportTransportTaskReq(
          partNo: searchOptionNo.text,
          barcodeId: 0,
          qty: 0,
          reportedQty: 0,
          remainingQty: 0));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.dataListG = [];
          ApiProxyParameter.dataListG.addAll(result);
        });
      } else {
        setState(() {
          ApiProxyParameter.dataListG = [];
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

  getDataByShopOrderNo() async {
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

      var result = await proxy.getDataByShopOrderNo(reportTransportTaskReq(
          shopOrderNo: searchOptionNo.text,
          barcodeId: 0,
          qty: 0,
          reportedQty: 0,
          remainingQty: 0));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.dataListG = [];
          ApiProxyParameter.dataListG.addAll(result);
        });
      } else {
        setState(() {
          ApiProxyParameter.dataListG = [];
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

  @override
  void initState() {
    super.initState();
    // searchOptionNo.text = 'JL';
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();

    if (widget.reset == true) {
      ApiProxyParameter.dataListG = [];
    }

    if (userSearchDefault.isNotEmpty) {
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_G') {
          arrayUserSearchDefault = i;
          String userSD = (userSearchDefault[i].searchBy).toString();
          List parts = userSD.split('-');

          if (parts.isNotEmpty) parts.add('TT');
          if (parts.length >= 2) parts.add('AZ');
          if (parts.length >= 3) parts.add('TTAL');

          if (parts[0] == 'TT') {
            _character3 = SortSearchOption.transportTaskId;
            searchInput = "Please input Transport Task ID";
            // _characterdef3 = SortSearchOption.transportTaskId;
          } else if (parts[0] == 'EL') {
            print('EL');
            _character3 = SortSearchOption.exptListNo;
            searchInput = "Please input Expected List No";
            // _characterdef3 = SortSearchOption.exptListNo;
          } else if (parts[0] == 'PN') {
            print('PN');
            _character3 = SortSearchOption.partNo;
            searchInput = "Please input Part No";
            // _characterdef3 = SortSearchOption.partNo;
          } else if (parts[0] == 'SO') {
            print('SO');
            _character3 = SortSearchOption.shopOrderNo;
            searchInput = "Please input Shop Order No";
            // _characterdef3 = SortSearchOption.shopOrderNo;
          }

          if (parts[1] == 'AZ') {
            _character2 = SortDirection.aToz;
            // _characterdef2 = SortDirection.aToz;
          } else if (parts[1] == 'ZA') {
            _character2 = SortDirection.zToa;
            // _characterdef2 = SortDirection.zToa;
          }

          if (parts[2] == 'TTAL') {
            _character = SortSortBy.transportTaskIdAndLineNo;
            // _characterdef = SortSortBy.transportTaskIdAndLineNo;
          } else if (parts[2] == 'PN') {
            _character = SortSortBy.partNo;
            // _characterdef = SortSortBy.partNo;
          } else if (parts[2] == 'L') {
            _character = SortSortBy.location;
            // _characterdef = SortSortBy.location;
          } else if (parts[2] == 'LN') {
            _character = SortSortBy.lotNo;
            // _characterdef = SortSortBy.lotNo;
          }
        }
      }
    }
  }

  sortBy() {
    if (_character == SortSortBy.transportTaskIdAndLineNo) {
      if (_character2 == SortDirection.aToz) {
        ApiProxyParameter.dataListG.sort((a, b) =>
            (a.transportTaskId.toString() + a.transportTaskLineNo.toString())
                .compareTo(b.transportTaskId.toString() +
                    b.transportTaskLineNo.toString()));
      } else if (_character2 == SortDirection.zToa) {
        ApiProxyParameter.dataListG.sort((a, b) =>
            (b.transportTaskId.toString() + b.transportTaskLineNo.toString())
                .compareTo(a.transportTaskId.toString() +
                    a.transportTaskLineNo.toString()));
      }
    } else if (_character == SortSortBy.partNo) {
      if (_character2 == SortDirection.aToz) {
        ApiProxyParameter.dataListG
            .sort((a, b) => a.partNo.toString().compareTo(b.partNo.toString()));
      } else if (_character2 == SortDirection.zToa) {
        ApiProxyParameter.dataListG
            .sort((a, b) => b.partNo.toString().compareTo(a.partNo.toString()));
      }
    } else if (_character == SortSortBy.location) {
      if (_character2 == SortDirection.aToz) {
        ApiProxyParameter.dataListG.sort(
            (a, b) => a.partDesc.toString().compareTo(b.partDesc.toString()));
      } else if (_character2 == SortDirection.zToa) {
        ApiProxyParameter.dataListG.sort(
            (a, b) => b.partDesc.toString().compareTo(a.partDesc.toString()));
      }
    } else if (_character == SortSortBy.lotNo) {
      if (_character2 == SortDirection.aToz) {
        ApiProxyParameter.dataListG
            .sort((a, b) => a.lotNo.toString().compareTo(b.lotNo.toString()));
      } else if (_character2 == SortDirection.zToa) {
        ApiProxyParameter.dataListG
            .sort((a, b) => b.lotNo.toString().compareTo(a.lotNo.toString()));
      }
    }
    setState(() {
      ApiProxyParameter.dataListG;
    });
  }

  searchAction() async {
    print("searchAction : " + searchOptionNo.text);
    if (_character3 == SortSearchOption.transportTaskId) {
      await getDataByTransportId();
    } else if (_character3 == SortSearchOption.exptListNo) {
      await getDataByExpListNo();
    } else if (_character3 == SortSearchOption.partNo) {
      await getDataByPartNo();
    } else if (_character3 == SortSearchOption.shopOrderNo) {
      await getDataByShopOrderNo();
    }
    await sortBy();
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;

    setPage(ch1, ch2, ch3) {
      setState(() {
        _character = ch1;
        _character2 = ch2;
        _character3 = ch3;
        // action sort //
        print("// action sort //");
        print(_character);
        print(_character2);
        print(_character3);
        print("// ------------ //");
        // end sort //

        // TTAL = transportTaskIdAndLineNo
        // PN = partNo
        // L = location
        // LN = lotNo

        var azRoza = "AZ";
        var ssb = "TTAL";

        if (_character2 == SortDirection.aToz) {
          azRoza = "AZ";
        } else if (_character2 == SortDirection.zToa) {
          azRoza = "ZA";
        }

        if (_character == SortSortBy.transportTaskIdAndLineNo) {
          ssb = 'TTAL';
        } else if (_character == SortSortBy.partNo) {
          ssb = 'PN';
        } else if (_character == SortSortBy.location) {
          ssb = 'L';
        } else if (_character == SortSortBy.lotNo) {
          ssb = 'LN';
        }

        if (_character3 == SortSearchOption.transportTaskId) {
          searchInput = "Please input Transport Task ID";
          userSearchDefault[arrayUserSearchDefault].searchBy =
              'TT' + "-" + azRoza + '-' + ssb;
          searchDefaultList
              .delete(userSearchDefault[arrayUserSearchDefault].key);
          searchDefaultList.put(userSearchDefault[arrayUserSearchDefault].id,
              userSearchDefault[arrayUserSearchDefault]);
        } else if (_character3 == SortSearchOption.exptListNo) {
          searchInput = "Please input Expected List No";
          userSearchDefault[arrayUserSearchDefault].searchBy =
              'EL' + "-" + azRoza + '-' + ssb;
          searchDefaultList
              .delete(userSearchDefault[arrayUserSearchDefault].key);
          searchDefaultList.put(userSearchDefault[arrayUserSearchDefault].id,
              userSearchDefault[arrayUserSearchDefault]);
        } else if (_character3 == SortSearchOption.partNo) {
          searchInput = "Please input Part No";
          userSearchDefault[arrayUserSearchDefault].searchBy =
              'PN' + "-" + azRoza + '-' + ssb;
          searchDefaultList
              .delete(userSearchDefault[arrayUserSearchDefault].key);
          searchDefaultList.put(userSearchDefault[arrayUserSearchDefault].id,
              userSearchDefault[arrayUserSearchDefault]);
        } else if (_character3 == SortSearchOption.shopOrderNo) {
          searchInput = "Please input Shop Order No";
          userSearchDefault[arrayUserSearchDefault].searchBy =
              'SO' + "-" + azRoza + '-' + ssb;
          searchDefaultList
              .delete(userSearchDefault[arrayUserSearchDefault].key);
          searchDefaultList.put(userSearchDefault[arrayUserSearchDefault].id,
              userSearchDefault[arrayUserSearchDefault]);
        }
      });
      sortBy();
    }

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
      endDrawer: ActionSort(
        // part: part,
        func: setPage,
      ),
      body: Column(
        children: [
          Container(
            // height: heightScreen * 0.03,
            padding: const EdgeInsets.only(left: 16, top: 10),
            child: Row(
              children: [
                Text(
                  '${ApiProxyParameter.dataListG.length} record found',
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
                      itemCount: ApiProxyParameter.dataListG.length,
                      itemBuilder: (context, index) {
                        return PathCard(
                          ApiProxyParameter.dataListG[index].transportTaskId
                              .toString(),
                          double.parse(ApiProxyParameter
                              .dataListG[index].transportTaskLineNo
                              .toString()),
                          ApiProxyParameter.dataListG[index].lotNo.toString(),
                          '${ApiProxyParameter.dataListG[index].qty}',
                          ApiProxyParameter.dataListG[index].partNo.toString(),
                          ApiProxyParameter.dataListG[index].partDesc
                              .toString(),
                          ApiProxyParameter.dataListG[index].expListNo ?? "",
                          ApiProxyParameter.dataListG[index].shopOrderNo ?? "",
                          index,
                          // Container()
                          ImportReportTransportTask(
                            titlename:
                                "Lot No : ${ApiProxyParameter.dataListG[index].lotNo ?? ""} | Shop : ${ApiProxyParameter.dataListG[index].shopOrderNo ?? ""}",
                            partNo_: ApiProxyParameter.dataListG[index].partNo
                                .toString(),
                            partDESC_: ApiProxyParameter
                                .dataListG[index].partDesc
                                .toString(),
                            utm_: ApiProxyParameter.dataListG[index].uom
                                .toString(),
                            lotNo_: ApiProxyParameter.dataListG[index].lotNo
                                .toString(),
                            wdrNo_: ApiProxyParameter.dataListG[index].wdrNo
                                .toString(),
                            qty_: ApiProxyParameter.dataListG[index].qty!
                                .toString(),
                            transportTaskId_: ApiProxyParameter
                                .dataListG[index].transportTaskId!
                                .toString(),
                            transportTaskLineNo_: ApiProxyParameter
                                .dataListG[index].transportTaskLineNo!
                                .toString(),
                          ),
                        );
                      }),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (_) => TableBasicsExample()));
          appliedDateDialog(context, applyDate,DateTime.now(),false);
        },
        child: const Icon(Icons.access_alarm),
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

  applyDate(_newData) async {
    print("********************$_newData");
    setState(() {
      appliedDate = "$_newData";
    });
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
        autofocus: widget.reset ? true : false,
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
              searchAction();
              setState(() {
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
                        ApiProxyParameter.dataListG = [];
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: _onChanged,
        onFieldSubmitted: (v) async {
          await searchAction();
        },
      ),
    );
  }
}

class ActionSort extends StatefulWidget {
  const ActionSort({
    Key? key,
    // required this.part,
    required this.func,
  }) : super(key: key);
  // final List part;
  final Function func;
  @override
  State<ActionSort> createState() => _ActionSortState();
}

class _ActionSortState extends State<ActionSort> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            const Text(
              'Configuration',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const Divider(),
            const ConfigSortBy(),
            const Divider(),
            const ConfigSortDirection(),
            const Divider(),
            const ConfigSortSearch(),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 30.0),
                    height: 40.0,
                    child: ButtonTheme(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _character = SortSortBy.transportTaskIdAndLineNo;
                            _character2 = SortDirection.aToz;
                            _character3 = SortSearchOption.transportTaskId;
                          });
                          widget.func(_character, _character2, _character3);
                          Navigator.pop(context);
                          // Navigator.pushReplacement<void, void>(
                          //   context,
                          //   MaterialPageRoute<void>(
                          //     builder: (BuildContext context) =>
                          //         const ReportTransportTask(reset: false),
                          //   ),
                          // );
                        },
                        child: const Center(
                            child: Text(
                          "Clear",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: HexColor("#4e73be"),
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 30.0),
                    height: 40.0,
                    child: ButtonTheme(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          // widget.func(_character, _character2, _character3);
                          widget.func(_character, _character2, _character3);
                          Navigator.pop(context);
                          // Navigator.pushReplacement<void, void>(
                          //   context,
                          //   MaterialPageRoute<void>(
                          //     builder: (BuildContext context) =>
                          //         const ReportTransportTask(reset: false),
                          //   ),
                          // );
                          // showAlertConfirm(context, clearAll);
                        },
                        child: const Center(
                            child: Text(
                          "OK",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: HexColor("#4e73be"),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ConfigSortBy extends StatefulWidget {
  const ConfigSortBy({Key? key}) : super(key: key);

  @override
  State<ConfigSortBy> createState() => _ConfigSortByState();
}

class _ConfigSortByState extends State<ConfigSortBy> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                ),
                child: const Text(
                  "Sort By",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSortBy>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSortBy.transportTaskIdAndLineNo,
              groupValue: _character,
              onChanged: (SortSortBy? value) {
                setState(() {
                  _character = value!;
                });
              },
            ),
            const Text(
              'Transport Task id & Line No',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSortBy>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSortBy.partNo,
              groupValue: _character,
              onChanged: (SortSortBy? value) {
                setState(() {
                  _character = value!;
                });
              },
            ),
            const Text(
              'Part No',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSortBy>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSortBy.location,
              groupValue: _character,
              onChanged: (SortSortBy? value) {
                setState(() {
                  _character = value!;
                });
              },
            ),
            const Text(
              'Location',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSortBy>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSortBy.lotNo,
              groupValue: _character,
              onChanged: (SortSortBy? value) {
                setState(() {
                  _character = value!;
                });
              },
            ),
            const Text(
              'Lot No',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}

class ConfigSortDirection extends StatefulWidget {
  const ConfigSortDirection({Key? key}) : super(key: key);

  @override
  State<ConfigSortDirection> createState() => _ConfigSortDirectionState();
}

class _ConfigSortDirectionState extends State<ConfigSortDirection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                ),
                child: const Text(
                  "Direction",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortDirection>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortDirection.aToz,
              groupValue: _character2,
              onChanged: (SortDirection? value) {
                setState(() {
                  _character2 = value!;
                });
              },
            ),
            const Text(
              'A to Z',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortDirection>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortDirection.zToa,
              groupValue: _character2,
              onChanged: (SortDirection? value) {
                setState(() {
                  _character2 = value!;
                });
              },
            ),
            const Text(
              'Z to A',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}

class ConfigSortSearch extends StatefulWidget {
  const ConfigSortSearch({Key? key}) : super(key: key);

  @override
  State<ConfigSortSearch> createState() => _ConfigSortSearchState();
}

class _ConfigSortSearchState extends State<ConfigSortSearch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 5,
                  bottom: 3,
                ),
                child: const Text(
                  "Search Option",
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSearchOption>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSearchOption.transportTaskId,
              groupValue: _character3,
              onChanged: (SortSearchOption? value) {
                setState(() {
                  _character3 = value!;
                });
              },
            ),
            const Text(
              'Transport Task id',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSearchOption>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSearchOption.exptListNo,
              groupValue: _character3,
              onChanged: (SortSearchOption? value) {
                setState(() {
                  _character3 = value!;
                });
              },
            ),
            const Text(
              'Expt List no',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSearchOption>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSearchOption.partNo,
              groupValue: _character3,
              onChanged: (SortSearchOption? value) {
                setState(() {
                  _character3 = value!;
                });
              },
            ),
            const Text(
              'Part No',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
        Row(
          children: <Widget>[
            const SizedBox(width: 10),
            Radio<SortSearchOption>(
              activeColor: const Color.fromARGB(255, 152, 33, 243),
              value: SortSearchOption.shopOrderNo,
              groupValue: _character3,
              onChanged: (SortSearchOption? value) {
                setState(() {
                  _character3 = value!;
                });
              },
            ),
            const Text(
              'Shop Order No',
              style: TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ],
    );
  }
}
