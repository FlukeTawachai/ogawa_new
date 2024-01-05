import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/deliveryConfirmationReq.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/partnoMain.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/deliveryConfirmationSort.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/listShipment.dart';

class DeliveryConfirmationMain extends StatefulWidget {
  final bool reset;
  const DeliveryConfirmationMain({Key? key, required this.reset})
      : super(key: key);

  @override
  State<DeliveryConfirmationMain> createState() =>
      _DeliveryConfirmationMainState();
}

class _DeliveryConfirmationMainState extends State<DeliveryConfirmationMain> {
  final FocusNode _nodesearchOption = FocusNode();
  final TextEditingController _searchOptionNo = TextEditingController();
  int charLength = 0;
  String _search = 'Please Input Shipment No';
  //int sortIndex = 0;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  String searchBy = 'SN';
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  String search = '';
  var numFormat = NumberFormat("#,###.##", "en_US");

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      if (value == '') {
        ApiProxyParameter.dataListK = [];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    if (userSearchDefault.isNotEmpty) {
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_K') {
          if (userSearchDefault[i].searchBy == 'SN') {
            setState(() {
              _search = "Please Input Shipment No";
              searchBy = 'SN';
            });
          } else if (userSearchDefault[i].searchBy == 'CN') {
            setState(() {
              _search = "Please Input Customer No";
              searchBy = 'CN';
            });
          } else if (userSearchDefault[i].searchBy == 'PN') {
            setState(() {
              _search = "Please Input Part No";
              searchBy = 'PN';
            });
          } else if (userSearchDefault[i].searchBy == 'IN') {
            setState(() {
              _search = "Please Input Invoice No";
              searchBy = 'IN';
            });
          }
        }
      }
    }
    if (widget.reset == true) {
      ApiProxyParameter.dataListK = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchAppbar(),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  Scaffold.of(context).openDrawer();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor("#4e73be"),
                  shape: BoxShape.rectangle,
                ),
                child: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      drawer: const MenuSide(),
      endDrawer: const DeliveryConfirmationSort(),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                //top: 2.0,
                bottom: 2.0,
                left: 10.0,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                '${ApiProxyParameter.dataListK.length} records found',
                style: const TextStyle(
                  color: Colors.grey,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: _lstShipment(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBarFooter(),
    );
  }

  Widget _searchAppbar() {
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
        controller: _searchOptionNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.all(0.0),
          hintText: _search,
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
                _searchOptionNo.clear();
              });
            },
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _searchOptionNo.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _searchOptionNo.clear();
                        ApiProxyParameter.dataListK = [];
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: _onChanged,
        onFieldSubmitted: (value) {
          if (value == '') {
            ApiProxyParameter.dataListK = [];
          } else {
            if (searchBy == 'SN') {
              getDataByShipmentNo(value);
            } else if (searchBy == 'CN') {
              getDataByCustomerNo(value);
            } else if (searchBy == 'PN') {
              getDataByPartNo(value);
            } else if (searchBy == 'IN') {
              getDataByInvoiceNo(value);
            }
          }
        },
      ),
    );
  }

  Widget _lstShipment() {
    return ListView.builder(
      // shrinkWrap: true,
      // scrollDirection: Axis.vertical,
      itemCount: ApiProxyParameter.dataListK.length,
      itemBuilder: (BuildContext context, int index) {
        String etdDate = '';
        if (ApiProxyParameter.dataListK[index].etdDate != null) {
          etdDate = Jiffy.parse(ApiProxyParameter.dataListK[index].etdDate!)
                .format(pattern: 'do-MMMM-yyyy');
        }
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PartNoMain(
                  data: ApiProxyParameter.dataListK[index],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Container(
              decoration: index % 2 == 0
                  ? WidgetStyle.decorationForList()
                  : WidgetStyle.decorationForListOdd(),
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _shipNo(
                              '${ApiProxyParameter.dataListK[index].shipmentNo}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _lineNo(
                              '${ApiProxyParameter.dataListK[index].lineNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _date(etdDate),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _qty(numFormat.format(
                              ApiProxyParameter.dataListK[index].reservedQty)),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          padding: const EdgeInsets.only(),
                          child: _partNo(
                              '${ApiProxyParameter.dataListK[index].partNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _receiverID(
                                '${ApiProxyParameter.dataListK[index].customerNo}'),
                          ),
                        ),
                        Container(
                          width: 25.0,
                          padding: const EdgeInsets.only(right: 5.0),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 25.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          padding: const EdgeInsets.only(),
                          child: _itemNo(
                              '${ApiProxyParameter.dataListK[index].itemNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _receiverName(
                                '${ApiProxyParameter.dataListK[index].customerName}'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: _carton(numFormat.format(
                              ApiProxyParameter.dataListK[index].noOfCarton)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _shipNo(String txtshipNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Ship No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtshipNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineNo(String txtlineNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Line No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtlineNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _date(String txtdate) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'ETD Date',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtdate,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#7fa968"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qty(String txtqty) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Qty',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtqty,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _partNo(String txtpartNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Sales Part No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtpartNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiverID(String txtreceiverID) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Receiver Add ID',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtreceiverID,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#70598d"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemNo(String txtitemNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Item No.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtitemNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#d88f5a"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiverName(String txtreceiverName) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Receiver Name',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtreceiverName,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _carton(String txtcarton) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'No. of Carton',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtcarton,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#d88f5a"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  getDataByShipmentNo(String search) async {
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

      var result = await proxy.getDataByShipmentNo(DeliveryConfirmationReq(
          shipmentNo: search, noOfCarton: 0, reservedQty: 0, reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            ApiProxyParameter.dataListK = [];
            ApiProxyParameter.dataListK.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          ApiProxyParameter.dataListK = [];
          ApiProxyParameter.dataListK.addAll(result);
        }
      } else {
        ApiProxyParameter.dataListK = [];
      }
      setState(() {});
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

  getDataByCustomerNo(String search) async {
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

      var result = await proxy.kGetDataByCustomerNo(DeliveryConfirmationReq(
          customerNo: search, noOfCarton: 0, reservedQty: 0, reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            ApiProxyParameter.dataListK = [];
            ApiProxyParameter.dataListK.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          ApiProxyParameter.dataListK = [];
          ApiProxyParameter.dataListK.addAll(result);
        }
      } else {
        ApiProxyParameter.dataListK = [];
      }
      setState(() {});
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

  getDataByPartNo(String search) async {
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

      var result = await proxy.kGetDataByPartNo(DeliveryConfirmationReq(
          partNo: search, noOfCarton: 0, reservedQty: 0, reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            ApiProxyParameter.dataListK = [];
            ApiProxyParameter.dataListK.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          ApiProxyParameter.dataListK = [];
          ApiProxyParameter.dataListK.addAll(result);
        }
      } else {
        ApiProxyParameter.dataListK = [];
      }
      setState(() {});
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

  getDataByInvoiceNo(String search) async {
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

      var result = await proxy.getDataByInvoiceNo(DeliveryConfirmationReq(
          invoiceNo: search, noOfCarton: 0, reservedQty: 0, reportedQty: 0));
      if (result.isNotEmpty) {
        if (result.length == 1) {
          if (result[0].errorMessage == null) {
            ApiProxyParameter.dataListK = [];
            ApiProxyParameter.dataListK.addAll(result);
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
          }
        } else {
          ApiProxyParameter.dataListK = [];
          ApiProxyParameter.dataListK.addAll(result);
        }
      } else {
        ApiProxyParameter.dataListK = [];
      }
      setState(() {});
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
