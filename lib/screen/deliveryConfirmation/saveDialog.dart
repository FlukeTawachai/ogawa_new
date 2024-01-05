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
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';

class SaveDialog extends StatefulWidget {
  final DeliveryConfirmationResp data;
  final double reportedQty;
  final Widget okButton;
  final Widget cancel;
  final Widget save;
  final Function confirmDelivery;
  const SaveDialog(
      {Key? key,
      required this.data,
      required this.reportedQty,
      required this.okButton,
      required this.confirmDelivery,
      required this.save,
      required this.cancel})
      : super(key: key);

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  final TextEditingController _containerNo = TextEditingController();
  String containerNoTxt = '';
  bool saveNext = true;
  List<ConfirmDeliveryBarcode> containerNo = [];
  late Box<ConfirmDeliveryBarcode> containerNoData;
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  List<ConfirmDeliveryBarcode> barcodeList = [];
  late Box<ConfirmDeliveryBarcode> barcodeData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    database = Hive.box('ApiSettings');
    barcodeData = Hive.box("ConfirmDeliveryBarcode");
    containerNoData = Hive.box("ConfirmDeliveryContainerNo");
    barcodeList = barcodeData.values.toList();
    containerNo = containerNoData.values.toList();

    if (containerNo.isNotEmpty) {
      for (int i = 0; i < containerNo.length; i++) {
        if (containerNo[i].id == ApiProxyParameter.userLogin) {
          _containerNo.text = '${containerNo[i].containerNo}';
          containerNoTxt = '${containerNo[i].containerNo}';
          GlobalParam.menuKContainerNo = '${containerNo[i].containerNo}';
        }
      }
    }

    // for (int i = 0; i < containerNo.length; i++) {
    //   containerNoData.delete(containerNo[i].key);
    // }
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
        //height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        child: Container(
          height: 115.0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'Container No',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                height: 40.0,
                color: HexColor("#d9e1f2"),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _containerNo,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      containerNoTxt = value;
                      GlobalParam.menuKContainerNo = value;
                    });
                  },
                ),
              ),
              Container(
                //color: Colors.amber,
                padding: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: HexColor("#4e73be"),
                      value: saveNext,
                      onChanged: (bool? value) {
                        setState(() {
                          saveNext = value!;
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        'Save for next report',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
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
                  _containerNo.clear();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Save');
                  Tdialog.infoDialog(
                      context,
                      "Confirm moved into container?",
                      "Are you sure to confirm moved Qty to this container no $containerNoTxt?",
                      widget.save,
                      widget.cancel);
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // confirmDelivery(String containerNo) async {
  //   try {
  //     ApiSettings apiData = ApiSettings();
  //     dataSetting = database.values.toList();
  //     for (var item in dataSetting) {
  //       if (item.baseName == ApiProxyParameter.dataBaseSelect) {
  //         apiData = item;
  //       }
  //     }
  //     EasyLoading.show(status: 'loading...');

  //     AllApiProxy proxy = AllApiProxy();
  //     proxy.host = '${apiData.apiUrl}';
  //     proxy.dbName = '${apiData.serviceName}';
  //     proxy.dbHost = '${apiData.serviceIp}';
  //     proxy.dbPort = int.parse('${apiData.port}');
  //     proxy.dbUser = ApiProxyParameter.userLogin;
  //     proxy.dbPass = ApiProxyParameter.passLogin;
  //     // print('++++++++++${proxy.host}');
  //     // print('++++++++++${proxy.dbName}');
  //     // print('++++++++++${proxy.dbHost}');
  //     // print('++++++++++${proxy.dbPort}');
  //     // print('++++++++++${proxy.dbUser}');
  //     // print('++++++++++${proxy.dbPass}');

  //     var result = await proxy.confirmDelivery(DeliveryConfirmationReq(
  //         shipmentNo: widget.data.shipmentNo,
  //         lineNo: widget.data.lineNo,
  //         containerNo: containerNo,
  //         noOfCarton: 0,
  //         reservedQty: 0,
  //         reportedQty: widget.reportedQty));
  //     if (result.errorMessage == null) {
  //       ApiProxyParameter.dataListKCustBarcode = [];
  //       barcodeList = barcodeData.values.toList();
  //       for (int i = 0; i < barcodeList.length; i++) {
  //         if (barcodeList[i].shipmentNo == widget.data.shipmentNo) {
  //           if (barcodeList[i].lineNo == widget.data.lineNo) {
  //             if (barcodeList[i].customerNo == widget.data.customerNo) {
  //               if (barcodeList[i].invoiceNo == widget.data.invoiceNo) {
  //                 if (barcodeList[i].partNo == widget.data.partNo) {
  //                   barcodeData.delete(barcodeList[i].key);
  //                 }
  //               }
  //             }
  //           }
  //         }
  //       }

  //       // _containerNo.clear();
  //     } else {
  //       Tdialog.errorDialog(
  //         context,
  //         'Error',
  //         '${result.errorMessage}',
  //         widget.okButton,
  //       );
  //     }

  //     EasyLoading.dismiss();
  //   } on SocketException catch (e) {
  //     EasyLoading.dismiss();
  //     Tdialog.errorDialog(
  //       context,
  //       'Error',
  //       e.message,
  //       widget.okButton,
  //     );
  //   } on Exception catch (e) {
  //     EasyLoading.dismiss();
  //     Tdialog.errorDialog(
  //       context,
  //       'Error',
  //       e.toString(),
  //       widget.okButton,
  //     );
  //   }
  //   setState(() {});
  // }
}
