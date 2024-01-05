import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';

class ListToBarcodeID extends StatefulWidget {
  final Function func_remove;
  const ListToBarcodeID({Key? key, required this.func_remove})
      : super(key: key);

  @override
  State<ListToBarcodeID> createState() => _ListToBarcodeIDState();
}

class _ListToBarcodeIDState extends State<ListToBarcodeID> {
  late Future<String> _initialData;
  late String data;
  final formatNum = NumberFormat("#,###.##", "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialData = initialData();
  }

  @override
  Widget build(BuildContext context) {
    return _lstBarcode();
  }

  Widget _lstBarcode() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: ApiProxyParameter.dataListJCustBarcodeTo.length,
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
                            acceptButton(index),
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
                                    '${ApiProxyParameter.dataListJCustBarcodeTo[index].barcodeId}'),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _lotNo(
                                      '${ApiProxyParameter.dataListJCustBarcodeTo[index].lotNo}'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(),
                                child: _wdrNo(
                                    '${ApiProxyParameter.dataListJCustBarcodeTo[index].wdrNo}'),
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
                                    '${ApiProxyParameter.dataListJCustBarcodeTo[index].partNo}'),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _desc(
                                      '${ApiProxyParameter.dataListJCustBarcodeTo[index].partDesc}'),
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
                              Container(
                                width: 100.0,
                                padding: const EdgeInsets.only(),
                                child: _qty(formatNum.format(ApiProxyParameter
                                    .dataListJCustBarcodeTo[index].movedQty)),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  // child: _fromLocation(ApiProxyParameter
                                  //     .jBarcodeFrom
                                  //     .toString()),
                                  child: _fromLocation(
                                      '${ApiProxyParameter.dataListJCustBarcodeTo[index].fromLocation}'),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.only(),
                                  child: _toLocation(
                                      '${ApiProxyParameter.dataListJCustBarcodeTo[index].toLocation}'),
                                  // child: _toLocation(
                                  //     ApiProxyParameter.jBarcodeTo.toString()),
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
              maxFontSize: 18.0,
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
              minFontSize: 18.0,
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
              maxLines: 1,
              maxFontSize: 18.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toLocation(String txttoLocation) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'To Location',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txttoLocation,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              maxFontSize: 18.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> initialData() async {
    return "";
  }

  void deleteData(int index) {}

  Widget acceptButton(int index) {
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
