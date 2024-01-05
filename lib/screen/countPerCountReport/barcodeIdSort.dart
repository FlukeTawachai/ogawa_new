import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/response/countPerCountReportResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/countPerCountReport/importCountPerCountReport.dart';

class BarcodeIdSort extends StatefulWidget {
  final String titlename;
  final CountPerCountReportResp data;
  const BarcodeIdSort({Key? key, required this.titlename, required this.data})
      : super(key: key);

  @override
  State<BarcodeIdSort> createState() => _BarcodeIdSortState();
}

class _BarcodeIdSortState extends State<BarcodeIdSort> {
  bool sortCountRepNo = true;
  bool sortPartNo = false;
  bool sortLotNo = false;
  bool sortLocationNo = false;
  bool aTz = true;
  bool zTa = false;
  bool optionCountRepNo = true;
  bool optionPartNo = false;
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
            // const Divider(),
            // _searchOption(),
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
              "Count Rep No & Sep No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortCountRepNo,
            onChanged: (bool? value) {
              setState(() {
                sortCountRepNo = value!;
                sortPartNo = false;
                sortLotNo = false;
                sortLocationNo = false;
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
                sortCountRepNo = false;
                sortPartNo = value!;
                sortLotNo = false;
                sortLocationNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Location No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortLocationNo,
            onChanged: (bool? value) {
              setState(() {
                sortCountRepNo = false;
                sortPartNo = false;
                sortLotNo = false;
                sortLocationNo = value!;
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
                sortCountRepNo = false;
                sortPartNo = false;
                sortLotNo = value!;
                sortLocationNo = false;
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
              "Count Report No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionCountRepNo,
            onChanged: (bool? value) {
              setState(() {
                optionCountRepNo = value!;
                optionPartNo = false;
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
                optionCountRepNo = false;
                optionPartNo = value!;
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
                      sortCountRepNo = true;
                      sortPartNo = false;
                      sortLotNo = false;
                      sortLocationNo = false;
                      aTz = true;
                      zTa = false;
                      optionCountRepNo = true;
                      optionPartNo = false;
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
                    if (sortCountRepNo == true) {
                      if (aTz == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) => a
                            .countReportNo
                            .toString()
                            .compareTo(b.countReportNo.toString()));
                      } else if (zTa == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) => b
                            .countReportNo
                            .toString()
                            .compareTo(a.countReportNo.toString()));
                      }
                    } else if (sortPartNo == true) {
                      if (aTz == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) =>
                            a.partNo.toString().compareTo(b.partNo.toString()));
                      } else if (zTa == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) =>
                            b.partNo.toString().compareTo(a.partNo.toString()));
                      }
                    } else if (sortLocationNo == true) {
                      if (aTz == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) => a
                            .locationNo
                            .toString()
                            .compareTo(b.locationNo.toString()));
                      } else if (zTa == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) => b
                            .locationNo
                            .toString()
                            .compareTo(a.locationNo.toString()));
                      }
                    } else if (sortLotNo == true) {
                      if (aTz == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) =>
                            a.lotNo.toString().compareTo(b.lotNo.toString()));
                      } else if (zTa == true) {
                        ApiProxyParameter.dataListFBarcodeId.sort((a, b) =>
                            b.lotNo.toString().compareTo(a.lotNo.toString()));
                      }
                    }

                    for (int i = 0; i < userSearchDefault.length; i++) {
                      if (userSearchDefault[i].id ==
                          '${ApiProxyParameter.userLogin}_F') {
                        if (optionCountRepNo == true) {
                          userSearchDefault[i].searchBy = 'CRN';
                        } else if (optionPartNo == true) {
                          userSearchDefault[i].searchBy = 'PN';
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
                            ImportcountPerCountReport(
                          titlename: widget.titlename,
                          data: widget.data,
                          reset: false,
                        ),
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
