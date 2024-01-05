import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PathCard extends StatelessWidget {
  final String location;
  final String locDesc;
  final String type;
  final double onHand;
  final double res;
  final double lot;
  final double avail;
  final int i;
  final Widget app;
  const PathCard(this.location, this.locDesc, this.type, this.onHand, this.res,
      this.lot, this.avail, this.i, this.app,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Card(
        color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(0),
              ),
            ),
            onPressed: (() {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => app),
              );
            }),
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
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              '${location.isEmpty ? "" : "$location |"} $locDesc',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              type.isEmpty ? "" : type,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )),
                        ],
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
                                numFomat.format(onHand),
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
                                'No of Lot',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.right,
                              )),
                          Container(
                              width: widthScreen * 0.3,
                              alignment: Alignment.centerRight,
                              child: Text(
                                numFomat.format(lot),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
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
                                numFomat.format(res),
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
                                numFomat.format(avail),
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 81,
                      width: widthScreen * 0.005,
                      child: IconButton(
                        color: Colors.black45,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 25.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => app));
                        },
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}

class PathCard2 extends StatelessWidget {
  final String location;
  final String locDesc;
  final String type;
  final double onHand;
  final double res;
  final double lot;
  final double avail;
  final int i;
  final Widget app;
  const PathCard2(this.location, this.locDesc, this.type, this.onHand, this.res,
      this.lot, this.avail, this.i, this.app,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Card(
        color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
        child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.all(0),
              ),
            ),
            onPressed: (() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => app));
            }),
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
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Lot No : $locDesc',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                type.isEmpty ? "" : type,
                                style: const TextStyle(color: Colors.white),
                              ),
                            )),
                          ],
                        )),
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
                                numFomat.format(onHand),
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
                                'No. of W/D/R',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.right,
                              )),
                          Container(
                              width: widthScreen * 0.3,
                              alignment: Alignment.centerRight,
                              child: Text(
                                numFomat.format(lot),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
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
                                numFomat.format(res),
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
                                numFomat.format(avail),
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 81,
                      width: widthScreen * 0.005,
                      child: IconButton(
                        color: Colors.black45,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 25.0,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => app));
                        },
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}

class PartCardNotNext extends StatelessWidget {
  final String wDR;
  final double onHand;
  final double res;
  final double avail;
  final int i;

  const PartCardNotNext(this.wDR, this.onHand, this.res, this.avail, this.i,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    var numFomat = NumberFormat("#,###", "en_US");
    return Card(
      color: (i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
      child: Column(
        children: [
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'W/D/R : $wDR',
                          style: const TextStyle(color: Colors.grey),
                          textAlign: TextAlign.left,
                        )),
                    Container(
                      width: widthScreen * 0.3,
                      height: 20,
                      alignment: Alignment.centerRight,
                    ),
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
                          numFomat.format(res),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
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
                          'Total Oh Hand',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.right,
                        )),
                    Container(
                        width: widthScreen * 0.3,
                        alignment: Alignment.centerRight,
                        child: Text(
                          numFomat.format(onHand),
                          style: const TextStyle(
                              color: Colors.blue,
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
                          numFomat.format(avail),
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
    );
  }
}
