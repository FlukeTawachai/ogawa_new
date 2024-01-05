import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/countPerCountReport/countPerCountReport.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/deliveryConfirmationMain.dart';
import 'package:ogawa_nec/screen/reportMaterialRequisition/reportMaterialRequisition.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLocationNo.dart';

import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';

class ReportMaterialRequisitionSort extends StatefulWidget {
  const ReportMaterialRequisitionSort({Key? key}) : super(key: key);

  @override
  State<ReportMaterialRequisitionSort> createState() =>
      _ReportMaterialRequisitionSortState();
}

class _ReportMaterialRequisitionSortState
    extends State<ReportMaterialRequisitionSort> {
  bool sortMaterialNo = true;
  bool sortPartNo = false;
  bool sortLocationNo = false;
  bool sortLotNo = false;
  bool aTz = true;
  bool zTa = false;
  bool optionMaterialNo = true;
  bool optionCustomerNo = false;
  bool optionPartNo = false;
  bool optionDestNo = false;
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
      if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_H') {
        if (userSearchDefault[i].searchBy == 'MN') {
          optionMaterialNo = true;
          optionCustomerNo = false;
          optionPartNo = false;
          optionDestNo = false;
        } else if (userSearchDefault[i].searchBy == 'CN') {
          optionMaterialNo = false;
          optionCustomerNo = true;
          optionPartNo = false;
          optionDestNo = false;
        } else if (userSearchDefault[i].searchBy == 'PN') {
          optionMaterialNo = false;
          optionCustomerNo = false;
          optionPartNo = true;
          optionDestNo = false;
        } else if (userSearchDefault[i].searchBy == 'DN') {
          optionMaterialNo = false;
          optionCustomerNo = false;
          optionPartNo = false;
          optionDestNo = true;
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
              "Material Req No./Line/Rel",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortMaterialNo,
            onChanged: (bool? value) {
              setState(() {
                sortMaterialNo = value!;
                sortPartNo = false;
                sortLocationNo = false;
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
                sortMaterialNo = false;
                sortPartNo = value!;
                sortLocationNo = false;
                sortLotNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Location",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortLocationNo,
            onChanged: (bool? value) {
              setState(() {
                sortMaterialNo = false;
                sortPartNo = false;
                sortLocationNo = value!;
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
                sortMaterialNo = false;
                sortPartNo = false;
                sortLocationNo = false;
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
              "Material Req No.",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionMaterialNo,
            onChanged: (bool? value) {
              setState(() {
                optionMaterialNo = value!;
                optionCustomerNo = false;
                optionPartNo = false;
                optionDestNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Internal Customer No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionCustomerNo,
            onChanged: (bool? value) {
              setState(() {
                optionMaterialNo = false;
                optionCustomerNo = value!;
                optionPartNo = false;
                optionDestNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Internal Destination No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionDestNo,
            onChanged: (bool? value) {
              setState(() {
                optionMaterialNo = false;
                optionCustomerNo = false;
                optionPartNo = false;
                optionDestNo = value!;
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
                optionMaterialNo = false;
                optionCustomerNo = false;
                optionPartNo = value!;
                optionDestNo = false;
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
                      sortMaterialNo = true;
                      sortPartNo = false;
                      sortLocationNo = false;
                      sortLotNo = false;
                      aTz = true;
                      zTa = false;
                      optionMaterialNo = true;
                      optionCustomerNo = false;
                      optionPartNo = false;
                      optionDestNo = false;
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
                    if (sortMaterialNo == true) {
                      if (aTz == true) {
                        // GlobalParam.dataListH.sort((a, b) => a.materialReqNo
                        //     .toString()
                        //     .compareTo(b.materialReqNo.toString()));

                        GlobalParam.dataListH.sort((a, b) {
                          int cmp = a.materialReqNo
                              .toString()
                              .compareTo(b.materialReqNo.toString());
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
                        // GlobalParam.dataListH.sort((a, b) => b.materialReqNo
                        //     .toString()
                        //     .compareTo(a.materialReqNo.toString()));

                        GlobalParam.dataListH.sort((a, b) {
                          int cmp = b.materialReqNo
                              .toString()
                              .compareTo(a.materialReqNo.toString());
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
                        GlobalParam.dataListH.sort((a, b) =>
                            a.partNo.toString().compareTo(b.partNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListH.sort((a, b) =>
                            b.partNo.toString().compareTo(a.partNo.toString()));
                      }
                    } else if (sortLocationNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListH.sort((a, b) => a.locationNo
                            .toString()
                            .compareTo(b.locationNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListH.sort((a, b) => b.locationNo
                            .toString()
                            .compareTo(a.locationNo.toString()));
                      }
                    } else if (sortLotNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListH.sort((a, b) =>
                            a.lotNo.toString().compareTo(b.lotNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListH.sort((a, b) =>
                            b.lotNo.toString().compareTo(a.lotNo.toString()));
                      }
                    }
                    // save data to SearchDefault
                    for (int i = 0; i < userSearchDefault.length; i++) {
                      if (userSearchDefault[i].id ==
                          '${ApiProxyParameter.userLogin}_H') {
                        if (optionMaterialNo == true) {
                          userSearchDefault[i].searchBy = 'MN';
                        } else if (optionCustomerNo == true) {
                          userSearchDefault[i].searchBy = 'CN';
                        } else if (optionPartNo == true) {
                          userSearchDefault[i].searchBy = 'PN';
                        } else if (optionDestNo == true) {
                          userSearchDefault[i].searchBy = 'DN';
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
                            const ReportMaterialRequisition(reset: false),
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
