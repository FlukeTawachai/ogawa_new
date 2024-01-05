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
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/stockPerLocation.dart/splPartNoSort.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/SppSort.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/locationNoSort.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/sppCard.dart';

class StockPerLocationPartNo extends StatefulWidget {
  final CommonResp data;
  final bool reset;
  const StockPerLocationPartNo({required this.data, required this.reset});

  @override
  State<StockPerLocationPartNo> createState() => _StockPerLocationPartNoState();
}

class _StockPerLocationPartNoState extends State<StockPerLocationPartNo> {
  double widthScreen = 0.0;
  double heightScreen = 0.0;

  String searchCheck = '';

  String uom = '';
  String locationDesc = '';
  String locationNo = '';
  double onHand = 0;
  double reserved = 0;
  double available = 0;
  var numFormat = NumberFormat("#,###.##", "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (ApiProxyParameter.splPartNo.isNotEmpty) {
      uom = '';
      locationDesc = '';
      locationNo = '';
      onHand = 0;
      reserved = 0;
      available = 0;
      for (var item in ApiProxyParameter.splPartNo) {
        uom = '${item.uom}';
        locationDesc = '${item.locationDesc}';
        locationNo = '${item.locationNo}';
        onHand += item.qtyOnHand!;
        reserved += item.qtyReserved!;
        available += item.qtyAvailable!;
      }
    }
    if (widget.reset == true) {
      getDataByLocationNo();
    }
  }

  @override
  Widget build(BuildContext context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Container(
            child: Text("${widget.data.partNo} | ${widget.data.partDesc} ")),
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
      endDrawer: SplPartNoSort(
        data: widget.data,
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
                      '${ApiProxyParameter.splPartNo.length} record found',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer()
                  ],
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ApiProxyParameter.splPartNo.length,
                  itemBuilder: (context, index) {
                    return PathCard(
                        ApiProxyParameter.splPartNo[index], index, "splLotNo");
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
                    child: Text(locationNo,
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
                    child: Text(locationDesc,
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

  getDataByLocationNo() async {
    try {
      EasyLoading.show(status: 'loading...');

      AllApiProxy proxy = AllApiProxy();
      proxy.host = '${ApiProxyParameter.apiData.apiUrl}';
      proxy.dbName = '${ApiProxyParameter.apiData.serviceName}';
      proxy.dbHost = '${ApiProxyParameter.apiData.serviceIp}';
      proxy.dbPort = int.parse('${ApiProxyParameter.apiData.port}');
      proxy.dbUser = ApiProxyParameter.userLogin;
      proxy.dbPass = ApiProxyParameter.passLogin;

      var result = await proxy.splGetDataByPartNo(CommonReq(
          partNo: widget.data.partNo, locationNo: widget.data.locationNo));
      if (result.isNotEmpty) {
        setState(() {
          ApiProxyParameter.splPartNo = [];
          ApiProxyParameter.splPartNo.addAll(result);
          uom = '';
          locationDesc = '';
          locationNo = '';
          onHand = 0;
          reserved = 0;
          available = 0;
          for (var item in result) {
            uom = '${item.uom}';
            locationDesc = '${item.locationDesc}';
            locationNo = '${item.locationNo}';
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
