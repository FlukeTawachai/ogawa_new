// 30/01/2023 getDataByPartNo()
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/commonReq.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';

import 'package:ogawa_nec/screen/stockPerPart.dart/SppSort.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/partNoSort.dart';

import 'sppCard.dart';

class StockPerPart extends StatefulWidget {
  final bool autoFocusSearch;
  const StockPerPart({Key? key, required this.autoFocusSearch})
      : super(key: key);

  @override
  State<StockPerPart> createState() => _StockPerPartState();
}

class _StockPerPartState extends State<StockPerPart> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;
  var search = TextEditingController();

  String searchCheck = '';
  String uom = '';
  String partDesc = '';
  String partNo = '';
  double onHand = 0;
  double reserved = 0;
  double available = 0;
  var numFormat = NumberFormat("#,###.##", "en_US");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.autoFocusSearch == true) {
      ApiProxyParameter.partNo = [];
    }

    if (ApiProxyParameter.partNo.isNotEmpty) {
      uom = '';
      partDesc = '';
      partNo = '';
      onHand = 0;
      reserved = 0;
      available = 0;
      for (var item in ApiProxyParameter.partNo) {
        uom = '${item.uom}';
        partDesc = '${item.partDesc}';
        partNo = '${item.partNo}';
        onHand += item.qtyOnHand!;
        reserved += item.qtyReserved!;
        available += item.qtyAvailable!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Container(child: searchBar()),
        backgroundColor: HexColor('2056AE'),
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
      endDrawer: PartNoSort(
        searchData: GlobalParam.searchHintNIndex,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: <Widget>[
              SizedBox(
                child: Row(
                  children: [
                    Text(
                      '${ApiProxyParameter.partNo.length} record found',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer()
                  ],
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ApiProxyParameter.partNo.length,
                  itemBuilder: (context, index) {
                    return PathCard(ApiProxyParameter.partNo[index], index,
                        "sppLocationNo");
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 132,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: ListView(
          children: [
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.5,
                    child: Text(partNo,
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.15,
                    child: const Text(
                      'On Hand:',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: widthScreen * 0.22,
                    child: Text(
                      numFormat.format(onHand),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.5,
                    child: Text(partDesc,
                        overflow: TextOverflow.ellipsis,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.15,
                    child: const Text('Res:',
                        style: TextStyle(
                            color: Colors.red, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.22,
                    child: Text(numFormat.format(reserved),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Row(
                children: [
                  SizedBox(
                    width: widthScreen * 0.5,
                    child: Text(uom,
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.15,
                    child: const Text('Avail:',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.start),
                  ),
                  SizedBox(
                    width: widthScreen * 0.22,
                    child: Text(numFormat.format(available),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.end),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const BottomBarFooter()
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      alignment: Alignment.centerLeft,
      color: HexColor('2056AE'),
      height: 60.0,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 12, 0, 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 12,
              ),
              InkWell(
                onTap: () {
                  if (search.text != '') {
                    getDataByPartNo();
                  } else {
                    ApiProxyParameter.partNo = [];
                    setState(() {
                      uom = '';
                      partDesc = '';
                      partNo = '';
                      onHand = 0;
                      reserved = 0;
                      available = 0;
                    });
                  }
                },
                child: Icon(
                  Icons.search,
                  color: HexColor('#6c7e9b'),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TextField(
                    autofocus: widget.autoFocusSearch,
                    controller: search,
                    style: const TextStyle(
                      fontFamily: 'Prompt',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        search.text = value;
                        if (value != '' && value != null) {
                          getDataByPartNo();
                        } else {
                          ApiProxyParameter.partNo = [];
                          setState(() {
                            uom = '';
                            partDesc = '';
                            partNo = '';
                            onHand = 0;
                            reserved = 0;
                            available = 0;
                          });
                        }
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        searchCheck = value;
                      });
                    },
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: "Please input part number",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              searchCheck != ''
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          search.text = '';
                          searchCheck = '';
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Image.asset(
                          'assets/images/close.png',
                          height: 24,
                          scale: 1,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  getDataByPartNo() async {
    try {
      EasyLoading.show(status: 'loading...');

      AllApiProxy proxy = AllApiProxy();
      proxy.host = '${ApiProxyParameter.apiData.apiUrl}';
      proxy.dbName = '${ApiProxyParameter.apiData.serviceName}';
      proxy.dbHost = '${ApiProxyParameter.apiData.serviceIp}';
      proxy.dbPort = int.parse('${ApiProxyParameter.apiData.port}');
      proxy.dbUser = ApiProxyParameter.userLogin;
      proxy.dbPass = ApiProxyParameter.passLogin;

      var result =
          await proxy.sppGetDataByPartNo(CommonReq(partNo: search.text));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.partNo = [];
          ApiProxyParameter.partNo.addAll(result);
          uom = '';
          partDesc = '';
          partNo = '';
          onHand = 0;
          reserved = 0;
          available = 0;
          for (var item in result) {
            uom = '${item.uom}';
            partDesc = '${item.partDesc}';
            partNo = '${item.partNo}';
            onHand += item.qtyOnHand!;
            reserved += item.qtyReserved!;
            available += item.qtyAvailable!;
          }
        });
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          'Part is empty',
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
