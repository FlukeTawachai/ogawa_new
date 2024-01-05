import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/movefromIQCAQC/movefromIQCAQC.dart';
import 'package:ogawa_nec/screen/purchaseOrderReceive/purchaseOrderReceiveMain.dart';

class PurchaseOrderReceiveSort extends StatefulWidget {
  const PurchaseOrderReceiveSort({Key? key}) : super(key: key);

  @override
  State<PurchaseOrderReceiveSort> createState() =>
      _PurchaseOrderReceiveSortState();
}

class _PurchaseOrderReceiveSortState extends State<PurchaseOrderReceiveSort> {
  bool sortPONo = true;
  bool sortPartNo = false;
  bool sortSupplierNo = false;
  bool sortShopOrderNo = false;
  bool aTz = true;
  bool zTa = false;
  bool optionPONo = true;
  bool optionSupplierNo = false;
  bool optionPartNo = false;
  bool optionShopOrderNo = false;
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
      if (userSearchDefault[i].id == '${ApiProxyParameter.userLogin}_N') {
        if (userSearchDefault[i].searchBy == 'PON') {
          optionPONo = true;
          optionSupplierNo = false;
          optionPartNo = false;
          optionShopOrderNo = false;
        } else if (userSearchDefault[i].searchBy == 'SN') {
          optionPONo = false;
          optionSupplierNo = true;
          optionPartNo = false;
          optionShopOrderNo = false;
        } else if (userSearchDefault[i].searchBy == 'PN') {
          optionPONo = false;
          optionSupplierNo = false;
          optionPartNo = true;
          optionShopOrderNo = false;
        } else if (userSearchDefault[i].searchBy == 'SON') {
          optionPONo = false;
          optionSupplierNo = false;
          optionPartNo = false;
          optionShopOrderNo = true;
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
              "Purchase Order No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortPONo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = value!;
                sortPartNo = false;
                sortSupplierNo = false;
                sortShopOrderNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Supplier No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortSupplierNo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = false;
                sortPartNo = false;
                sortSupplierNo = value!;
                sortShopOrderNo = false;
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
                sortSupplierNo = false;
                sortShopOrderNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Shop Order No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortShopOrderNo,
            onChanged: (bool? value) {
              setState(() {
                sortPONo = false;
                sortPartNo = false;
                sortSupplierNo = false;
                sortShopOrderNo = value!;
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
              "Purchase Order No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionPONo,
            onChanged: (bool? value) {
              setState(() {
                optionPONo = value!;
                optionSupplierNo = false;
                optionPartNo = false;
                optionShopOrderNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Supplier No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionSupplierNo,
            onChanged: (bool? value) {
              setState(() {
                optionPONo = false;
                optionSupplierNo = value!;
                optionPartNo = false;
                optionShopOrderNo = false;
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
                optionSupplierNo = false;
                optionPartNo = value!;
                optionShopOrderNo = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Shop Order No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: optionShopOrderNo,
            onChanged: (bool? value) {
              setState(() {
                optionPONo = false;
                optionSupplierNo = false;
                optionPartNo = false;
                optionShopOrderNo = value!;
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
                      sortSupplierNo = false;
                      sortShopOrderNo = false;
                      aTz = true;
                      zTa = false;
                      optionPONo = true;
                      optionSupplierNo = false;
                      optionPartNo = false;
                      optionShopOrderNo = false;
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
                    // print("*********** Location No: $sortShopOrderNo");
                    // print("*********** Onhand : $sortOnHand");
                    // print("*********** A TO z: $aTz");
                    // print("*********** Z TO A: $zTa");
                    if (sortPONo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListN.sort((a, b) => a.purchaseOrderNo
                            .toString()
                            .compareTo(b.purchaseOrderNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListN.sort((a, b) => b.purchaseOrderNo
                            .toString()
                            .compareTo(a.purchaseOrderNo.toString()));
                      }
                    } else if (sortPartNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListN.sort((a, b) =>
                            a.partNo.toString().compareTo(b.partNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListN.sort((a, b) =>
                            b.partNo.toString().compareTo(a.partNo.toString()));
                      }
                    } else if (sortSupplierNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListN.sort((a, b) => a.supplierNo
                            .toString()
                            .compareTo(b.supplierNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListN.sort((a, b) => b.supplierNo
                            .toString()
                            .compareTo(a.supplierNo.toString()));
                      }
                    } else if (sortShopOrderNo == true) {
                      if (aTz == true) {
                        GlobalParam.dataListN.sort((a, b) => a.shopOrderNo
                            .toString()
                            .compareTo(b.shopOrderNo.toString()));
                      } else if (zTa == true) {
                        GlobalParam.dataListN.sort((a, b) => b.shopOrderNo
                            .toString()
                            .compareTo(a.shopOrderNo.toString()));
                      }
                    }
                    // save data to SearchDefault
                    for (int i = 0; i < userSearchDefault.length; i++) {
                      if (userSearchDefault[i].id ==
                          '${ApiProxyParameter.userLogin}_N') {
                        if (optionPONo == true) {
                          userSearchDefault[i].searchBy = 'PON';
                        } else if (optionSupplierNo == true) {
                          userSearchDefault[i].searchBy = 'SN';
                        } else if (optionPartNo == true) {
                          userSearchDefault[i].searchBy = 'PN';
                        } else if (optionShopOrderNo == true) {
                          userSearchDefault[i].searchBy = 'SON';
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
                            const PurchaseOrderReceiveMain(reset: false),
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
