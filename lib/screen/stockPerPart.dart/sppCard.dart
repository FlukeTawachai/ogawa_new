import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/response/commonResp.dart';
import 'package:ogawa_nec/screen/stockPerLocation.dart/stockPerLocationLotNo.dart';
import 'package:ogawa_nec/screen/stockPerLocation.dart/stockPerLocationPartNo.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLocationNo.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerLotNo%20.dart';

class PathCard extends StatelessWidget {
  final CommonResp data;
  final int index;
  final String part;
  const PathCard(this.data, this.index, this.part);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFormat = NumberFormat("#,###.##", "en_US");
    return InkWell(
      onTap: () {
        if (part == "sppLocationNo") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  StockPerLocationNo(data: data, reset: true)));
        }
        if (part == "sppLotNo") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => StockPerLotNo(data: data, reset: true),
          ));
        }
        if (part == "splPartNo") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                StockPerLocationPartNo(data: data, reset: true),
          ));
        }

        if (part == "splLotNo") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                StockPerLocationLotNo(data: data, reset: true),
          ));
        }
      },
      child: Card(
        color: (index + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              height: 24,
              color: HexColor('2056AE'),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: (part == "sppLotNo")
                      ? Text(
                          'Lot No :${data.lotNo}',
                          style: const TextStyle(color: Colors.white),
                        )
                      : (part == "sppLocationNo")
                          ? Text(
                              '${data.locationNo} | ${data.locationDesc}',
                              style: const TextStyle(color: Colors.white),
                            )
                          : (part == "splPartNo")
                              ? Text(
                                  '${data.partNo} | ${data.locationDesc}',
                                  style: const TextStyle(color: Colors.white),
                                )
                              : (part == "splLotNo")
                                  ? Text(
                                      'Lot No :${data.lotNo}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      '${data.locationNo} | ${data.locationDesc}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
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
                      (part == "sppLotNo") || (part == "splLotNo")
                          ? Container(
                              width: widthScreen * 0.3,
                              alignment: Alignment.centerRight,
                              child: const Text(
                                'No of W/D/R',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.right,
                              ))
                          : Container(
                              width: widthScreen * 0.3,
                              alignment: Alignment.centerRight,
                              child: const Text(
                                'No of Lot',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.right,
                              )),
                      (part == "sppLotNo") || (part == "splLotNo")
                          ? Container(
                              width: widthScreen * 0.3,
                              alignment: Alignment.centerRight,
                              child: Text(
                                data.noOfWdr!.toStringAsFixed(0),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ))
                          : Container(
                              width: widthScreen * 0.3,
                              alignment: Alignment.centerRight,
                              child: Text(
                                numFormat.format(data.noOfLot),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 81,
                  // ignore: prefer_const_constructors
                  child: Icon(LineAwesomeIcons.angle_right),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
