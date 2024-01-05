// xxxxxxxxxxxxxxxxxx
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';

import 'package:ogawa_nec/api/class/globalParam.dart';

class ListFromBarcodeID extends StatefulWidget {
  final Function func_remove;
  const ListFromBarcodeID({Key? key, required this.func_remove})
      : super(key: key);

  @override
  State<ListFromBarcodeID> createState() => _ListFromBarcodeIDState();
}

class _ListFromBarcodeIDState extends State<ListFromBarcodeID> {
  final TextEditingController _newQty = TextEditingController();
  late Future<String> _initialData;
  late String data2;
  final formatNum = NumberFormat("#,###.##", "en_US");

  @override
  Widget build(BuildContext context) {
    return _lstBarcode();
  }

  Widget _lstBarcode() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: ApiProxyParameter.dataListJCustBarcodeFrom.length,
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
                            acceptDButton(index),
                            cancelButton(),
                          );
                        },
                        backgroundColor: HexColor("#ff0000"),
                        foregroundColor: Colors.white,
                        icon: LineAwesomeIcons.trash,
                      ),
                    ],
                  ),
                  // The end action pane is the one at the right or the bottom side.
                  // endActionPane: ActionPane(
                  //   extentRatio: 0.15,
                  //   motion: const ScrollMotion(),
                  //   children: [
                  //     SlidableAction(
                  //       onPressed: (context) {
                  //         _newQtyDialog();
                  //       },
                  //       backgroundColor: HexColor("#0070c0"),
                  //       foregroundColor: Colors.white,
                  //       icon: Icons.edit,
                  //     ),
                  //   ],
                  // ),

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
                                    '${ApiProxyParameter.dataListJCustBarcodeFrom[index].barcodeId}'),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _lotNo(
                                      '${ApiProxyParameter.dataListJCustBarcodeFrom[index].lotNo}'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(),
                                child: _wdrNo(
                                    '${ApiProxyParameter.dataListJCustBarcodeFrom[index].wdrNo}'),
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
                              Container(
                                width: 100.0,
                                padding: const EdgeInsets.only(),
                                child: _partNo(
                                    '${ApiProxyParameter.dataListJCustBarcodeFrom[index].partNo}'),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _desc(
                                      '${ApiProxyParameter.dataListJCustBarcodeFrom[index].partDesc}'),
                                ),
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
                                  child: _qty(formatNum.format(ApiProxyParameter
                                      .dataListJCustBarcodeFrom[index]
                                      .movedQty)),
                                ),
                              ),
                              const SizedBox(
                                width: 50.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _fromLocation(
                                      '${ApiProxyParameter.dataListJCustBarcodeFrom[index].fromLocation}'),
                                  // child: _fromLocation(
                                  //     ApiProxyParameter.jBarcodeFrom),
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
              txtbarcodeID,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
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
              txtlotNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#7fa968"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wdrNo(String txtwdrNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'W/D/R No',
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
              txtwdrNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#68548c"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 10.0,
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
              'Part No.',
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
              txtpartNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _desc(String txtdesc) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Description',
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
            width: double.infinity,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtdesc,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 16.0,
              minFontSize: 10.0,
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
              'Qty to move',
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
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#d88f5a"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fromLocation(String txtfromLocation) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'From Location',
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
              txtfromLocation,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 18.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }


  void deleteData(int index) {}

  _newQtyDialog() {
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
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _newQty,
                    autofocus: true,
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
                    setState(() {
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

  Widget acceptDButton(int index) {
    return TextButton(
      onPressed: () {
        //go to function.....
        widget.func_remove(index);

        Navigator.pop(context, 'ACCEPT');
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
        _delete();
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  _delete() {
    var a = 'Delete Data....';
    print(a);
    return a;
  }
}
