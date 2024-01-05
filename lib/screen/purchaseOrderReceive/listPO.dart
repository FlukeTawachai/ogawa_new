import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/purchaseOrderReceive/barcodeMain.dart';

class ListPO extends StatefulWidget {
  const ListPO({Key? key}) : super(key: key);

  @override
  State<ListPO> createState() => _ListPOState();
}

class _ListPOState extends State<ListPO> {
  late Future<String> _initialData;
  late String data;
  late String countPo = 'records found';
  var numFormat = NumberFormat("#,###.##", "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialData = initialData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialData,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) return const CupertinoActivityIndicator();
          data = snapshot.data!;
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    //top: 2.0,
                    bottom: 2.0,
                    left: 10.0,
                  ),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${GlobalParam.dataListN.length} records found',
                    style: const TextStyle(
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                  child: _lstPO(),
                ),
              ],
            ),
          );
        });
  }

  Widget _lstPO() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: GlobalParam.dataListN.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BarcodeMain(
                  poNo:
                      '${GlobalParam.dataListN[index].purchaseOrderNo}|${GlobalParam.dataListN[index].lineNo}|${GlobalParam.dataListN[index].relNo}',
                  data: GlobalParam.dataListN[index],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Container(
              decoration: index % 2 == 0
                  ? WidgetStyle.decorationForList()
                  : WidgetStyle.decorationForListOdd(),
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _poNo(
                              '${GlobalParam.dataListN[index].purchaseOrderNo}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child:
                              _lineNo('${GlobalParam.dataListN[index].lineNo}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child:
                              _relNo('${GlobalParam.dataListN[index].relNo}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _qty(
                              numFormat.format(GlobalParam.dataListN[index].purchOrderQty)),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _uom(
                                '${GlobalParam.dataListN[index].purchUom}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          padding: const EdgeInsets.only(),
                          child:
                              _partNo('${GlobalParam.dataListN[index].partNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _description(
                                '${GlobalParam.dataListN[index].partDesc}'),
                          ),
                        ),
                        Container(
                          width: 25.0,
                          padding: const EdgeInsets.only(right: 5.0),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 25.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          padding: const EdgeInsets.only(),
                          child: _supNo(
                              '${GlobalParam.dataListN[index].supplierNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _supName(
                                '${GlobalParam.dataListN[index].supplierName}'),
                          ),
                        ),
                        Container(
                          width: 25.0,
                          padding: const EdgeInsets.only(right: 5.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _poNo(String txtpoNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'PO. No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            width: 70.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtpoNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _lineNo(String txtlineNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Line No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            width: 45.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtlineNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _relNo(String txtrelNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 43.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Rel No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            width: 43.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtrelNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
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
            width: 90.0,
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Qty to Receive',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
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
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _uom(String txtuom) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Pur. Uom',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtuom,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#657da5"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
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
              'Part No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
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
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _description(String txtdescription) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Discription',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtdescription,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _supNo(String txtsupNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Supplier No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtsupNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#70598d"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _supName(String txtsupName) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Supplier Name',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
              minFontSize: 10.0,
            ),
          ),
          const SizedBox(
            height: 3.0,
          ),
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              txtsupName,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#c3ccd8"),
                fontWeight: FontWeight.bold,
              ),
              maxFontSize: 12.0,
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
}
