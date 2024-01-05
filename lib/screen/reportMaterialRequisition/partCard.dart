import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';

class PathCard extends StatelessWidget {
  final String mrNo;
  final String dueDate;
  final String numberOfLine;
  final String internalCustomer;
  final String intCustName;
  final String intDes;
  final String intDestName;
  final int i;
  final Widget app;

  const PathCard(
      this.mrNo,
      this.dueDate,
      this.numberOfLine,
      this.internalCustomer,
      this.intCustName,
      this.intDes,
      this.intDestName,
      this.i,
      this.app,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Card(
      color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
      child: TextButton(
        onPressed: (() {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => app));
        }),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(0),
                  alignment: Alignment.centerLeft,
                  height: 110,
                  // width: widthScreen * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      rowCord1(
                          mrNo, dueDate, numberOfLine, numFomat, widthScreen),
                      rowCord2(internalCustomer, intCustName, widthScreen),
                      rowCord3(intDes,intDestName, widthScreen),
                    ],
                  ),
                ),
                SizedBox(
                  height: 110,
                  width: widthScreen * 0.01,
                  child: IconButton(
                    padding: const EdgeInsets.all(2),
                    color: Colors.black,
                    icon: const Icon(
                      LineAwesomeIcons.angle_right,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => app));
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

class PathCardNewData extends StatelessWidget {
  final String barcodeID;
  final String lotNo;
  final String quantity;
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
      this.quantity,
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
  Widget build(BuildContext context) {
    final TextEditingController newQuantity = TextEditingController();
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        extentRatio: 0.15,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              newQuantity.text = qtyPerBarcode;
              boxNewData(context, addNewDataShow, barcodeID, qtyPerBarcode);
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
                actionDelete(barcodeID),
                cancelButton(),
              );
            },
            backgroundColor: HexColor("#ff0000"),
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
          ),
        ],
      ),
      child: Card(
        color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
        child: TextButton(
          onPressed: (() {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => app));
          }),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 110,
                    // width: widthScreen * .9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        rowCord5(
                            barcodeID, lotNo, quantity, numFomat, widthScreen),
                        rowCord6(partNo, description, widthScreen),
                        rowCord4(qtyPerBarcode, widthScreen),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PathCardReseved extends StatelessWidget {
  final String line;
  final String rel;
  final String lotNo;
  final String reservedQty;
  final String partNo;
  final String description;
  final String location;
  final int i;
  final bool check;

  const PathCardReseved(this.line, this.rel, this.lotNo, this.reservedQty,
      this.partNo, this.description, this.location, this.i, this.check,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Card(
      color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                alignment: Alignment.centerLeft,
                height: 110,
                // width: widthScreen * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    rowCord7(line, rel, lotNo, reservedQty, numFomat,
                        widthScreen, check),
                    rowCord6(partNo, description, widthScreen),
                    rowCord9(location, widthScreen),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget rowCord1(mrNo, dueDate, numberOfLine, numFomat, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.27,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MR. No',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                mrNo,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.34,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Due Date',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                dueDate,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.blue,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          // width: widthScreen * 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Number of Line',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                numberOfLine,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.blue,
                  fontSize: 18,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Internal Customer',
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Int. Cust. Name',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                description,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey,
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

Widget rowCord3(locationNo,locationName, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Internal Destination',
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
                  color: Color.fromARGB(255, 100, 17, 130),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Int. Dest. Name',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                locationName,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Qty Reported',
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
                  fontSize: 18,
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

Widget rowCord5(barcodeID, lotNo, quantity, numFomat, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.25,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.45,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.15,
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
                quantity,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.green,
                  fontSize: 14,
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

Widget rowCord6(partNo, description, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.28,
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.57,
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
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: HexColor("#c3ccd8"),
                  fontWeight: FontWeight.bold,
                ),
                maxFontSize: 12.0,
                minFontSize: 10.0,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget rowCord7(
    line, rel, lotNo, reservedQty, numFomat, widthScreen, bool check) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Container(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.centerLeft,
        width: widthScreen * 0.13,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Line',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
            Text(
              line,
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
        padding: const EdgeInsets.all(0),
        alignment: Alignment.centerLeft,
        width: widthScreen * 0.13,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rel',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.left,
            ),
            Text(
              rel,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.red,
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
        padding: const EdgeInsets.all(0),
        alignment: Alignment.centerLeft,
        width: widthScreen * 0.28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lot No',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
            Text(
              lotNo,
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
      const SizedBox(width: 10),
      Container(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.centerRight,
        width: widthScreen * 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              check == true ? 'Reserved Qty' : 'Remaining Qty',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
            Text(
              reservedQty,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.blue,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget rowCord9(locationNo, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location',
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
                  color: Color.fromARGB(255, 100, 17, 130),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
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
