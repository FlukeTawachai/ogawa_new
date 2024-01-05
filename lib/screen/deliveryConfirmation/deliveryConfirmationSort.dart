import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/countPerCountReport/countPerCountReport.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/deliveryConfirmationMain.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLocationNo.dart';

import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';

class DeliveryConfirmationSort extends StatefulWidget {
  const DeliveryConfirmationSort({Key? key}) : super(key: key);

  @override
  State<DeliveryConfirmationSort> createState() =>
      _DeliveryConfirmationSortState();
}

class _DeliveryConfirmationSortState extends State<DeliveryConfirmationSort> {
  bool sortShipmentNo = true;
  bool sortSalesPart = false;
  bool sortPlanned = false;
  bool aTz = true;
  bool zTa = false;
  bool optionShipmentNo = true;
  bool optionCustomerNo = false;
  bool optionPartNo = false;
  bool optionInvoiceNo = false;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> userSearchDefault = [];
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    for (int i = 0; i < userSearchDefault.length; i++) {
      if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_K') {
        if (userSearchDefault[i].searchBy == 'SN') {
          optionShipmentNo = true;
          optionCustomerNo = false;
          optionPartNo = false;
          optionInvoiceNo = false;
        } else if (userSearchDefault[i].searchBy == 'CN') {
          optionShipmentNo = false;
          optionCustomerNo = true;
          optionPartNo = false;
          optionInvoiceNo = false;
        } else if (userSearchDefault[i].searchBy == 'PN') {
          optionShipmentNo = false;
          optionCustomerNo = false;
          optionPartNo = true;
          optionInvoiceNo = false;
        } else if (userSearchDefault[i].searchBy == 'IN') {
          optionShipmentNo = false;
          optionCustomerNo = false;
          optionPartNo = false;
          optionInvoiceNo = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
              child: const Text(
                'Configuration',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            const Divider(),
            _sortBy(),
            const Divider(),
            _direction(),
            const Divider(),
            _searchOption(),
            const Divider(),
            _buttonSort(),
          ],
        ),
      ),
    );
  }

  Widget _sortBy() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 25.0),
            child: const Text(
              'Sort By',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          RadioListTile(
            title: const Text(
              "Shipment No/Line No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortShipmentNo,
            onChanged: (bool? value) {
              setState(() {
                sortShipmentNo = value!;
                sortSalesPart = false;
                sortPlanned = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Sales Part No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortSalesPart,
            onChanged: (bool? value) {
              setState(() {
                sortShipmentNo = false;
                sortSalesPart = value!;
                sortPlanned = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Planned Del. Date",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortPlanned,
            onChanged: (bool? value) {
              setState(() {
                sortShipmentNo = false;
                sortSalesPart = false;
                sortPlanned = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _direction() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 25.0),
            child: const Text(
              'Direction',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          RadioListTile(
            title: const Text(
              "A TO Z",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: aTz,
            onChanged: (bool? value) {
              setState(() {
                aTz = value!;
                zTa = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Z TO A",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: zTa,
            onChanged: (bool? value) {
              setState(() {
                zTa = value!;
                aTz = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _searchOption() {
    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 25.0),
            child: const Text(
              'Search Option',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          RadioListTile(
            title: const Text(
              "Shipment No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionShipmentNo,
            onChanged: (bool? value) {
              setState(() {
                optionShipmentNo = value!;
                optionCustomerNo = false;
                optionPartNo = false;
                optionInvoiceNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Customer No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionCustomerNo,
            onChanged: (bool? value) {
              setState(() {
                optionShipmentNo = false;
                optionCustomerNo = value!;
                optionPartNo = false;
                optionInvoiceNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Part No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionPartNo,
            onChanged: (bool? value) {
              setState(() {
                optionShipmentNo = false;
                optionCustomerNo = false;
                optionPartNo = value!;
                optionInvoiceNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Invoice No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionInvoiceNo,
            onChanged: (bool? value) {
              setState(() {
                optionShipmentNo = false;
                optionCustomerNo = false;
                optionPartNo = false;
                optionInvoiceNo = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buttonSort() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(2),
      //height: 50.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 40.0),
              height: 40.0,
              child: ButtonTheme(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      sortShipmentNo = true;
                      sortSalesPart = false;
                      sortPlanned = false;
                      aTz = true;
                      zTa = false;
                      optionShipmentNo = true;
                      optionCustomerNo = false;
                      optionPartNo = false;
                      optionInvoiceNo = false;
                    });
                  },
                  child: const Center(
                      child: Text(
                    "Clear",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: HexColor("#4e73be"),
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 40.0),
              height: 40.0,
              child: ButtonTheme(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    // print("*********** Location No: $sortLotNo");
                    // print("*********** Onhand : $sortOnHand");
                    // print("*********** A TO z: $aTz");
                    // print("*********** Z TO A: $zTa");
                    if (sortShipmentNo == true) {
                      if (aTz == true) {
                        // ApiProxyParameter.dataListK.sort((a, b) => a.shipmentNo
                        //     .toString()
                        //     .compareTo(b.shipmentNo.toString()));
                        ApiProxyParameter.dataListK.sort((a, b) {
                          int cmp = a.shipmentNo
                              .toString()
                              .compareTo(b.shipmentNo.toString());
                          if (cmp != 0) return cmp;
                          return a.lineNo
                              .toString()
                              .compareTo(b.lineNo.toString());
                        });
                      } else if (zTa == true) {
                        // ApiProxyParameter.dataListK.sort((a, b) => b.shipmentNo
                        //     .toString()
                        //     .compareTo(a.shipmentNo.toString()));
                        ApiProxyParameter.dataListK.sort((a, b) {
                          int cmp = b.shipmentNo
                              .toString()
                              .compareTo(a.shipmentNo.toString());
                          if (cmp != 0) return cmp;
                          return b.lineNo
                              .toString()
                              .compareTo(a.lineNo.toString());
                        });
                      }
                    } else if (sortSalesPart == true) {
                      if (aTz == true) {
                        ApiProxyParameter.dataListK.sort((a, b) =>
                            a.partNo.toString().compareTo(b.partNo.toString()));
                      } else if (zTa == true) {
                        ApiProxyParameter.dataListK.sort((a, b) =>
                            b.partNo.toString().compareTo(a.partNo.toString()));
                      }
                    } else if (sortPlanned == true) {
                      if (aTz == true) {
                        ApiProxyParameter.dataListK.sort((a, b) => a.etdDate
                            .toString()
                            .compareTo(b.etdDate.toString()));
                      } else if (zTa == true) {
                        ApiProxyParameter.dataListK.sort((a, b) => b.etdDate
                            .toString()
                            .compareTo(a.etdDate.toString()));
                      }
                    }
                    // save data to SearchDefault
                    for (int i = 0; i < userSearchDefault.length; i++) {
                      if (userSearchDefault[i].id ==
                          '${ApiProxyParameter.userLogin}_K') {
                        if (optionShipmentNo == true) {
                          userSearchDefault[i].searchBy = 'SN';
                        } else if (optionCustomerNo == true) {
                          userSearchDefault[i].searchBy = 'CN';
                        } else if (optionPartNo == true) {
                          userSearchDefault[i].searchBy = 'PN';
                        } else if (optionInvoiceNo == true) {
                          userSearchDefault[i].searchBy = 'IN';
                        }
                        searchDefaultList.delete(userSearchDefault[i].key);

                        searchDefaultList.put(
                            userSearchDefault[i].id, userSearchDefault[i]);
                      }
                    }

                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const DeliveryConfirmationMain(reset: false),
                      ),
                    );
                  },
                  child: const Center(
                      child: Text(
                    "OK",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              decoration: BoxDecoration(
                color: HexColor("#4e73be"),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
