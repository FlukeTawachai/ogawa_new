import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:jiffy/jiffy.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/class/widget_style.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/partnoMain.dart';

class ListShipment extends StatefulWidget {
  const ListShipment({Key? key}) : super(key: key);

  @override
  State<ListShipment> createState() => _ListShipmentState();
}

class _ListShipmentState extends State<ListShipment> {
  late Future<String> _initialData;
  late String data;
  late String countShipment = 'records found';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialData = initialData();
  }

  @override
  Widget build(BuildContext context) {
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
              '${ApiProxyParameter.dataListK.length} records found',
              style: TextStyle(
                color: HexColor("#bfbfbf"),
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _lstShipment(),
          ),
        ],
      ),
    );
  }

  Widget _lstShipment() {
    return ListView.builder(
      // shrinkWrap: true,
      // scrollDirection: Axis.vertical,
      itemCount: ApiProxyParameter.dataListK.length,
      itemBuilder: (BuildContext context, int index) {
        String result1 =
            Jiffy.parse(ApiProxyParameter.dataListK[index].etdDate!)
                .format(pattern: 'do-MMMM-yyyy');
        return InkWell(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => PartNoMain(
            //       shipmentNo:
            //           '${ApiProxyParameter.dataListK[index].shipmentNo}',
            //       lineNo: '${ApiProxyParameter.dataListK[index].lineNo}',
            //       carton: '${ApiProxyParameter.dataListK[index].noOfCarton}',
            //     ),
            //   ),
            // );
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
                          child: _shipNo(
                              '${ApiProxyParameter.dataListK[index].shipmentNo}'),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _lineNo(
                              '${ApiProxyParameter.dataListK[index].lineNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _date(
                                '${ApiProxyParameter.dataListK[index].etdDate}'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(),
                          child: _qty(
                              '${ApiProxyParameter.dataListK[index].reservedQty}'),
                        ),
                        const SizedBox(
                          width: 15.0,
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
                          child: _partNo(
                              '${ApiProxyParameter.dataListK[index].partNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _receiverID(
                                '${ApiProxyParameter.dataListK[index].customerNo}'),
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
                          child: _itemNo(
                              '${ApiProxyParameter.dataListK[index].itemNo}'),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(),
                            child: _receiverName(
                                '${ApiProxyParameter.dataListK[index].customerName}'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: _carton(
                              '${ApiProxyParameter.dataListK[index].noOfCarton}'),
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

  Widget _shipNo(String txtshipNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Ship No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtshipNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
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

  Widget _lineNo(String txtlineNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Line No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtlineNo,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#a10515"),
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

  Widget _date(String txtdate) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'ETD Date',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtdate,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#7fa968"),
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
              'Qty',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
                color: HexColor("#657da5"),
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
              'Sales Part No',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              minFontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _receiverID(String txtreceiverID) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Receiver Add ID',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtreceiverID,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#70598d"),
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

  Widget _itemNo(String txtitemNo) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Item No.',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtitemNo,
              textAlign: TextAlign.left,
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

  Widget _receiverName(String txtreceiverName) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'Receiver Name',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtreceiverName,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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

  Widget _carton(String txtcarton) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            child: AutoSizeText(
              'No. of Carton',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: HexColor("#bfbfbf"),
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
              txtcarton,
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

  Future<String> initialData() async {
    return "";
  }
}
