import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/deliveryConfirmationReq.dart';
import 'package:ogawa_nec/api/response/deliveryConfirmationResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/saveDialog.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';

class PartNoMain extends StatefulWidget {
  final DeliveryConfirmationResp data;
  const PartNoMain({Key? key, required this.data}) : super(key: key);

  @override
  State<PartNoMain> createState() => _PartNoMainState();
}

class _PartNoMainState extends State<PartNoMain> {
  final TextEditingController _barcodeNo = TextEditingController();
  final TextEditingController _carton = TextEditingController();
  final TextEditingController _barcodeID = TextEditingController();
  final TextEditingController _containerNo = TextEditingController();
  final TextEditingController _newQty = TextEditingController();
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  List<ConfirmDeliveryBarcode> barcodeList = [];
  late Box<ConfirmDeliveryBarcode> barcodeData;
  bool saveNext = false;
  List<ConfirmDeliveryBarcode> containerNo = [];
  late Box<ConfirmDeliveryBarcode> containerNoData;

  var numFormat = NumberFormat("#,###.##", "en_US");
  String barcodeID = "";
  String carton = "";
  double noOfCarton = 0;
  double reservedQty = 0;
  double reportedQty = 0;
  double reportedInput = 0;
  double totBox = 0;
  bool reAdd = true;
  String containerNoTxt = '';
  double sps = 0;
  bool canAdd = true;
  bool canAddNo = true;
  bool canSave = true;
  double heightScreen = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = Hive.box('ApiSettings');
    barcodeData = Hive.box("ConfirmDeliveryBarcode");
    containerNoData = Hive.box("ConfirmDeliveryContainerNo");
    barcodeList = barcodeData.values.toList();
    containerNo = containerNoData.values.toList();

    if (containerNo.isNotEmpty) {
      for (int i = 0; i < containerNo.length; i++) {
        if (containerNo[i].id == ApiProxyParameter.userLogin) {
          _containerNo.text = '${containerNo[i].containerNo}';
          containerNoTxt = '${containerNo[i].containerNo}';
        }
      }
    }
    resetHive();
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            'Ship No: ' +
                "${widget.data.shipmentNo}" +
                '|' +
                'Line:' +
                "${widget.data.lineNo}" +
                '|' +
                'Rem. Box:' +
                // ignore: prefer_const_constructors
                numFormat.format(widget.data.noOfCarton! - totBox),
            style: const TextStyle(fontSize: 16),
          ),
        ),
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
      ),
      drawer: const MenuSide(),
      body: dataList(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height * 15 / 100,
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
            canAdd == true
                ? SpeedDialChild(
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
                  )
                : SpeedDialChild(
                    child: const Icon(
                      Icons.playlist_add,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                    backgroundColor: Colors.grey.shade300,
                    onTap: () async {
                      // _addBarcodeIDDialog();
                    },
                    onLongPress: () async {
                      // _addBarcodeIDDialog();
                    },
                  ),
            canAddNo == true
                ? SpeedDialChild(
                    child: const Icon(
                      Icons.add_to_photos_rounded,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                    backgroundColor: Colors.white,
                    onTap: () async {
                      _addCustomerBarcodeDialog();
                    },
                    onLongPress: () async {
                      _addCustomerBarcodeDialog();
                    },
                  )
                : SpeedDialChild(
                    child: const Icon(
                      Icons.add_to_photos_rounded,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                    backgroundColor: Colors.grey.shade300,
                    onTap: () async {
                      // _addCustomerBarcodeDialog();
                    },
                    onLongPress: () async {
                      // _addCustomerBarcodeDialog();
                    },
                  ),
            canSave == true
                ? SpeedDialChild(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(
                        Icons.save,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    onTap: () async {
                      _containerDialog(widget.data);
                    },
                  )
                : SpeedDialChild(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(
                        Icons.save,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade300,
                    onTap: () async {
                      // _containerDialog(widget.data);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _bottomSheet() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.black),
            ),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
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
                        padding: const EdgeInsets.all(0),
                        child: AutoSizeText(
                          '${widget.data.partNo}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#0070c0"),
                            fontSize: 16.0,
                          ),
                          minFontSize: 16.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: AutoSizeText(
                          '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#bfbfbf"),
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          minFontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.0,
                      padding: const EdgeInsets.all(0),
                      child: AutoSizeText(
                        'Reserved:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          color: HexColor("#0070c0"),
                          fontSize: 16.0,
                        ),
                        minFontSize: 16.0,
                      ),
                    ),
                    Container(
                      width: 60.0,
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: AutoSizeText(
                        numFormat.format(widget.data.reservedQty),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          color: HexColor("#0070c0"),
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        minFontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              //--------------------
              Container(
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
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: AutoSizeText(
                          '${widget.data.partDesc}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#bfbfbf"),
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          minFontSize: 12.0,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.0,
                      padding: const EdgeInsets.all(0),
                      child: AutoSizeText(
                        'Reported:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          //fontWeight: FontWeight.bold,
                          color: HexColor("#a10515"),
                          fontSize: 16.0,
                        ),
                        minFontSize: 16.0,
                      ),
                    ),
                    Container(
                      width: 60.0,
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: AutoSizeText(
                        numFormat.format(reportedQty),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          //fontWeight: FontWeight.bold,
                          color: HexColor("#a10515"),
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
                        minFontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              //------------------
              Container(
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
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          right: 10.0,
                        ),
                        child: AutoSizeText(
                          sps > 0
                              ? 'Tot BOX: ${numFormat.format(totBox)}'
                              : 'Tot BOX: 0',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#a10515"),
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          minFontSize: 12.0,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.0,
                      padding: const EdgeInsets.all(0),
                      child: AutoSizeText(
                        'Remaining:',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //fontStyle: FontStyle.italic,
                          //fontWeight: FontWeight.bold,
                          color: HexColor("#7fa968"),
                          fontSize: 16.0,
                        ),
                        minFontSize: 16.0,
                      ),
                    ),
                    Container(
                      width: 60.0,
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: AutoSizeText(
                        numFormat.format(noOfCarton),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          //fontStyle: FontStyle.italic,
                          //fontWeight: FontWeight.bold,
                          color: HexColor("#7fa968"),
                          fontSize: 16.0,
                        ),
                        maxLines: 1,
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

  Widget dataList() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: ApiProxyParameter.dataListKCustBarcode.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          decoration: index % 2 == 0
              ? WidgetStyle.decorationForList()
              : WidgetStyle.decorationForListOdd(),
          child: Container(
            padding: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
            child: Column(
              children: [
                Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    extentRatio: 0.15,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Tdialog.infoDialog(
                            context,
                            'Confirm deleted?',
                            'Are you sure to delete the selected\nBarcode id?',
                            acceptDeleteButton(
                                ApiProxyParameter.dataListKCustBarcode[index],
                                index),
                            cancelButton(),
                          );
                        },
                        backgroundColor: HexColor("#ff0000"),
                        foregroundColor: Colors.white,
                        icon: Icons.delete_outline,
                      ),
                    ],
                  ),
                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: ActionPane(
                    extentRatio: 0.15,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          setState(() {
                            _newQty.text =
                                "${ApiProxyParameter.dataListKCustBarcode[index].reportedQty}";
                          });
                          _newQtyDialog(
                              ApiProxyParameter.dataListKCustBarcode[index]);
                        },
                        backgroundColor: HexColor("#0070c0"),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: Container(
                    //height: 50.0,
                    padding: const EdgeInsets.only(),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(),
                          child: Row(
                            children: [
                              Container(
                                width: 100.0,
                                padding: const EdgeInsets.only(),
                                child: _partNo(
                                    '${ApiProxyParameter.dataListKCustBarcode[index].partNo}'),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _cusBarcode(
                                      '${ApiProxyParameter.dataListKCustBarcode[index].customerBarcode}'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(),
                                child: _qty(numFormat.format(ApiProxyParameter
                                    .dataListKCustBarcode[index].reportedQty)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _itemNo(
                                      '${ApiProxyParameter.dataListKCustBarcode[index].itemNo}'),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _no(numFormat.format(index + 1)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _addCustomerBarcodeDialog() {
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
                          'Customer Barcode',
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
                          controller: _barcodeNo,
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

                              barcodeID = textList[0];
                              _barcodeNo.text = textList[0];
                              _barcodeNo.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _barcodeNo.text.length));
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              Navigator.pop(context, 'Save');
                              var check = false;
                              for (int i = 0;
                                  i <
                                      ApiProxyParameter
                                          .dataListKCustBarcode.length;
                                  i++) {
                                if (ApiProxyParameter.dataListKCustBarcode[i]
                                        .customerBarcode ==
                                    barcodeID) {
                                  check = true;
                                }
                              }
                              // if (check == true) {
                              //   Tdialog.errorDialog(
                              //     context,
                              //     'Error',
                              //     'Customer Barcode is repeat.',
                              //     okButton(),
                              //   );
                              // } else {
                              if (barcodeID == "") {
                                Tdialog.errorDialog(
                                  context,
                                  'Error',
                                  'Customer Barcode is empty.',
                                  okButton(),
                                );
                              } else {
                                if (carton == '') {
                                  Tdialog.errorDialog(
                                    context,
                                    'Error',
                                    'No. of Carton is zero.',
                                    okButton(),
                                  );
                                } else {
                                  setState(() {
                                    reAdd = true;
                                  });

                                  getDataByCustomerBarcode(barcodeID,
                                      double.parse(carton), true, false);
                                }
                              }

                              // }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: const Text(
                          'No. of Carton',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10.0, top: 10.0),
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
                          controller: _carton,
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
                              carton = value;
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
                    setState(() {
                      reAdd = false;
                    });
                    Navigator.pop(context, 'Cancel');
                    _barcodeNo.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context, 'Save');
                      var check = false;
                      for (int i = 0;
                          i < ApiProxyParameter.dataListKCustBarcode.length;
                          i++) {
                        if (ApiProxyParameter
                                .dataListKCustBarcode[i].customerBarcode ==
                            barcodeID) {
                          check = true;
                        }
                      }
                      // if (check == true) {
                      //   Tdialog.errorDialog(
                      //     context,
                      //     'Error',
                      //     'Customer Barcode is repeat.',
                      //     okButton(),
                      //   );
                      // } else {
                      if (barcodeID == "") {
                        Tdialog.errorDialog(
                          context,
                          'Error',
                          'Customer Barcode  is empty.',
                          okButton(),
                        );
                      } else {
                        if (carton == '') {
                          Tdialog.errorDialog(
                            context,
                            'Error',
                            'No. of Carton is zero.',
                            okButton(),
                          );
                        } else {
                          setState(() {
                            reAdd = true;
                          });

                          getDataByCustomerBarcode(
                              barcodeID, double.parse(carton), true, false);
                        }
                      }
                      // }
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text(
                    'Customer Barcode',
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
                    controller: _barcodeID,
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

                        barcodeID = textList[0];
                        _barcodeID.text = textList[0];
                        _barcodeID.selection = TextSelection.fromPosition(
                            TextPosition(offset: _barcodeID.text.length));
                      });
                    },
                    onFieldSubmitted: (V) {
                      var check = false;
                      for (int i = 0;
                          i < ApiProxyParameter.dataListKCustBarcode.length;
                          i++) {
                        if (ApiProxyParameter
                                .dataListKCustBarcode[i].customerBarcode ==
                            barcodeID) {
                          check = true;
                        }
                      }
                      // if (check == true) {
                      //   Tdialog.errorDialog(
                      //     context,
                      //     'Error',
                      //     'Customer Barcode is repeat.',
                      //     okButton(),
                      //   );
                      // } else {
                      setState(() {
                        reAdd = true;
                      });
                      getDataByCustomerBarcode(barcodeID, 0, false, true);
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
                    setState(() {
                      reAdd == false;
                    });
                    Navigator.pop(context, 'Cancel');
                    _barcodeID.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    var check = false;
                    for (int i = 0;
                        i < ApiProxyParameter.dataListKCustBarcode.length;
                        i++) {
                      if (ApiProxyParameter
                              .dataListKCustBarcode[i].customerBarcode ==
                          barcodeID) {
                        check = true;
                      }
                    }
                    // if (check == true) {
                    //   Tdialog.errorDialog(
                    //     context,
                    //     'Error',
                    //     'Customer Barcode is repeat.',
                    //     okButton(),
                    //   );
                    // } else {
                    setState(() {
                      reAdd = true;
                    });
                    getDataByCustomerBarcode(barcodeID, 0, false, false);
                    // }

                    Navigator.pop(context, 'Save');
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

  _containerDialog(DeliveryConfirmationResp data) async {
    return await showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => SaveDialog(
              data: data,
              reportedQty: reportedQty,
              okButton: okButton(),
              confirmDelivery: confirmDelivery,
              save: acceptButtonNew(),
              cancel: cancelButton(),
            ));
  }

  Widget acceptDeleteButton(DeliveryConfirmationResp data, int index) {
    return TextButton(
      onPressed: () {
        //go to function.....
        setState(() {
          ApiProxyParameter.dataListKCustBarcode.removeAt(index);
        });
        barcodeList = barcodeData.values.toList();
        for (int i = 0; i < barcodeList.length; i++) {
          if (barcodeList[i].key == data.key) {
            barcodeData.delete(barcodeList[i].key);
          }
        }
        resetTotal();
        Navigator.pop(context, 'ACCEPT');
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

  Widget acceptButtonNew() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'ACCEPT');
        if (GlobalParam.menuKContainerNo != '') {
          if (saveNext == true) {
            containerNo = containerNoData.values.toList();
            if (containerNo.isNotEmpty) {
              for (int i = 0; i < containerNo.length; i++) {
                if (containerNo[i].id == ApiProxyParameter.userLogin) {
                  containerNo[i].containerNo = GlobalParam.menuKContainerNo;
                  containerNoData.delete(containerNo[i].key);
                  containerNoData.put(containerNo[i].id, containerNo[i]);
                }
              }
            } else {
              var data = ConfirmDeliveryBarcode(
                  id: ApiProxyParameter.userLogin,
                  containerNo: GlobalParam.menuKContainerNo);
              containerNoData.put(data.id, data);
            }
          }
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            'Container No is entity.',
            okButton(),
          );
        }
        confirmDelivery(GlobalParam.menuKContainerNo);

        //_save();dataSettingdataSetting
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
        Navigator.pop(context, 'CANCEL');
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
        print("CCCCCCCCCCC");
        Navigator.pop(context, 'OK');
        setState(() {
          _barcodeID.clear();
          _barcodeNo.clear();
          _carton.clear();
          barcodeID = '';
          carton = '';
        });
        resetTotal();
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
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
              'Part No.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 10.0,
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
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cusBarcode(String txtcusBarcode) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Customer Barcode',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtcusBarcode,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#68548c"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 14.0,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Qty',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtqty,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#68548c"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 14.0,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 10.0,
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
              minFontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _no(String txtno) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'No.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtno,
              textAlign: TextAlign.right,
              // ignore: prefer_const_constructors
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  _newQtyDialog(DeliveryConfirmationResp data) {
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
            height: 60.0,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: const Text(
                    'New Quantity',
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
                  height: 30.0,
                  color: HexColor("#d9e1f2"),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _newQty,
                    autofocus: true,
                    onChanged: (value) {
                      if (value != '') {
                        setState(() {
                          reportedInput = double.parse(value);
                        });
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
                    _newQty.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    if (reportedInput > 0) {
                      setState(() {
                        for (int i = 0;
                            i < ApiProxyParameter.dataListKCustBarcode.length;
                            i++) {
                          if (ApiProxyParameter.dataListKCustBarcode[i].key ==
                              data.key) {
                            ApiProxyParameter.dataListKCustBarcode[i]
                                .reportedQty = reportedInput;
                          }
                        }
                        _newQty.clear();
                      });
                      barcodeList = barcodeData.values.toList();
                      for (int i = 0; i < barcodeList.length; i++) {
                        if (barcodeList[i].shipmentNo ==
                            widget.data.shipmentNo) {
                          if (barcodeList[i].lineNo == widget.data.lineNo) {
                            if (barcodeList[i].customerNo ==
                                widget.data.customerNo) {
                              if (barcodeList[i].invoiceNo ==
                                  widget.data.invoiceNo) {
                                if (barcodeList[i].partNo ==
                                    widget.data.partNo) {
                                  if (barcodeList[i].key == data.key) {
                                    barcodeList[i].reportedQty = reportedInput;
                                    barcodeData.delete(barcodeList[i].key);
                                    barcodeData.put(
                                        barcodeList[i].id, barcodeList[i]);
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                      resetTotal();
                    } else {
                      Tdialog.errorDialog(
                        context,
                        'Error',
                        "New Quantity need more than zero.",
                        okButton(),
                      );
                    }

                    Navigator.pop(context, 'Save');
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

  resetHive() {
    database = Hive.box('ApiSettings');
    barcodeData = Hive.box("ConfirmDeliveryBarcode");
    barcodeList = barcodeData.values.toList();
    ApiProxyParameter.dataListKCustBarcode = [];
    noOfCarton = 0;
    reservedQty = 0;
    reportedQty = 0;

    for (var i = 0; i < ApiProxyParameter.dataListKCustBarcode.length; i++) {
      reservedQty += ApiProxyParameter.dataListKCustBarcode[i].reservedQty!;
      reportedQty += ApiProxyParameter.dataListKCustBarcode[i].reportedQty!;
    }

    noOfCarton = widget.data.reservedQty! - reportedQty;

    if (barcodeList.isNotEmpty) {
      for (int i = 0; i < barcodeList.length; i++) {
        if (barcodeList[i].shipmentNo == widget.data.shipmentNo) {
          if (barcodeList[i].lineNo == widget.data.lineNo) {
            if (barcodeList[i].customerNo == widget.data.customerNo) {
              if (barcodeList[i].invoiceNo == widget.data.invoiceNo) {
                if (barcodeList[i].partNo == widget.data.partNo) {
                  sps = barcodeList[i].sps ?? 0.0;
                  var data = DeliveryConfirmationResp(
                    key: barcodeList[i].key,
                    customerBarcode: barcodeList[i].customerBarcode,
                    shipmentNo: widget.data.shipmentNo,
                    lineNo: widget.data.lineNo,
                    customerNo: widget.data.customerNo,
                    customerName: widget.data.customerName,
                    etdDate: widget.data.etdDate,
                    invoiceNo: widget.data.invoiceNo,
                    partNo: widget.data.partNo,
                    partDesc: widget.data.partDesc,
                    itemNo: barcodeList[i].itemNo,
                    noOfCarton: widget.data.noOfCarton,
                    reservedQty: widget.data.reservedQty,
                    reportedQty: barcodeList[i].reportedQty,
                  );
                  ApiProxyParameter.dataListKCustBarcode.add(data);
                  resetTotal();
                }
              }
            }
          }
        }
      }
    }
  }

  getDataByCustomerBarcode(
      String customerBarcode, double qty, bool check, bool enter) async {
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

      var result =
          await proxy.kGetDataByCustomerBarcode(DeliveryConfirmationReq(
              customerBarcode: customerBarcode,
              partNo: widget.data.partNo,
              // partNo: "SA078",
              noOfCarton: 0,
              reservedQty: 0,
              reportedQty: 0));
      if (result.errorMessage == null) {
        // ApiProxyParameter.dataListKCustBarcode = [];
        double reportedQty = result.reportedQty!;
        sps = result.reportedQty!;
        if (check == true) {
          reportedQty = qty * result.reportedQty!;
        }
        ApiProxyParameter.dataListKCustBarcode.add(result);
        var checkList = barcodeData.values.toList();
        List<String> barcodeCheck = [];

        for (int i = 0; i < barcodeList.length; i++) {
          barcodeCheck.add('${barcodeList[i].id}');
        }
        var data = ConfirmDeliveryBarcode(
            id: generateId(barcodeCheck),
            customerBarcode: result.customerBarcode,
            shipmentNo: widget.data.shipmentNo,
            lineNo: widget.data.lineNo,
            customerNo: widget.data.customerNo,
            customerName: widget.data.customerName,
            etdDate: widget.data.etdDate,
            invoiceNo: widget.data.invoiceNo,
            partNo: widget.data.partNo,
            partDesc: widget.data.partDesc,
            itemNo: result.itemNo,
            noOfCarton: widget.data.noOfCarton,
            reservedQty: widget.data.reservedQty,
            reportedQty: reportedQty,
            sps: result.reportedQty);
        barcodeData.put(data.id, data);
        resetHive();
        resetTotal();

        _barcodeID.clear();
        _barcodeNo.clear();
        _carton.clear();
        barcodeID = '';
        carton = '';
        if (reAdd == true) {
          if (check == true) {
            // _addCustomerBarcodeDialog();
          } else {
            if (enter == false) {
              _addBarcodeIDDialog();
            }
          }
        }
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          "${result.errorMessage}",
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
    setState(() {});
  }

  confirmDelivery(String containerNo) async {
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
      // String data = "${widget.data.shipmentNo}";
      // getDataByShipmentNo("${widget.data.shipmentNo}");
      if (widget.data.shipmentNo != "" &&
          widget.data.shipmentNo != null &&
          containerNo != "") {
        var result = await proxy.confirmDelivery(DeliveryConfirmationReq(
            shipmentNo: widget.data.shipmentNo,
            lineNo: widget.data.lineNo,
            containerNo: containerNo,
            noOfCarton: 0,
            reservedQty: 0,
            reportedQty: reportedQty));
        if (result.errorMessage == null) {
          ApiProxyParameter.dataListKCustBarcode = [];
          barcodeList = barcodeData.values.toList();
          for (int i = 0; i < barcodeList.length; i++) {
            if (barcodeList[i].shipmentNo == widget.data.shipmentNo) {
              if (barcodeList[i].lineNo == widget.data.lineNo) {
                if (barcodeList[i].customerNo == widget.data.customerNo) {
                  if (barcodeList[i].invoiceNo == widget.data.invoiceNo) {
                    if (barcodeList[i].partNo == widget.data.partNo) {
                      barcodeData.delete(barcodeList[i].key);
                    }
                  }
                }
              }
            }
          }
          // Navigator.pop(context, 'ACCEPT');
          setState(() {
            widget.data.reservedQty = 0;
            reportedQty = 0;
            totBox = 0;
            noOfCarton = 0;
            widget.data.noOfCarton = 0;
            canAdd = false;
            canAddNo = false;
            canSave = false;
          });
          // Tdialog.successDialog(context, "Information",
          //     "All cartons have been moved into the container.", okButton());

          ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
              context,
              'All cartons have been moved into the container.',
              heightScreen));
          Navigator.pop(context, 'OK');
          setState(() {
            _barcodeID.clear();
            _barcodeNo.clear();
            _carton.clear();
            barcodeID = '';
            carton = '';
          });
          resetTotal();
          // resetTotal();
          // getDataByShipmentNo("${widget.data.shipmentNo}");
          // _containerNo.clear();
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            '${result.errorMessage}',
            okButton(),
          );
        }
      }

      // Tdialog.errorDialog(
      //   context,
      //   'Error',
      //   '',
      //   okButton(),
      // );

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
            var check = false;
            for (int i = 0; i < result.length; i++) {
              if (result[i].shipmentNo == widget.data.shipmentNo) {
                if (result[i].lineNo == widget.data.lineNo) {
                  check = true;
                }
              }
            }
            if (check == true) {
              for (int i = 0; i < result.length; i++) {
                if (result[i].shipmentNo == widget.data.shipmentNo) {
                  if (result[i].lineNo == widget.data.lineNo) {
                    widget.data.reservedQty = result[i].reservedQty;
                    widget.data.noOfCarton = result[i].noOfCarton;
                  }
                }
              }
            } else {
              widget.data.reservedQty = 0;
              widget.data.noOfCarton = 0;
            }
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              '${result[0].errorMessage}',
              okButton(),
            );
            // ApiProxyParameter.dataListK = [];
          }
        } else {
          ApiProxyParameter.dataListK = [];
          ApiProxyParameter.dataListK.addAll(result);
          var check = false;
          for (int i = 0; i < result.length; i++) {
            if (result[i].shipmentNo == widget.data.shipmentNo) {
              if (result[i].lineNo == widget.data.lineNo) {
                check = true;
              }
            }
          }
          if (check == true) {
            for (int i = 0; i < result.length; i++) {
              if (result[i].shipmentNo == widget.data.shipmentNo) {
                if (result[i].lineNo == widget.data.lineNo) {
                  widget.data.reservedQty = result[i].reservedQty;
                  widget.data.noOfCarton = result[i].noOfCarton;
                }
              }
            }
          } else {
            widget.data.reservedQty = 0;
            widget.data.noOfCarton = 0;
          }
        }
      } else {
        ApiProxyParameter.dataListK = [];
      }
      resetTotal();
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

  resetTotal() {
    setState(() {
      noOfCarton = 0;
      reservedQty = 0;
      reportedQty = 0;
      for (var i = 0; i < ApiProxyParameter.dataListKCustBarcode.length; i++) {
        reservedQty += ApiProxyParameter.dataListKCustBarcode[i].reservedQty!;
        reportedQty += ApiProxyParameter.dataListKCustBarcode[i].reportedQty!;
      }

      if (sps > 0) {
        totBox = reportedQty / sps;
      }

      noOfCarton = widget.data.reservedQty! - reportedQty;
    });
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
