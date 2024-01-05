import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/globalParamitor.dart';

import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';

// enum SortBy { sortLocation, sortOnHand, aTz, zTa }
// enum Direction { asc, desc }
// enum SearchOption { sortLocation, sortOnHand, aTz, zTa }

class PartNoSort extends StatefulWidget {
  final int searchData;
  const PartNoSort({Key? key, required this.searchData}) : super(key: key);

  @override
  State<PartNoSort> createState() => _PartNoSortState();
}

class _PartNoSortState extends State<PartNoSort> {
  bool sortLocation = true;
  bool sortOnHand = false;
  bool aTz = true;
  bool zTa = false;

  @override
  void initState() {
    super.initState();
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
              "Location No",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortLocation,
            onChanged: (bool? value) {
              setState(() {
                sortLocation = value!;
                sortOnHand = false;
              });
            },
          ),
          RadioListTile(
            title: const Text(
              "Qty Onhand",
              style: TextStyle(fontSize: 16.0),
            ),
            value: true,
            groupValue: sortOnHand,
            onChanged: (bool? value) {
              setState(() {
                sortOnHand = value!;
                sortLocation = false;
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
                      sortLocation = true;
                      sortOnHand = false;
                      aTz = true;
                      zTa = false;
                    });
                    // Navigator.pushReplacement<void, void>(
                    //   context,
                    //   MaterialPageRoute<void>(
                    //     builder: (BuildContext context) => const StockPerPart(),
                    //   ),
                    // );
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
                    print("*********** Location No: $sortLocation");
                    print("*********** Onhand : $sortOnHand");
                    print("*********** A TO z: $aTz");
                    print("*********** Z TO A: $zTa");
                    if (sortLocation == true) {
                      if (aTz == true) {
                        ApiProxyParameter.partNo.sort(
                            (a, b) => a.locationNo!.compareTo(b.locationDesc!));
                      } else {
                        ApiProxyParameter.partNo.sort(
                            (a, b) => b.locationNo!.compareTo(a.locationDesc!));
                      }
                    } else {
                      if (aTz == true) {
                        ApiProxyParameter.partNo.sort(
                            (a, b) => a.qtyOnHand!.compareTo(b.qtyOnHand!));
                      } else {
                        ApiProxyParameter.partNo.sort(
                            (a, b) => b.qtyOnHand!.compareTo(a.qtyOnHand!));
                      }
                    }
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const StockPerPart(autoFocusSearch: false,),
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