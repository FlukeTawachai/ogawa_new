import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLocationNo.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLotNo%20.dart';

class LotNoCard extends StatelessWidget {
  final CommonResp data;
  final int index;
  final String part;
  const LotNoCard(this.data, this.index, this.part);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFormat = NumberFormat("#,###.##", "en_US");
    return InkWell(
      onTap: () {},
      child: Card(
        color: (index + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
        child: Column(
          children: [
            const SizedBox(height: 12,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 96,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: widthScreen * 0.12,
                              alignment: Alignment.centerRight,
                              // ignore: prefer_const_constructors
                              child: Text(
                                'W/D/R:',
                                // ignore: prefer_const_constructors
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.left,
                              )),
                          Container(
                              width: widthScreen * 0.25,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${data.wdrNo}',
                                // ignore: prefer_const_constructors
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              )),
                        ],
                      ),
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            '',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          )),
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Total Reserved',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          )),
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: Text(
                            numFormat.format(data.qtyReserved),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: widthScreen * 0.15,
                ),
                SizedBox(
                  height: 81,
                  child: Column(
                    children: [
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Total On Hand',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          )),
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: Text(
                            numFormat.format(data.qtyOnHand),
                            style: TextStyle(
                                color: HexColor('2056AE'),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          )),
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Total Available',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.right,
                          )),
                      Container(
                          width: widthScreen * 0.3,
                          alignment: Alignment.centerRight,
                          child: Text(
                            numFormat.format(data.qtyAvailable),
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
