import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/deliveryConfirmationReq.dart';
import 'package:ogawa_nec/api/response/deliveryConfirmationResp.dart';
import 'package:ogawa_nec/api/response/getDataByShopBarcodeResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';

class OSelectDialog extends StatefulWidget {
  final List<GetDataByShopBarcodeResp> data;
  final Widget cancel;
  final Widget save;
  const OSelectDialog(
      {Key? key, required this.data, required this.save, required this.cancel})
      : super(key: key);

  @override
  State<OSelectDialog> createState() => _OSelectDialogState();
}

class _OSelectDialogState extends State<OSelectDialog> {
  final TextEditingController _containerNo = TextEditingController();
  String containerNoTxt = '';
  bool saveNext = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: HexColor("#5b9bd5"),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        child: Container(
          height: 115.0,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(0),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'Production Line',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        title: Text(
                          "${widget.data[index].productionLine}",
                          // ignore: prefer_const_constructors
                          style: TextStyle(fontSize: 14.0),
                        ),
                        value: true,
                        groupValue: widget.data[index].check,
                        onChanged: (bool? value) {
                          setState(() {
                            for (int i = 0; i < widget.data.length; i++) {
                              if (widget.data[i].productionLine !=
                                  widget.data[index].productionLine) {
                                widget.data[i].check = false;
                              } else {
                                widget.data[index].check = true;
                                GlobalParam.oSelectProductionLine =
                                    widget.data[i];
                              }
                            }
                          });
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          height: 2.0,
          padding: const EdgeInsets.all(0),
          child: const Divider(
            indent: 10.0,
            endIndent: 10.0,
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        Container(
          height: 50.0,
          //color: Colors.amber,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                   Navigator.pop(context, 'SAVE');
                  if (GlobalParam.oSelectProductionLine.productionLine !=
                      null) {
                    Tdialog.infoDialog(
                        context,
                        "Confirm Production Line?",
                        "Are you sure to select ${GlobalParam.oSelectProductionLine.productionLine}?",
                        widget.save,
                        widget.cancel);
                  }
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
