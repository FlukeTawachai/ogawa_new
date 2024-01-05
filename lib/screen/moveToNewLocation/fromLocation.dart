import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/api/response/moveToNewLocationResp.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/moveToNewLocation/listFromBarcodeID.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';

import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/api/request/moveToNewLocationRep.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

class FromLocation extends StatefulWidget {
  const FromLocation({Key? key}) : super(key: key);

  @override
  State<FromLocation> createState() => _FromLocationState();
}

class _FromLocationState extends State<FromLocation> {
  final TextEditingController _location = TextEditingController();
  // String _txtLocation = '';
  final TextEditingController _barcode = TextEditingController();
  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  String _txtBarcode = '';

  List<MoveToNewLocationRep> boxnowDataRort = [];
  late Box<MoveToNewLocationRep> zboxnowDataRort;

  List<LocationJFromAndTo> locationJFromAndTo = [];
  late Box<LocationJFromAndTo> zlocationJFromAndTo;

  // List<moveToNewLocationResp> ApiProxyParameter.dataListJCustBarcodeTo = [];
  List<moveToNewLocationResp> fnowDataRort = [];
  final formatNum = NumberFormat("#,###.##", "en_US");
  final TextEditingController _newQty = TextEditingController();

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();

    zboxnowDataRort = Hive.box('MoveToNewLocationRep');
    boxnowDataRort = zboxnowDataRort.values.toList();

    zlocationJFromAndTo = Hive.box('LocationJFromAndTo');
    locationJFromAndTo = zlocationJFromAndTo.values.toList();

    // makeData_();
    ApiProxyParameter.dataListJCustBarcodeFrom.clear();
    ApiProxyParameter.dataListJCustBarcodeTo.clear();
    if (boxnowDataRort.isNotEmpty) {
      ApiProxyParameter.countBarcodeToFrom = boxnowDataRort.length;
      formatDataDBtoCast();
    }

    // for (var i = 0; i < boxnowDataRort.length; i++) {
    //   zboxnowDataRort.delete(boxnowDataRort[i].key);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(0),
          child: _lstBarcode(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        height: MediaQuery.of(context).size.height / 9,
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
            SpeedDialChild(
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
            ApiProxyParameter.jBarcodeFrom.isEmpty
                ? SpeedDialChild(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      child: const Icon(
                        Icons.unarchive_rounded,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    onTap: () async {
                      _addFromLocationDialog();
                    },
                    onLongPress: () async {
                      _addFromLocationDialog();
                    },
                  )
                : ApiProxyParameter.dataListJCustBarcodeFrom.isEmpty
                    ? SpeedDialChild(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            LineAwesomeIcons.alternate_trash,
                            color: Colors.black54,
                            size: 30.0,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        onTap: () async {
                          setState(() {
                            ApiProxyParameter.jBarcodeFrom = '';
                            zlocationJFromAndTo.delete('0');
                            _location.clear();
                          });
                        },
                        onLongPress: () async {
                          setState(() {
                            ApiProxyParameter.jBarcodeFrom = '';
                            zlocationJFromAndTo.delete('0');
                            _location.clear();
                          });
                        },
                      )
                    : SpeedDialChild(
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            LineAwesomeIcons.alternate_trash,
                            color: Colors.black54,
                            size: 30.0,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade300,
                        onTap: () async {
                          // setState(() {
                          //   ApiProxyParameter.jBarcodeFrom = '';
                          //   zlocationJFromAndTo.delete('0');
                          //   _location.clear();
                          // });
                        },
                        onLongPress: () async {
                          // setState(() {
                          //   ApiProxyParameter.jBarcodeFrom = '';
                          //   zlocationJFromAndTo.delete('0');
                          //   _location.clear();
                          // });
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
                height: 40.0,
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
                        //width: 80.0,
                        padding: const EdgeInsets.all(0),
                        child: AutoSizeText(
                          'From: ${ApiProxyParameter.jBarcodeFrom}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: HexColor("#0070c0"),
                          ),
                          maxLines: 1,
                          minFontSize: 14.0,
                        ),
                      ),
                    ),
                    Container(
                      //width: double.infinity,
                      width: 120.0,
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: 5.0,
                      ),
                      child: AutoSizeText(
                        'No. of Barcode',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#a10515"),
                        ),
                        maxLines: 1,
                        minFontSize: 14.0,
                      ),
                    ),
                    Container(
                      width: 80.0,
                      padding: const EdgeInsets.all(0),
                      child: AutoSizeText(
                        ApiProxyParameter.dataListJCustBarcodeFrom.length
                            .toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#a10515"),
                        ),
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

  _addFromLocationDialog() {
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
                          'From Location',
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
                          controller: _location,
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
                          onFieldSubmitted: (value) async {
                            Navigator.pop(context, 'Save');
                            await checkFromLocation();
                            setState(() {
                              ApiProxyParameter.jBarcodeFrom;
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
                    Navigator.pop(context, 'Cancel');
                    _location.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Save');
                    await checkFromLocation();
                    setState(() {
                      ApiProxyParameter.jBarcodeFrom;
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
                          'Barcode ID',
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
                          keyboardType: TextInputType.number,
                          controller: _barcode,
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

                              _barcode.text = textList[0];
                              _barcode.selection = TextSelection.fromPosition(
                                  TextPosition(offset: _barcode.text.length));
                            });
                          },
                          onFieldSubmitted: (value) async {
                            Navigator.pop(context, 'Save');

                            checkDataFromInsert();
                            _barcode.clear();
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
                    Navigator.pop(context, 'Cancel');
                    _barcode.clear();
                  },
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Save');
                    checkDataFromInsert();
                    _barcode.clear();
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
                            acceptDeleteButton(ApiProxyParameter
                                .dataListJCustBarcodeFrom[index]),
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

  Future<String> initialData() async {
    return "";
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

  Widget acceptDeleteButton(moveToNewLocationResp data) {
    return TextButton(
      onPressed: () {
        //go to function.....
        funcRemoveData(data);

        // Navigator.pop(context, 'ACCEPT');
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
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

  formatDataDBtoCast() async {
    for (int b = 0; b < locationJFromAndTo.length; b++) {
      if ((locationJFromAndTo[b].userLogin == ApiProxyParameter.userLogin) &&
          (locationJFromAndTo[b].classBox == 'F')) {
        ApiProxyParameter.jBarcodeFrom =
            locationJFromAndTo[b].locationFrom ?? '';
        break;
      }
    }
    for (int a = 0; a < boxnowDataRort.length; a++) {
      if ((boxnowDataRort[a].userLogin == ApiProxyParameter.userLogin) ==
          (boxnowDataRort[a].classBox == 'F')) {
        // if (true) {
        ApiProxyParameter.dataListJCustBarcodeFrom
            .add(moveToNewLocationResp.fromJson({
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "FromLocation": boxnowDataRort[a].fromLocation,
          "ToLocation": boxnowDataRort[a].toLocation,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "MovedQty": boxnowDataRort[a].movedQty,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
          "UserLogin": boxnowDataRort[a].userLogin,
          "ClassBox": boxnowDataRort[a].classBox
        }));
        // nowDataRort.add(_);
      } else if ((boxnowDataRort[a].userLogin == ApiProxyParameter.userLogin) ==
          (boxnowDataRort[a].classBox == 'T')) {
        ApiProxyParameter.dataListJCustBarcodeTo
            .add(moveToNewLocationResp.fromJson({
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "FromLocation": boxnowDataRort[a].fromLocation,
          "ToLocation": boxnowDataRort[a].toLocation,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "MovedQty": boxnowDataRort[a].movedQty,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
          "UserLogin": boxnowDataRort[a].userLogin,
          "ClassBox": boxnowDataRort[a].classBox
        }));
      } else {
        fnowDataRort.add(moveToNewLocationResp.fromJson({
          "BarcodeId": boxnowDataRort[a].barcodeId,
          "PartNo": boxnowDataRort[a].partNo,
          "PartDesc": boxnowDataRort[a].partDesc,
          "FromLocation": boxnowDataRort[a].fromLocation,
          "ToLocation": boxnowDataRort[a].toLocation,
          "LotNo": boxnowDataRort[a].lotNo,
          "WdrNo": boxnowDataRort[a].wdrNo,
          "MovedQty": boxnowDataRort[a].movedQty,
          "ErrorMessage": boxnowDataRort[a].errorMessage,
          "UserLogin": boxnowDataRort[a].userLogin,
          "ClassBox": boxnowDataRort[a].classBox
        }));
      }
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

  Widget actionSave(Function func_) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'OK');
        await func_();
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

  funcRemoveData(moveToNewLocationResp data) async {
    Navigator.pop(context, 'OK');

    // moveToNewLocationResp data =
    //     ApiProxyParameter.dataListJCustBarcodeFrom[index];
    bool check = false;
    boxnowDataRort = zboxnowDataRort.values.toList();
    for (int i = 0; i < boxnowDataRort.length; i++) {
      if (boxnowDataRort[i].classBox == "T") {
        if (boxnowDataRort[i].barcodeId == data.barcodeId) {
          print(data.barcodeId);
          check = true;
        }
      }
    }
    if (check == true) {
      Tdialog.errorDialog(
        context,
        'Error',
        'The Barcode ID ${data.barcodeId} exist on Tab To Location ',
        okButton(),
      );
    } else {
      for (int i = 0; i < boxnowDataRort.length; i++) {
        if (boxnowDataRort[i].barcodeId == data.barcodeId) {
          if (boxnowDataRort[i].lotNo == data.lotNo) {
            if (boxnowDataRort[i].partNo == data.partNo) {
              if (boxnowDataRort[i].wdrNo == data.wdrNo) {
                zboxnowDataRort.delete(boxnowDataRort[i].key);
              }
            }
          }
        }
      }
      for (int i = 0;
          i < ApiProxyParameter.dataListJCustBarcodeFrom.length;
          i++) {
        if (ApiProxyParameter.dataListJCustBarcodeFrom[i].barcodeId ==
            data.barcodeId) {
          ApiProxyParameter.dataListJCustBarcodeFrom.removeAt(i);
        }
      }
      ApiProxyParameter.dataListJCustBarcodeFrom;
    }

    setState(() {
      ApiProxyParameter.dataListJCustBarcodeFrom;
    });
  }

  checkFromLocation() async {
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

      var result = await proxy.checkFromLocationExist(moveToNewLocationRep(
          barcodeId: 0, fromLocation: _location.text, movedQty: 0.0));
      if (result.errorMessage == null) {
        ApiProxyParameter.jBarcodeFrom = _location.text;
        await zlocationJFromAndTo.put(
            '0',
            LocationJFromAndTo(
                userLogin: ApiProxyParameter.userLogin,
                classBox: 'F',
                locationFrom: ApiProxyParameter.jBarcodeFrom,
                id: 0));
      } else {
        // wrongDialog();
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

  checkFromBarcodeID() async {
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

      var result = await proxy.getDataByBarcodeIdMTNLR(moveToNewLocationRep(
        barcodeId: int.parse(_barcode.text),
        movedQty: 0.0,
      ));
      if (result.errorMessage == null) {
        EasyLoading.dismiss();
        result.fromLocation = ApiProxyParameter.jBarcodeFrom;
        result.userLogin = ApiProxyParameter.userLogin;
        result.classBox = 'F';
        List<String> barcodeCheck = [];
        boxnowDataRort = zboxnowDataRort.values.toList();
        for (int i = 0; i < boxnowDataRort.length; i++) {
          barcodeCheck.add('${boxnowDataRort[i].key}');
        }

        await zboxnowDataRort.put(
            generateId(barcodeCheck),
            MoveToNewLocationRep(
              barcodeId: result.barcodeId,
              partNo: result.partNo,
              partDesc: result.partDesc,
              fromLocation: result.fromLocation,
              toLocation: result.toLocation,
              lotNo: result.lotNo,
              wdrNo: result.wdrNo,
              movedQty: result.movedQty,
              errorMessage: result.errorMessage,
              userLogin: ApiProxyParameter.userLogin,
              classBox: 'F',
            ));
        ApiProxyParameter.countBarcodeToFrom++;
        _barcode.clear();
        setState(() {
          ApiProxyParameter.dataListJCustBarcodeFrom.add(result);
        });
        await _addBarcodeIDDialog();
      } else {
        // wrongDialog();
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

  checkDataFromInsert() async {
    if (ApiProxyParameter.jBarcodeFrom.isNotEmpty) {
      List checkBarcodeID = ApiProxyParameter.dataListJCustBarcodeFrom
          .where((x) => x.barcodeId.toString() == _barcode.text)
          .toList();
      if (checkBarcodeID.isNotEmpty) {
        Tdialog.errorDialog(
          context,
          'Error',
          'Duplicate barcode id data',
          okButton(),
        );
      } else {
        await checkFromBarcodeID();
      }
    } else {
      Tdialog.errorDialog(
        context,
        'Error',
        'No data Location , Please enter Location',
        okButton(),
      );
    }
  }
}
