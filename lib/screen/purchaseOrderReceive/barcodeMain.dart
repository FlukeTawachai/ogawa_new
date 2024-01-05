import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/purchaseOrderReceiveReq.dart';
import 'package:ogawa_nec/api/response/purchaseOrderReceiveResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';

class BarcodeMain extends StatefulWidget {
  final String poNo;
  final PurchaseOrderReceiveResp data;
  const BarcodeMain({Key? key, required this.poNo, required this.data})
      : super(key: key);

  @override
  State<BarcodeMain> createState() => _BarcodeMainState();
}

class _BarcodeMainState extends State<BarcodeMain> {
  final TextEditingController _barcodeId = TextEditingController();
  final TextEditingController _invoiceNo = TextEditingController();
  final TextEditingController _actualDate = TextEditingController(
      text: DateFormat('dd-MMM-yy').format(DateTime.now()));
  String _txtInvoiceNo = '';
  String _txtActualDate = '';
  String _txtActualFormatDate = '';
  String actualArrivalDate = '';

  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  List<PurchaseOrderReceiveBarcode> barcodeList = [];
  late Box<PurchaseOrderReceiveBarcode> purchaseOrderBarcode;
  List<PurchaseOrderReceiveBarcode> invoiceNoList = [];
  late Box<PurchaseOrderReceiveBarcode> purchaseOrderInvoiceNo;
  int barcodeIdInput = 0;
  var numFormat = NumberFormat("#,###.##", "en_US");
  double totalPurQty = 0;
  double totalInvQty = 0;
  double newInvQty = 0;
  final TextEditingController _inventoryQty = TextEditingController();
  bool canSave = false;
  bool canAdd = false;
  bool canInvoice = true;
  String partNo = "";
  String partDesc = "";
  double conversionFactor = 0;
  String purchUom = "";
  String invUom = "";
  double purchOrderQty = 0;
  double invOrderQty = 0;
  double heightScreen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = Hive.box('ApiSettings');
    purchaseOrderInvoiceNo = Hive.box('PurchaseOrderInvoiceNo');
    invoiceNoList = purchaseOrderInvoiceNo.values.toList();
    purchaseOrderBarcode = Hive.box('PurchaseOrderReceiveBarcode');
    barcodeList = purchaseOrderBarcode.values.toList();

    GlobalParam.dataListNBarcode = [];
    partNo = widget.data.partNo ?? "";
    partDesc = widget.data.partDesc ?? "";
    conversionFactor = widget.data.conversionFactor ?? 0;
    purchUom = widget.data.purchUom ?? "";
    invUom = widget.data.invUom ?? "";
    purchOrderQty = widget.data.purchOrderQty ?? 0;
    invOrderQty = widget.data.invOrderQty ?? 0;
    GlobalParam.dataListNBarcodePurQty = 0;
    GlobalParam.dataListNBarcodeInvQty = 0;
    // if (invoiceNoList.isNotEmpty) {
    //   for (int i = 0; i < invoiceNoList.length; i++) {
    //     if (invoiceNoList[i].purchaseOrderNo == widget.data.purchaseOrderNo) {
    //       if (invoiceNoList[i].lineNo == widget.data.lineNo) {
    //         if (invoiceNoList[i].relNo == widget.data.relNo) {
    //           if (invoiceNoList[i].supplierNo == widget.data.supplierNo) {
    //             DateTime day =
    //                 DateTime.parse("${invoiceNoList[0].actualArrivalDate}");
    //             _actualDate.text = DateFormat('dd-MMM-yy').format(day);
    //             _txtActualFormatDate = DateFormat('MM/dd/yyyy').format(day);
    //             actualArrivalDate = DateFormat('yyyy-MM-dd').format(day);
    //             _txtInvoiceNo = '${invoiceNoList[0].invoiceNo}';

    //             if (_txtActualFormatDate.isEmpty) {
    //               _txtActualDate =
    //                   DateFormat('MM/dd/yyyy').format(DateTime.now());
    //             } else {
    //               _txtActualDate = _txtActualFormatDate;
    //             }
    //             canSave = true;
    //             canAdd = true;
    //           }
    //         }
    //       }
    //     }
    //   }

    //   if (barcodeList.isNotEmpty) {
    //     for (int i = 0; i < barcodeList.length; i++) {
    //       if (barcodeList[i].purchaseOrderNo == widget.data.purchaseOrderNo) {
    //         if (barcodeList[i].lineNo == widget.data.lineNo) {
    //           if (barcodeList[i].relNo == widget.data.relNo) {
    //             if (barcodeList[i].supplierNo == widget.data.supplierNo) {
    //               var data = PurchaseOrderReceiveResp(
    //                 barcodeId: barcodeList[i].barcodeId,
    //                 purchaseOrderNo: widget.data.purchaseOrderNo,
    //                 lineNo: widget.data.lineNo,
    //                 relNo: widget.data.relNo,
    //                 supplierNo: widget.data.supplierNo,
    //                 supplierName: widget.data.supplierName,
    //                 shopOrderNo: widget.data.shopOrderNo,
    //                 partNo: widget.data.partNo,
    //                 partDesc: widget.data.partDesc,
    //                 lotNo: barcodeList[i].lotNo,
    //                 wdrNo: barcodeList[i].wdrNo,
    //                 purchOrderQty: widget.data.purchOrderQty,
    //                 purchReceivedQty: barcodeList[i].purchReceivedQty,
    //                 purchUom: barcodeList[i].purchUom,
    //                 invOrderQty: widget.data.invOrderQty,
    //                 invReceivedQty: barcodeList[i].invReceivedQty,
    //                 invUom: barcodeList[i].invUom,
    //                 conversionFactor: widget.data.conversionFactor,
    //                 invoiceNo: invoiceNoList[0].invoiceNo,
    //                 actualArrivalDate: invoiceNoList[0].actualArrivalDate,
    //                 errorMessage: widget.data.errorMessage,
    //               );
    //               GlobalParam.dataListNBarcode.add(data);

    //               totalReset();
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('PO No.: ' + widget.poNo),
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
      body: _lstBarcode(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height / 3.3,
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
            canAdd == false
                ? SpeedDialChild(
                    child: const Icon(
                      Icons.playlist_add,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                    backgroundColor: Colors.grey.shade400,
                  )
                : SpeedDialChild(
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
            canInvoice == true
                ? _txtInvoiceNo.isEmpty
                    ? SpeedDialChild(
                        child: const Icon(
                          Icons.border_color_outlined,
                          color: Colors.black54,
                          size: 30.0,
                        ),
                        backgroundColor: Colors.white,
                        onTap: () async {
                          _addInvoiceNoDialog();
                        },
                        onLongPress: () async {
                          _addInvoiceNoDialog();
                        },
                      )
                    : SpeedDialChild(
                        child: const Icon(
                          LineAwesomeIcons.alternate_trash,
                          color: Colors.black54,
                          size: 30.0,
                        ),
                        backgroundColor: Colors.white,
                        onTap: () async {
                          // barcodeList = purchaseOrderBarcode.values.toList();
                          // for (int i = 0; i < barcodeList.length; i++) {
                          //   if (barcodeList[i].purchaseOrderNo ==
                          //       widget.data.purchaseOrderNo) {
                          //     if (barcodeList[i].lineNo == widget.data.lineNo) {
                          //       if (barcodeList[i].relNo == widget.data.relNo) {
                          //         if (barcodeList[i].supplierNo ==
                          //             widget.data.supplierNo) {
                          //           purchaseOrderBarcode.delete(barcodeList[i].key);
                          //         }
                          //       }
                          //     }
                          //   }
                          // }
                          // invoiceNoList = purchaseOrderInvoiceNo.values.toList();
                          // for (int i = 0; i < invoiceNoList.length; i++) {
                          //   if (invoiceNoList[i].purchaseOrderNo ==
                          //       widget.data.purchaseOrderNo) {
                          //     if (invoiceNoList[i].lineNo == widget.data.lineNo) {
                          //       if (invoiceNoList[i].relNo == widget.data.relNo) {
                          //         if (invoiceNoList[i].supplierNo ==
                          //             widget.data.supplierNo) {
                          //           purchaseOrderInvoiceNo
                          //               .delete(invoiceNoList[i].key);
                          //         }
                          //       }
                          //     }
                          //   }
                          // }
                          setState(() {
                            _invoiceNo.clear();
                            _actualDate.text =
                                DateFormat('dd-MMM-yy').format(DateTime.now());
                            _txtInvoiceNo = '';
                            _txtActualDate = '';
                            _txtActualFormatDate = '';
                            canSave = false;
                            canAdd = false;
                            GlobalParam.dataListNBarcode = [];
                            totalReset();
                          });
                        },
                        onLongPress: () async {
                          _invoiceNo.clear();
                        },
                      )
                : SpeedDialChild(
                    child: const Icon(
                      Icons.border_color_outlined,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                    backgroundColor: Colors.grey.shade400,
                    // onTap: () async {
                    //   _addInvoiceNoDialog();
                    // },
                    // onLongPress: () async {
                    //   _addInvoiceNoDialog();
                    // },
                  ),
            canSave == false
                ? SpeedDialChild(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(
                        Icons.save,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade400,
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
                    backgroundColor: Colors.white,
                    onTap: () async {
                      Tdialog.infoDialog(
                        context,
                        'Confirm reported Qty',
                        'Are you sure to confirm reported Qty',
                        acceptButton(),
                        cancelButton(),
                      );
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
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.black38,
          )),
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 75.0,
                      padding: const EdgeInsets.all(0),
                      child: const AutoSizeText(
                        'Invoice No.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxFontSize: 16.0,
                        minFontSize: 14.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 28.0,
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        color: HexColor("#0070c0"),
                        child: AutoSizeText(
                          _txtInvoiceNo,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          maxLines: 1,
                          //maxFontSize: 18.0,
                          minFontSize: 10.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: const AutoSizeText(
                        'Actual Arr. Date.',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxFontSize: 16.0,
                        minFontSize: 14.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 30.0,
                        width: double.infinity,
                        color: HexColor("#0070c0"),
                        padding: const EdgeInsets.all(5),
                        child: AutoSizeText(
                          _txtActualDate,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          minFontSize: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                    Container(
                      width: 80.0,
                      padding: const EdgeInsets.all(0),
                      child: AutoSizeText(
                        // ignore: unnecessary_string_interpolations
                        partNo,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#0070c0"),
                        ),
                        maxFontSize: 20.0,
                        minFontSize: 10.0,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                        ),
                        child: AutoSizeText(
                          // ignore: unnecessary_string_interpolations
                          partDesc,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#c3ccd8"),
                          ),
                          maxLines: 1,
                          maxFontSize: 20.0,
                          minFontSize: 10.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  height: 28.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            'Conv. : ${numFormat.format(conversionFactor)}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#a10515"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: AutoSizeText(
                                  'Pur Uom :',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: HexColor("#c3ccd8"),
                                  ),
                                  maxFontSize: 20.0,
                                  minFontSize: 16.0,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  child: AutoSizeText(
                                    // ignore: unnecessary_string_interpolations
                                    purchUom,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: HexColor("#0070c0"),
                                    ),
                                    maxFontSize: 20.0,
                                    minFontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        width: 20,
                        color: HexColor("#0070c0"),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 3.0),
                                child: AutoSizeText(
                                  'Inv uom :',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: HexColor("#c3ccd8"),
                                  ),
                                  maxFontSize: 20.0,
                                  minFontSize: 16.0,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(0),
                                  child: AutoSizeText(
                                    // ignore: unnecessary_string_interpolations
                                    invUom,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                    maxFontSize: 20.0,
                                    minFontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //------------------
              IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  height: 28.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            'Order',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: HexColor("#0070c0"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            numFormat.format(purchOrderQty),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#0070c0"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        width: 20,
                        color: HexColor("#0070c0"),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            numFormat.format(invOrderQty),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#0070c0"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //--------------------------
              IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  height: 28.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            'Receiving',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: HexColor("#7fa968"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            numFormat
                                .format(GlobalParam.dataListNBarcodePurQty),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#7fa968"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        width: 20,
                        color: HexColor("#0070c0"),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            numFormat
                                .format(GlobalParam.dataListNBarcodeInvQty),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#7fa968"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //------------------
              IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  height: 28.0,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            'Remain',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: HexColor("#a10515"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            numFormat.format(purchOrderQty -
                                GlobalParam.dataListNBarcodePurQty),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#a10515"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        width: 20,
                        color: HexColor("#0070c0"),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                          ),
                          child: AutoSizeText(
                            numFormat.format(invOrderQty -
                                GlobalParam.dataListNBarcodeInvQty),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: HexColor("#a10515"),
                            ),
                            maxFontSize: 20.0,
                            minFontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _addInvoiceNoDialog() {
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
                          'Invoice No.',
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
                          controller: _invoiceNo,
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
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const Text(
                          'Actual Arrival Date',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10.0, top: 10.0),
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
                          readOnly: true,
                          controller: _actualDate,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: 10, top: 2, right: 2, bottom: 10),
                            suffixIcon: IconButton(
                              alignment: Alignment.centerRight,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  ).then((pickedDate) {
                                    if (pickedDate == null) {
                                      return;
                                    }
                                    setState(() {
                                      print("############");
                                      _actualDate.text = DateFormat('dd-MMM-yy')
                                          .format(pickedDate);
                                      _txtActualFormatDate =
                                          DateFormat('MM/dd/yyyy')
                                              .format(pickedDate);
                                      actualArrivalDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  });
                                });
                              },
                            ),
                          ),
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
                    _invoiceNo.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _txtInvoiceNo = _invoiceNo.text;

                      if (_txtActualFormatDate.isEmpty) {
                        _txtActualDate =
                            DateFormat('MM/dd/yyyy').format(DateTime.now());
                        actualArrivalDate =
                            DateFormat('yyyy-MM-dd').format(DateTime.now());
                      } else {
                        _txtActualDate = _txtActualFormatDate;
                      }
                      canSave = true;
                      canAdd = true;
                      // for (int i = 0; i < invoiceNoList.length; i++) {
                      //   if (invoiceNoList[i].purchaseOrderNo ==
                      //       widget.data.purchaseOrderNo) {
                      //     if (invoiceNoList[i].lineNo == widget.data.lineNo) {
                      //       if (invoiceNoList[i].relNo == widget.data.relNo) {
                      //         if (invoiceNoList[i].supplierNo ==
                      //             widget.data.supplierNo) {
                      //           purchaseOrderInvoiceNo
                      //               .delete(invoiceNoList[i].key);
                      //         }
                      //       }
                      //     }
                      //   }
                      // }
                      // invoiceNoList = purchaseOrderInvoiceNo.values.toList();

                      // List<String> invoiceNoCheck = [];
                      // for (int i = 0; i < invoiceNoList.length; i++) {
                      //   invoiceNoCheck.add('${invoiceNoList[i].id}');
                      // }
                      // var data = PurchaseOrderReceiveBarcode(
                      //     id: generateId(invoiceNoCheck),
                      //     purchaseOrderNo: widget.data.purchaseOrderNo,
                      //     lineNo: widget.data.lineNo,
                      //     relNo: widget.data.relNo,
                      //     supplierNo: widget.data.supplierNo,
                      //     supplierName: widget.data.supplierName,
                      //     shopOrderNo: widget.data.shopOrderNo,
                      //     partNo: widget.data.partNo,
                      //     partDesc: widget.data.partDesc,
                      //     purchOrderQty: widget.data.purchOrderQty,
                      //     invOrderQty: widget.data.invOrderQty,
                      //     conversionFactor: widget.data.conversionFactor,
                      //     invoiceNo: _txtInvoiceNo,
                      //     actualArrivalDate: DateTime.parse(actualArrivalDate)
                      //         .toIso8601String());
                      // purchaseOrderInvoiceNo.put(data.id, data);

                      Navigator.pop(context, 'Save');
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
                    controller: _barcodeId,
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
                        if (value != '') {
                          var text = value;
                          var textList = text.split("|");

                          barcodeIdInput = int.parse(textList[0]);
                          _barcodeId.text = textList[0];
                          _barcodeId.selection = TextSelection.fromPosition(
                              TextPosition(offset: _barcodeId.text.length));
                        }
                      });
                    },
                    onFieldSubmitted: (value) {
                      var check = false;
                      for (var i = 0;
                          i < GlobalParam.dataListNBarcode.length;
                          i++) {
                        if (barcodeIdInput ==
                            GlobalParam.dataListNBarcode[i].barcodeId) {
                          check = true;
                        }
                      }
                      if (check == false) {
                        getDataByBarcodeId(barcodeIdInput);
                      } else {
                        Tdialog.errorDialog(context, "Error",
                            "Barcode Id is repeat.", okButton());
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
                    _invoiceNo.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Save');
                    var check = false;
                    for (var i = 0;
                        i < GlobalParam.dataListNBarcode.length;
                        i++) {
                      if (barcodeIdInput ==
                          GlobalParam.dataListNBarcode[i].barcodeId) {
                        check = true;
                      }
                    }
                    if (check == false) {
                      getDataByBarcodeId(barcodeIdInput);
                    } else {
                      Tdialog.errorDialog(context, "Error",
                          "Barcode Id is repeat.", okButton());
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

  Widget acceptButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        // print("@@@@@@@@@@@@@@");
        Navigator.pop(context, 'ACCEPT');
        if (GlobalParam.dataListNBarcode.isNotEmpty) {
          if (_txtInvoiceNo == '' || actualArrivalDate == '') {
            Tdialog.errorDialog(context, "Error",
                "Invoice No or Actual Arr Date is entity.", okButton());
          } else {
            poReceived();
          }
        } else {
          Tdialog.errorDialog(
              context, "Error", "Barcode is entity.", okButton());
        }

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

  Widget cancelButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        print("###########");
        Navigator.pop(context, 'CANCEL');
        // Tdialog.errorDialog(
        //   context,
        //   'Error',
        //   'error 123456789',
        //   okButton(),
        // );
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
        _save();
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  _save() {
    var a = 'Save Data....';
    print(a);
    return a;
  }

  Widget _lstBarcode() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: GlobalParam.dataListNBarcode.length,
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
                          deleteData(GlobalParam.dataListNBarcode[index]);
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
                          _inventoryQtyDialog(
                              GlobalParam.dataListNBarcode[index]);
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
                                child: _barcodeID(
                                    '${GlobalParam.dataListNBarcode[index].barcodeId}'),
                              ),
                              Container(
                                width: 60.0,
                                padding: const EdgeInsets.only(),
                                child: _seqID(numFormat.format(GlobalParam
                                    .dataListNBarcode[index].sequenceId)),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _lotNo(
                                      '${GlobalParam.dataListNBarcode[index].lotNo}'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(),
                                child: _supNo('${widget.data.supplierNo}'),
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
                                  child: _pQty(
                                      numFormat.format(GlobalParam
                                          .dataListNBarcode[index]
                                          .purchReceivedQty),
                                      '${GlobalParam.dataListNBarcode[index].purchUom}'),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _iQty(
                                      numFormat.format(GlobalParam
                                          .dataListNBarcode[index]
                                          .invReceivedQty),
                                      '${GlobalParam.dataListNBarcode[index].invUom}'),
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

  Widget _barcodeID(String txtbarcodeID) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Barcode ID',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtbarcodeID,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _seqID(String txtseqID) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Seq ID',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtseqID,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lotNo(String txtlotNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Lot No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtlotNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#68548c"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _supNo(String txtsupNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Sup. No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtsupNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#68548c"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pQty(String txtpQty, String uom) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  'Pur Qty',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#c3ccd8"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  '',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#c3ccd8"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3.0,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  txtpQty,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#657da5"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  uom,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#657da5"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iQty(String txtiQty, String uom) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  'Inv Qty',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#c3ccd8"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  '',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#c3ccd8"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 3.0,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  txtiQty,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#d88f5a"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                padding: const EdgeInsets.all(0),
                child: AutoSizeText(
                  uom,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: HexColor("#d88f5a"),
                    fontWeight: FontWeight.bold,
                  ),
                  maxFontSize: 12.0,
                  minFontSize: 10.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String> initialData() async {
    return "";
  }

  deleteData(PurchaseOrderReceiveResp data) {
    Tdialog.infoDialog(
      context,
      'Confirm delete?',
      'Are you sure to delete the selected Barcode id?',
      acceptDelete(data),
      cancelButton(),
    );
  }

  _inventoryQtyDialog(PurchaseOrderReceiveResp data) {
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
                    'New Inventory Quantity',
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
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _inventoryQty,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        if (value != '') {
                          String num = value.replaceAll(',', '');
                          newInvQty = double.parse(num);
                        }
                      });
                    },
                    onFieldSubmitted: (value) {
                      if (newInvQty > 0) {
                        for (var i = 0;
                            i < GlobalParam.dataListNBarcode.length;
                            i++) {
                          if (GlobalParam.dataListNBarcode[i].barcodeId ==
                              data.barcodeId) {
                            GlobalParam.dataListNBarcode[i].invReceivedQty =
                                newInvQty;
                            if (widget.data.conversionFactor != 0) {
                              GlobalParam.dataListNBarcode[i].purchReceivedQty =
                                  newInvQty / widget.data.conversionFactor!;
                            } else {
                              GlobalParam.dataListNBarcode[i].purchReceivedQty =
                                  0;
                            }

                            // GlobalParam.dataListNBarcodeInvQty = newInvQty;
                          }
                        }
                        // barcodeList = purchaseOrderBarcode.values.toList();
                        // for (int i = 0; i < barcodeList.length; i++) {
                        //   if (barcodeList[i].purchaseOrderNo ==
                        //       widget.data.purchaseOrderNo) {
                        //     if (barcodeList[i].lineNo == widget.data.lineNo) {
                        //       if (barcodeList[i].relNo == widget.data.relNo) {
                        //         if (barcodeList[i].supplierNo ==
                        //             widget.data.supplierNo) {
                        //           if (barcodeList[i].barcodeId ==
                        //               data.barcodeId) {
                        //             purchaseOrderBarcode
                        //                 .delete(barcodeList[i].key);
                        //             barcodeList[i].invReceivedQty = newInvQty;
                        //             purchaseOrderBarcode.put(
                        //                 barcodeList[i].id, barcodeList[i]);
                        //           }
                        //         }
                        //       }
                        //     }
                        //   }
                        // }
                        resetTotal();
                      } else {
                        Tdialog.errorDialog(
                            context,
                            'Error',
                            'Inventory Quantity need more than zero.',
                            okButton());
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
                    _inventoryQty.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Save');
                    if (newInvQty > 0) {
                      for (var i = 0;
                          i < GlobalParam.dataListNBarcode.length;
                          i++) {
                        if (GlobalParam.dataListNBarcode[i].barcodeId ==
                            data.barcodeId) {
                          GlobalParam.dataListNBarcode[i].invReceivedQty =
                              newInvQty;
                          if (widget.data.conversionFactor != 0) {
                            GlobalParam.dataListNBarcode[i].purchReceivedQty =
                                newInvQty / widget.data.conversionFactor!;
                          } else {
                            GlobalParam.dataListNBarcode[i].purchReceivedQty =
                                0;
                          }
                          // GlobalParam.dataListNBarcodeInvQty = newInvQty;
                        }
                      }

                      // barcodeList = purchaseOrderBarcode.values.toList();
                      // for (int i = 0; i < barcodeList.length; i++) {
                      //   if (barcodeList[i].purchaseOrderNo ==
                      //       widget.data.purchaseOrderNo) {
                      //     if (barcodeList[i].lineNo == widget.data.lineNo) {
                      //       if (barcodeList[i].relNo == widget.data.relNo) {
                      //         if (barcodeList[i].supplierNo ==
                      //             widget.data.supplierNo) {
                      //           if (barcodeList[i].barcodeId ==
                      //               data.barcodeId) {
                      //             purchaseOrderBarcode
                      //                 .delete(barcodeList[i].key);
                      //             barcodeList[i].invReceivedQty = newInvQty;
                      //             purchaseOrderBarcode.put(
                      //                 barcodeList[i].id, barcodeList[i]);
                      //           }
                      //         }
                      //       }
                      //     }
                      //   }
                      // }
                      resetTotal();
                    } else {
                      Tdialog.errorDialog(
                          context,
                          'Error',
                          'Inventory Quantity need more than zero.',
                          okButton());
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

  Widget acceptDelete(PurchaseOrderReceiveResp data) {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
        // barcodeList = purchaseOrderBarcode.values.toList();
        // for (int i = 0; i < barcodeList.length; i++) {
        //   if (barcodeList[i].purchaseOrderNo == widget.data.purchaseOrderNo) {
        //     if (barcodeList[i].lineNo == widget.data.lineNo) {
        //       if (barcodeList[i].relNo == widget.data.relNo) {
        //         if (barcodeList[i].supplierNo == widget.data.supplierNo) {
        //           if (barcodeList[i].barcodeId == data.barcodeId) {
        //             purchaseOrderBarcode.delete(barcodeList[i].key);
        //             barcodeList[i].invReceivedQty = newInvQty;
        //           }
        //         }
        //       }
        //     }
        //   }
        // }
        setState(() {
          double purQty = 0;
          double invQty = 0;
          for (var i = 0; i < GlobalParam.dataListNBarcode.length; i++) {
            if (GlobalParam.dataListNBarcode[i].barcodeId == data.barcodeId) {
              GlobalParam.dataListNBarcode.removeAt(i);
            }
          }
          for (var i = 0; i < GlobalParam.dataListNBarcode.length; i++) {
            purQty += GlobalParam.dataListNBarcode[i].purchReceivedQty!;
            invQty += GlobalParam.dataListNBarcode[i].invReceivedQty!;
          }
          GlobalParam.dataListNBarcodePurQty = purQty;
          GlobalParam.dataListNBarcodeInvQty = invQty;
        });
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  totalReset() {
    double purQty = 0;
    double invQty = 0;
    for (var i = 0; i < GlobalParam.dataListNBarcode.length; i++) {
      purQty += GlobalParam.dataListNBarcode[i].purchReceivedQty!;
      invQty += GlobalParam.dataListNBarcode[i].invReceivedQty!;
    }
    totalPurQty = purQty;
    totalInvQty = invQty;
    GlobalParam.dataListNBarcodePurQty = purQty;
    GlobalParam.dataListNBarcodeInvQty = invQty;
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

      var result = await proxy.nGetDataByBarcodeId(PurchaseOrderReceiveReq(
          purchaseOrderNo: widget.data.purchaseOrderNo,
          lineNo: widget.data.lineNo,
          relNo: widget.data.relNo,
          // purchaseOrderNo: "P21000094",
          // lineNo: "1",
          // relNo: "1",
          barcodeId: barcodeId,
          purchReceivedQty: 0,
          purchOrderQty: 0,
          invOrderQty: 0,
          invReceivedQty: 0,
          conversionFactor: 0));
      if (result.errorMessage == null) {
        result.supplierNo = widget.data.supplierNo;
        result.supplierName = widget.data.supplierName;
        GlobalParam.dataListNBarcode.add(result);
        // barcodeList = purchaseOrderBarcode.values.toList();
        // invoiceNoList = purchaseOrderInvoiceNo.values.toList();
        // List<String> barcodeCheck = [];
        // for (int i = 0; i < barcodeList.length; i++) {
        //   barcodeCheck.add('${barcodeList[i].id}');
        // }
        // var data = PurchaseOrderReceiveBarcode(
        //   id: generateId(barcodeCheck),
        //   barcodeId: result.barcodeId,
        //   purchaseOrderNo: widget.data.purchaseOrderNo,
        //   lineNo: widget.data.lineNo,
        //   relNo: widget.data.relNo,
        //   supplierNo: widget.data.supplierNo,
        //   supplierName: widget.data.supplierName,
        //   shopOrderNo: widget.data.shopOrderNo,
        //   partNo: widget.data.partNo,
        //   partDesc: widget.data.partDesc,
        //   lotNo: result.lotNo,
        //   wdrNo: result.wdrNo,
        //   purchOrderQty: widget.data.purchOrderQty,
        //   purchReceivedQty: result.purchReceivedQty,
        //   purchUom: result.purchUom,
        //   invOrderQty: widget.data.invOrderQty,
        //   invReceivedQty: result.invReceivedQty,
        //   invUom: result.invUom,
        //   conversionFactor: widget.data.conversionFactor,
        //   invoiceNo: _txtInvoiceNo,
        //   actualArrivalDate:
        //       DateTime.parse(actualArrivalDate).toIso8601String(),
        //   errorMessage: widget.data.errorMessage,
        // );
        // purchaseOrderBarcode.put(data.id, data);
        resetTotal();
        // double purQty = 0;
        // double invQty = 0;
        // for (var i = 0; i < GlobalParam.dataListNBarcode.length; i++) {
        //   purQty += GlobalParam.dataListNBarcode[i].purchReceivedQty!;
        //   invQty += GlobalParam.dataListNBarcode[i].invReceivedQty!;
        // }
        setState(() {
          _barcodeId.clear();
          // totalPurQty = purQty;
          // totalInvQty = invQty;
          // GlobalParam.dataListNBarcodePurQty = purQty;
          // GlobalParam.dataListNBarcodeInvQty = invQty;
          canSave = true;
          canAdd = true;
        });
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

  poReceived() async {
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
      List<PurchaseOrderReceiveReq> reqList = [];
      for (var i = 0; i < GlobalParam.dataListNBarcode.length; i++) {
        var data = PurchaseOrderReceiveReq(
            barcodeId: GlobalParam.dataListNBarcode[i].barcodeId,
            purchaseOrderNo: widget.data.purchaseOrderNo,
            lineNo: widget.data.lineNo,
            relNo: widget.data.relNo,
            purchReceivedQty: GlobalParam.dataListNBarcode[i].purchReceivedQty,
            invReceivedQty: GlobalParam.dataListNBarcode[i].invReceivedQty,
            invoiceNo: _txtInvoiceNo,
            actualArrivalDate:
                DateTime.parse(actualArrivalDate).toIso8601String(),
            purchOrderQty: 0,
            invOrderQty: 0,
            conversionFactor: 0);

        reqList.add(data);
      }
      // getDataByPurchaseOrder("${widget.data.purchaseOrderNo}");
      var result = await proxy.poReceived(reqList);
      if (result.errorMessage == null) {
        // barcodeList = purchaseOrderBarcode.values.toList();
        // for (int i = 0; i < barcodeList.length; i++) {
        //   if (barcodeList[i].purchaseOrderNo == widget.data.purchaseOrderNo) {
        //     if (barcodeList[i].lineNo == widget.data.lineNo) {
        //       if (barcodeList[i].relNo == widget.data.relNo) {
        //         if (barcodeList[i].supplierNo == widget.data.supplierNo) {
        //           purchaseOrderBarcode.delete(barcodeList[i].key);
        //         }
        //       }
        //     }
        //   }
        // }
        // invoiceNoList = purchaseOrderInvoiceNo.values.toList();
        // for (int i = 0; i < invoiceNoList.length; i++) {
        //   if (invoiceNoList[i].purchaseOrderNo == widget.data.purchaseOrderNo) {
        //     if (invoiceNoList[i].lineNo == widget.data.lineNo) {
        //       if (invoiceNoList[i].relNo == widget.data.relNo) {
        //         if (invoiceNoList[i].supplierNo == widget.data.supplierNo) {
        //           purchaseOrderInvoiceNo.delete(invoiceNoList[i].key);
        //         }
        //       }
        //     }
        //   }
        // }
        setState(() {
          GlobalParam.dataListNBarcode = [];
          // canSave = false;
          // canAdd = false;
        });

        getDataByPurchaseOrder("${widget.data.purchaseOrderNo}");

        // Tdialog.successDialog(context, "Information",
        //     "Process is completed without error.", okButton());
        ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
            context, 'Process is completed without error.', heightScreen));
        print("CCCCCCCCCCC");
        Navigator.pop(context, 'OK');
        _save();
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

  getDataByPurchaseOrder(String purchaseOrderNo) async {
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

      var result = await proxy.nGetDataByPurchaseOrder(PurchaseOrderReceiveReq(
          purchaseOrderNo: purchaseOrderNo,
          barcodeId: 0,
          purchReceivedQty: 0,
          purchOrderQty: 0,
          invOrderQty: 0,
          invReceivedQty: 0,
          conversionFactor: 0));
      if (result.isNotEmpty) {
        setState(() {
          var check = true;
          double purRemain = 0;
          double invRemain = 0;
          for (var i = 0; i < result.length; i++) {
            if (result[i].purchaseOrderNo == widget.data.purchaseOrderNo) {
              if (result[i].lineNo == widget.data.lineNo) {
                if (result[i].relNo == widget.data.relNo) {
                  check == false;
                  purRemain = result[i].purchOrderQty ?? 0;
                  invRemain = result[i].invOrderQty ?? 0;
                }
              }
            }
          }
          if (check == true) {
            setState(() {
              GlobalParam.dataListNBarcodePurQty = 0;
              GlobalParam.dataListNBarcodeInvQty = 0;
              purchOrderQty = purRemain;
              invOrderQty = invRemain;
              _txtActualDate = "";
              actualArrivalDate = "";
              _txtInvoiceNo = "";
              canAdd = false;
              canSave = false;
              canInvoice = true;
              // totalReset();
            });
          } else {
            GlobalParam.dataListNBarcode = [];
            GlobalParam.dataListNBarcodePurQty = 0;
            GlobalParam.dataListNBarcodeInvQty = 0;
            partNo = "";
            partDesc = "";
            conversionFactor = 0;
            purchUom = "";
            invUom = "";
            purchOrderQty = 0;
            invOrderQty = 0;
            _txtActualDate = "";
            actualArrivalDate = "";
            _txtInvoiceNo = "";
            canAdd = false;
            canSave = false;
            canInvoice = false;
          }
        });
      } else {
        setState(() {
          GlobalParam.dataListNBarcode = [];
          GlobalParam.dataListNBarcodePurQty = 0;
          GlobalParam.dataListNBarcodeInvQty = 0;
          partNo = "";
          partDesc = "";
          conversionFactor = 0;
          purchUom = "";
          invUom = "";
          purchOrderQty = 0;
          invOrderQty = 0;
          _txtActualDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
          actualArrivalDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
          _txtInvoiceNo = "";
          canAdd = false;
          canSave = false;
          canInvoice = false;
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

  resetTotal() {
    double purQty = 0;
    double invQty = 0;
    for (var i = 0; i < GlobalParam.dataListNBarcode.length; i++) {
      purQty += GlobalParam.dataListNBarcode[i].purchReceivedQty!;
      invQty += GlobalParam.dataListNBarcode[i].invReceivedQty!;
    }
    setState(() {
      _inventoryQty.clear();
      totalPurQty = purQty;
      totalInvQty = invQty;
      if (widget.data.conversionFactor != 0) {
        GlobalParam.dataListNBarcodePurQty =
            invQty / widget.data.conversionFactor!;
      } else {
        GlobalParam.dataListNBarcodePurQty = 0;
      }
      // GlobalParam.dataListNBarcodePurQty = purQty;
      GlobalParam.dataListNBarcodeInvQty = invQty;
      // canSave = true;
      // canAdd = true;
    });
  }
}
