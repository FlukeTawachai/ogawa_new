import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/globalParamitor.dart';

class PathCard extends StatefulWidget {
  final String cNo;
  final String sepNo;
  final String lotNo;
  final String wRDNo;
  final String partNo;
  final String description;
  final String locationNo;
  final String locDesc;
  final bool checkbox;
  final Function setDataCheckbox;
  final int i;

  const PathCard(
      this.cNo,
      this.sepNo,
      this.lotNo,
      this.wRDNo,
      this.partNo,
      this.description,
      this.locationNo,
      this.locDesc,
      this.checkbox,
      this.setDataCheckbox,
      this.i,
      {Key? key})
      : super(key: key);

  @override
  State<PathCard> createState() => _PathCardState();
}

class _PathCardState extends State<PathCard> {
  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    return Card(
      color: (widget.i + 1) % 2 == 0 ? HexColor('DDE9F5') : HexColor('ffffff'),
      child: TextButton(
        onPressed: (() {}),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  height: 120,
                  // width: widthScreen * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      rowCord1(widget.cNo, widget.sepNo, widget.lotNo,
                          widget.wRDNo, widthScreen),
                      rowCord2(widget.partNo, widget.description, widthScreen),
                      rowCord3(widget.locationNo, widget.locDesc, widthScreen),
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

  Widget rowCord1(cNo, sepNo, lotNo, wRDNo, widthScreen) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PO. No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  cNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Line',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  sepNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rel',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  lotNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    // fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.36,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Lot No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  wRDNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.green,
                    fontSize: 16,
                    // fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rowCord2(partNo, description, widthScreen) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Part No',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  partNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  description,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey,
                    fontSize: 16,
                    // fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget rowCord3(locationNo, locDesc, widthScreen) {
    return Expanded(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            width: widthScreen * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Inv Qty to Move',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  locationNo,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color.fromARGB(255, 102, 32, 128),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            width: widthScreen * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inv Uom',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  locDesc,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: widthScreen * 0.36,
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      height: 20,
                      alignment: Alignment.bottomCenter,
                      child: Checkbox(
                        value: widget.checkbox,
                        onChanged: (bool? value) {
                          // widget.setDataCheckbox(widget.cNo,widget.sepNo,widget.lotNo,widget.partNo);
                          setState(() {
                            for (int i = 0;
                                i < GlobalParam.dataListI.length;
                                i++) {
                              if (GlobalParam.dataListI[i].purchaseOrderNo ==
                                  widget.cNo) {
                                if (GlobalParam.dataListI[i].lineNo ==
                                    widget.sepNo) {
                                  if (GlobalParam.dataListI[i].relNo ==
                                      widget.lotNo) {
                                    if (GlobalParam.dataListI[i].partNo ==
                                        widget.partNo) {
                                      GlobalParam.dataListI[i].check =
                                          !GlobalParam.dataListI[i].check!;
                                    }
                                  }
                                }
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const Text(
                      'Confirm to Move',
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
