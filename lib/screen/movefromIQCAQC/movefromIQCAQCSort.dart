import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/countPerCountReport/countPerCountReport.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/deliveryConfirmationMain.dart';
import 'package:ogawa_nec/screen/movefromIQCAQC/movefromIQCAQC.dart';
import 'package:ogawa_nec/screen/reportMaterialRequisition/reportMaterialRequisition.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLocationNo.dart';

import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';

class MovefromIQCAQCSort extends StatefulWidget {
  const MovefromIQCAQCSort({Key? key}) : super(key: key);

  @override
  State<MovefromIQCAQCSort> createState() => _MovefromIQCAQCSortState();
}

class _MovefromIQCAQCSortState extends State<MovefromIQCAQCSort> {
  bool sortPONo = true;
  bool sortPartNo = false;
  bool sortVenderNo = false;
  bool sortLotNo = false;
  bool aTz = true;
  bool zTa = false;
  bool optionPONo = true;
  bool optionVenderNo = false;
  bool optionPartNo = false;
  bool optionLotNo = false;
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
      if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_I') {
        if (userSearchDefault[i].searchBy == 'PON') {
          optionPONo = true;
          optionVenderNo = false;
          optionPartNo = false;
          optionLotNo = false;
        } else if (userSearchDefault[i].searchBy == 'VN') {
          optionPONo = false;
          optionVenderNo = true;
          optionPartNo = false;
          optionLotNo = false;
        } else if (userSearchDefault[i].searchBy == 'PN') {
          optionPONo = false;
          optionVenderNo = false;
          optionPartNo = true;
          optionLotNo = false;
        } else if (userSearchDefault[i].searchBy == 'LN') {
          optionPONo = false;
          optionVenderNo = false;
          optionPartNo = false;
          optionLotNo = true;
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
              "PO No/Line/Rel",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortPONo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = value!;
                sortPartNo = false;
                sortVenderNo = false;
                sortLotNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Part No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortPartNo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = false;
                sortPartNo = value!;
                sortVenderNo = false;
                sortLotNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Vender No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortVenderNo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = false;
                sortPartNo = false;
                sortVenderNo = value!;
                sortLotNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Lot No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortLotNo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = false;
                sortPartNo = false;
                sortVenderNo = false;
                sortLotNo = value!;
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
              "PO No/Line/Rel",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionPONo,
            onChanged: (bool? value) {
              setState(() {
                optionPONo = value!;
                optionVenderNo = false;
                optionPartNo = false;
                optionLotNo = false;
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
                optionPONo = false;
                optionVenderNo = false;
                optionPartNo = value!;
                optionLotNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Vender No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionVenderNo,
            onChanged: (bool? value) {
              setState(() {
                optionPONo = false;
                optionVenderNo = value!;
                optionPartNo = false;
                optionLotNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Lot No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionLotNo,
            onChanged: (bool? value) {
              setState(() {
                optionPONo = false;
                optionVenderNo = false;
                optionPartNo = false;
                optionLotNo = value!;
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
                      sortPONo = true;
                      sortPartNo = false;
                      sortVenderNo = false;
                      sortLotNo = false;
                      aTz = true;
                      zTa = false;
                      optionPONo = true;
                      optionVenderNo = false;
                      optionPartNo = false;
                      optionLotNo = false;
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
                    if (sortPONo == true) {
                      if (aTz == true) {
                        // GlobalParam.dataListI.sort((a, b) => a.purchaseOrderNo
                        //     .toString()
                        //     .compareTo(b.purchaseOrderNo.toString()));

                        GlobalParam.dataListI.sort((a, b) {
                          int cmp = a.purchaseOrderNo
                              .toString()
                              .compareTo(b.purchaseOrderNo.toString());
                          if (cmp != 0) return cmp;
                          int cmp2 = a.lineNo
                              .toString()
                              .compareTo(b.lineNo.toString());
                          if (cmp2 != 0) return cmp2;
                          return a.relNo
                              .toString()
                              .compareTo(b.relNo.toString());
                        });
                      } else if (zTa == true) {
                        // GlobalParam.dataListI.sort((a, b) => b.purchaseOrderNo
                        //     .toString()
                        //     .compareTo(a.purchaseOrderNo.toString()));
                        GlobalParam.dataListI.sort((a, b) {
                          int cmp = b.purchaseOrderNo
                              .toString()
                              .compareTo(a.purchaseOrderNo.toString());
                          if (cmp != 0) return cmp;
                          int cmp2 = b.lineNo
                              .toString()
                              .compareTo(a.lineNo.toString());
                          if (cmp2 != 0) return cmp2;
                          return b.relNo
                              .toString()
                              .compareTo(a.relNo.toString());
                        });
                      }
                    } else if (sortPartNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListI.sort((a, b) =>
                            a.partNo.toString().compareTo(b.partNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListI.sort((a, b) =>
                            b.partNo.toString().compareTo(a.partNo.toString()));
                      }
                    } else if (sortVenderNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListI.sort((a, b) => a.vendorNo
                            .toString()
                            .compareTo(b.vendorNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListI.sort((a, b) => b.vendorNo
                            .toString()
                            .compareTo(a.vendorNo.toString()));
                      }
                    } else if (sortLotNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListI.sort((a, b) =>
                            a.lotNo.toString().compareTo(b.lotNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListI.sort((a, b) =>
                            b.lotNo.toString().compareTo(a.lotNo.toString()));
                      }
                    }
                    // save data to SearchDefault
                    for (int i = 0; i < userSearchDefault.length; i++) {
                      if (userSearchDefault[i].id ==
                          '${ApiProxyParameter.userLogin}_I') {
                        if (optionPONo == true) {
                          userSearchDefault[i].searchBy = 'PON';
                        } else if (optionVenderNo == true) {
                          userSearchDefault[i].searchBy = 'VN';
                        } else if (optionPartNo == true) {
                          userSearchDefault[i].searchBy = 'PN';
                        } else if (optionLotNo == true) {
                          userSearchDefault[i].searchBy = 'LN';
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
                            const MovefromIQCAQC(reset: false),
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
