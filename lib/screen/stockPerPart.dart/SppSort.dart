import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/purchaseOrderReceive/purchaseOrderReceiveMain.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';

import '../../globalParamitor.dart';

enum SortBy { purchaseOrderNo, supplierNo, partNo, shopOrderNo }
enum Direction { asc, desc }
enum SearchOption { purchaseOrderNo, supplierNo, partNo, shopOrderNo }

class StockPerPathSort extends StatefulWidget {
  final int searchData;
  const StockPerPathSort({Key? key, required this.searchData})
      : super(key: key);

  @override
  State<StockPerPathSort> createState() =>
      _StockPerPathSortState();
}

class _StockPerPathSortState extends State<StockPerPathSort> {
  SortBy? _data = SortBy.purchaseOrderNo;
  Direction? _data1 = Direction.asc;
  SearchOption? _data2 = SearchOption.purchaseOrderNo;

  @override
  void initState() {
    super.initState();
    switch (GlobalParam.searchHintNIndex) {
      case 0:
        _data2 = SearchOption.purchaseOrderNo;
        break;
      case 1:
        _data2 = SearchOption.supplierNo;
        break;
      case 2:
        _data2 = SearchOption.partNo;
        break;
      default:
        _data2 = SearchOption.shopOrderNo;
        break;
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
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Purchase Order No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SortBy>(
              value: SortBy.purchaseOrderNo,
              groupValue: _data,
              onChanged: (SortBy? value) {
                setState(() {
                  _data = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Supplier No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SortBy>(
              value: SortBy.supplierNo,
              groupValue: _data,
              onChanged: (SortBy? value) {
                setState(() {
                  _data = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Part No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SortBy>(
              activeColor: HexColor("#4e73be"),
              value: SortBy.partNo,
              groupValue: _data,
              onChanged: (SortBy? value) {
                setState(() {
                  _data = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Shop Order No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SortBy>(
              activeColor: HexColor("#4e73be"),
              value: SortBy.shopOrderNo,
              groupValue: _data,
              onChanged: (SortBy? value) {
                setState(() {
                  _data = value;
                });
              },
            ),
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
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'A to Z',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<Direction>(
              value: Direction.asc,
              groupValue: _data1,
              onChanged: (Direction? value) {
                setState(() {
                  _data1 = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Z to A',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<Direction>(
              value: Direction.desc,
              groupValue: _data1,
              onChanged: (Direction? value) {
                setState(() {
                  _data1 = value;
                });
              },
            ),
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
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Purchase Order No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SearchOption>(
              value: SearchOption.purchaseOrderNo,
              groupValue: _data2,
              onChanged: (SearchOption? value) {
                setState(() {
                  _data2 = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Supplier No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SearchOption>(
              value: SearchOption.supplierNo,
              groupValue: _data2,
              onChanged: (SearchOption? value) {
                setState(() {
                  _data2 = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Part No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SearchOption>(
              activeColor: HexColor("#4e73be"),
              value: SearchOption.partNo,
              groupValue: _data2,
              onChanged: (SearchOption? value) {
                setState(() {
                  _data2 = value;
                });
              },
            ),
          ),
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            title: const Text(
              'Shop Order No',
              style: TextStyle(fontSize: 16.0),
            ),
            leading: Radio<SearchOption>(
              activeColor: HexColor("#4e73be"),
              value: SearchOption.shopOrderNo,
              groupValue: _data2,
              onChanged: (SearchOption? value) {
                setState(() {
                  _data2 = value;
                });
              },
            ),
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
                      _data = SortBy.purchaseOrderNo;
                      _data1 = Direction.asc;
                      _data2 = SearchOption.purchaseOrderNo;
                      GlobalParam.searchHintNIndex = 0;
                    });
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const StockPerPart(autoFocusSearch: false,),
                      ),
                    );
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
                    //Sortby Direction SearchAction

                    switch (_data2) {
                      case SearchOption.purchaseOrderNo:
                        GlobalParam.searchHintNIndex = 0;
                        break;
                      case SearchOption.supplierNo:
                        GlobalParam.searchHintNIndex = 1;
                        break;
                      case SearchOption.partNo:
                        GlobalParam.searchHintNIndex = 2;
                        break;
                      case SearchOption.shopOrderNo:
                        GlobalParam.searchHintNIndex = 3;
                        break;
                      case null:
                        GlobalParam.searchHintNIndex = 0;
                        break;
                    }

                    // Navigator.pop(context, 'OK');
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const StockPerPart(autoFocusSearch: false,),
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

configOK() {}

// class SortText {
//   static changeText(String _data) {
//     print("###########");
//     print(_data);
//     String _newSearch = '';
//     _newSearch = _data;
//     return _newSearch;
//   }
// }
