import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';

class PathCard extends StatelessWidget {
  final String tranNo;
  final double line;
  final String lotNo;
  final String quantity;
  final String partNo;
  final String description;
  final String locationNo;
  final String locDesc;
  final int i;
  final Widget app;
  const PathCard(this.tranNo, this.line, this.lotNo, this.quantity, this.partNo,
      this.description, this.locationNo, this.locDesc, this.i, this.app,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var heightScreen = MediaQuery.of(context).size.height;
    var numFomat = NumberFormat("#,###.##", "en_US");
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
                          rowCord1(tranNo, line, lotNo, quantity, numFomat,
                              widthScreen),
                          rowCord2(partNo, description, widthScreen),
                          rowCord3(locationNo, locDesc, widthScreen),
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
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => app));
                        },
                      ),
                    )
                  ],
                )
              ],
            )));
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
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget actionSave() {
      return TextButton(
        onPressed: () async {
          await actionDelete(barcodeID.toString(), i);
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

    final TextEditingController newQuantity = TextEditingController();
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###.##", "en_US");
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        extentRatio: 0.15,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              newQuantity.text = qtyPerBarcode;
              boxNewData(context, addNewDataShow, barcodeID, qtyPerBarcode, i);
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
            onPressed: (context) async {
              Tdialog.infoDialog(
                context,
                'Confirm delete?',
                'Are you sure to delete the selected Barcode id?',
                actionSave(),
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
                        rowCord2(partNo, description, widthScreen),
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

Widget rowCord1(tranNo, line, lotNo, quantity, numFomat, widthScreen) {
  return Expanded(
    flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tran. No',
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                tranNo,
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
          width: widthScreen * 0.11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Line',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                numFomat.format(line),
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
          width: widthScreen * 0.4,
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
          // width: widthScreen * 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Quantity',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              Text(
                numFomat.format(double.parse(quantity)),
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
                'Part No',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
              AutoSizeText(
                partNo,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                maxFontSize: 16.0,
                minFontSize: 10.0,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.55,
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
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.visible,
                maxFontSize: 16.0,
                minFontSize: 10.0,
              ),
            ],
          ),
        ),
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
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Exp. List No',
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
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.centerLeft,
          width: widthScreen * 0.18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shop No',
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
                  color: Colors.green,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
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
          width: widthScreen * 0.4,
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
              AutoSizeText(
                quantity,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                maxFontSize: 16.0,
                minFontSize: 10.0,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
