// ignore_for_file: unrelated_type_equality_checks

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/screen/countPerCountReport/countPerCountReport.dart';
import 'package:ogawa_nec/screen/login/login.dart';

class PathCard extends StatefulWidget {
  final double cNo;
  final double sepNo;
  final String lotNo;
  final String wRDNo;
  final String partNo;
  final String description;
  final String locationNo;
  final String locDesc;
  final int i;
  final Widget app;
  const PathCard(this.cNo, this.sepNo, this.lotNo, this.wRDNo, this.partNo,
      this.description, this.locationNo, this.locDesc, this.i, this.app,
      {Key? key})
      : super(key: key);

  @override
  State<PathCard> createState() => _PathCardState();
}

class _PathCardState extends State<PathCard> {
  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Card(
      color: (widget.i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
      child: TextButton(
        onPressed: (() {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => widget.app));
        }),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 120,
                  // width: widthScreen * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      rowCord1(widget.cNo, widget.sepNo, widget.lotNo,
                          widget.wRDNo, numFomat, widthScreen),
                      rowCord2(widget.partNo, widget.description, widthScreen),
                      rowCord3(widget.locationNo, widget.locDesc, widthScreen),
                    ],
                  ),
                ),
                SizedBox(
                  height: 110,
                  width: widthScreen * 0.005,
                  // padding: EdgeInsets.only(right: 20),
                  child: IconButton(
                    color: Colors.black45,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 25.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => widget.app));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PathCardNewData extends StatefulWidget {
  final String barcodeID;
  final String lotNo;
  final String wRDNo;
  final String partNo;
  final String description;
  final String qtyPerBarcode;
  final int i;
  final Widget app;
  final Function boxNewData;
  final Function addNewDataShow;
  final Function actionDelete;
  final Function cancelButton;
  const PathCardNewData(
      this.barcodeID,
      this.lotNo,
      this.wRDNo,
      this.partNo,
      this.description,
      this.qtyPerBarcode,
      this.i,
      this.app,
      this.boxNewData,
      this.addNewDataShow,
      this.actionDelete,
      this.cancelButton,
      {Key? key})
      : super(key: key);

  @override
  State<PathCardNewData> createState() => _PathCardNewDataState();
}

class _PathCardNewDataState extends State<PathCardNewData> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController newQuantity = TextEditingController();
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return widget.barcodeID == '999999999'
        ? Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              extentRatio: 0.15,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Tdialog.infoDialog(
                      context,
                      'Confirm delete?',
                      'Are you sure to delete the selected Barcode id?',
                      widget.actionDelete(widget.barcodeID),
                      widget.cancelButton(),
                    );
                  },
                  backgroundColor: HexColor("#ff0000"),
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline,
                ),
              ],
            ),
            child: Card(
                color: (widget.i + 1) % 2 == 0
                    ? HexColor('DDE9F5')
                    : HexColor('ffffff'),
                child: TextButton(
                    onPressed: (() {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) => widget.app));
                    }),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 120,
                              // width: widthScreen * .9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  rowCord5(widget.barcodeID, widget.lotNo,
                                      widget.wRDNo, numFomat, widthScreen),
                                  rowCord2(widget.partNo, widget.description,
                                      widthScreen),
                                  rowCord4(widget.qtyPerBarcode, widthScreen),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ))),
          )
        : Slidable(
            key: const ValueKey(0),
            endActionPane: ActionPane(
              extentRatio: 0.15,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    newQuantity.text = widget.qtyPerBarcode;
                    widget.boxNewData(context, widget.addNewDataShow,
                        widget.barcodeID, widget.qtyPerBarcode);
                  },
                  backgroundColor: HexColor("#0070c0"),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                ),
              ],
            ),
            startActionPane: ActionPane(
              extentRatio: 0.15,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    Tdialog.infoDialog(
                      context,
                      'Confirm delete?',
                      'Are you sure to delete the selected Barcode id?',
                      widget.actionDelete(widget.barcodeID),
                      widget.cancelButton(),
                    );
                  },
                  backgroundColor: HexColor("#ff0000"),
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline,
                ),
              ],
            ),
            child: Card(
                color: (widget.i + 1) % 2 == 0
                    ? HexColor('DDE9F5')
                    : HexColor('ffffff'),
                child: TextButton(
                    onPressed: (() {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) => widget.app));
                    }),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 120,
                              // width: widthScreen * .9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  rowCord5(widget.barcodeID, widget.lotNo,
                                      widget.wRDNo, numFomat, widthScreen),
                                  rowCord2(widget.partNo, widget.description,
                                      widthScreen),
                                  rowCord4(widget.qtyPerBarcode, widthScreen),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ))),
          );
  }
}

_save(BuildContext context) {
  var a = 'Save Data....';
  print(a);
  Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          const CountPerCountReport(reset: false),
    ),
  );
  // Navigator.of(context,rootNavigator: true).pop();
  return a;
}

Widget rowCord1(cNo, sepNo, lotNo, wRDNo, numFomat, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'C. No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                numFomat.format(cNo),
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
                'Sep No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                numFomat.format(sepNo),
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
          width: widthScreen * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lot No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                lotNo,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.green,
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
          width: widthScreen * 0.26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'W/D/R No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                wRDNo,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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
          width: widthScreen * 0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Part No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
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
          // color: Colors.green,
          width: widthScreen * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
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

Widget rowCord3(locationNo, locDesc, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
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
          width: widthScreen * 0.41,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Desc',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                locDesc,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}

Widget rowCord4(qtyPerBarcode, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Qty Per Barcode',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                qtyPerBarcode,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}

Widget rowCord5(barcodeID, lotNo, wRDNo, numFomat, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Barcode ID',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                barcodeID,
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
          width: widthScreen * 0.42,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lot No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                lotNo,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.green,
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
                'W/D/R No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                wRDNo,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
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

class Sample {
  static save() {
    var aaa = "x";
    print("#############");
    return aaa;
  }
}
