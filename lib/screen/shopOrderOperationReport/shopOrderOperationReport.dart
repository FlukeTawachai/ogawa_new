import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/getDataByShopBarcodeReq.dart';
import 'package:ogawa_nec/api/response/getDataByShopBarcodeResp.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/shopOrderOperationReport/selectDialog.dart';

class ShopOrderOperationReport extends StatefulWidget {
  const ShopOrderOperationReport({Key? key}) : super(key: key);

  @override
  State<ShopOrderOperationReport> createState() =>
      _ShopOrderOperationReportState();
}

class _ShopOrderOperationReportState extends State<ShopOrderOperationReport> {
  final FocusNode _nodeshopOrderNo = FocusNode();

  final FocusNode _nodecustomerBarcode = FocusNode();
  final FocusNode _nodeLocationNo = FocusNode();
  final FocusNode _nodeReportedQty = FocusNode();
  final TextEditingController _shopOrderNo = TextEditingController();
  final TextEditingController _customerBarcode = TextEditingController();
  final TextEditingController _partNo = TextEditingController();
  final TextEditingController _partName = TextEditingController();
  final TextEditingController _planMan = TextEditingController();
  final TextEditingController _planSetup = TextEditingController();
  final TextEditingController _operationNo = TextEditingController();
  final TextEditingController _operationDesc = TextEditingController();
  final TextEditingController _lineNo = TextEditingController();
  final TextEditingController _lotSize = TextEditingController();

  final TextEditingController _remainQty = TextEditingController();
  final TextEditingController _uom1 = TextEditingController();
  final TextEditingController _uom2 = TextEditingController();
  final TextEditingController _reportedQty = TextEditingController();
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  String reportedQtyInput = '0';
  GetDataByShopBarcodeResp dataSelect = GetDataByShopBarcodeResp();
  bool isError = true;
  String errorMessage = "";

  int charLength = 0;
  var numFormat = NumberFormat("#,###.##", "en_US");
  String shopBarcode = '';
  double heightScreen = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = Hive.box('ApiSettings');
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop Order Operation Report'),
        ),
        drawer: const MenuSide(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: shopOrderNo(),
                    ),
                    Expanded(
                      child: partNo(),
                    ),
                  ],
                ),
                partName(),
                Row(
                  children: [
                    Expanded(
                      child: planMan(),
                    ),
                    Expanded(
                      child: planSetup(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: operationNo(),
                    ),
                    Expanded(
                      child: lotSize(),
                    ),
                  ],
                ),
                Row(
                  children: [operationDesc(), lineNo()],
                ),
                Row(
                  children: [
                    Expanded(
                      child: remainQty(),
                    ),
                    uom1(),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: reportedQty(),
                    ),
                    uom2(),
                  ],
                ),
                saveButton(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBarFooter(),
      ),
    );
  }

  Widget shopOrderNo() {
    return Focus(
      onFocusChange: (value) {
        if (value == false && _shopOrderNo.text != "") {
          getDataByShopBarcode();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: TextField(
          enabled: true,
          autofocus: true,
          focusNode: _nodeshopOrderNo,
          enableInteractiveSelection: false,
          readOnly: false,
          controller: _shopOrderNo,
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#ed7d31"))),
            enabledBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: HexColor("#ed7d31"),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: HexColor("#ed7d31"),
                width: 2.0,
              ),
            ),
            hintText: '',
            hintStyle: TextStyle(
              color: HexColor("#a8a8a8"),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            labelText: 'Shop Order No',
            labelStyle: TextStyle(
              color: HexColor("#ed7d31"),
            ),
            counterText: '',
            suffixIcon: Container(
              padding: const EdgeInsets.all(0),
              width: 15.0,
              height: 15.0,
              child: _shopOrderNo.text.isNotEmpty
                  ? IconButton(
                      alignment: Alignment.centerLeft,
                      icon: Image.asset(
                        'assets/images/close.png',
                        scale: 1.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _shopOrderNo.text = '';
                          _partNo.text = '';
                          _partName.text = '';
                          _remainQty.text = '';
                          _planMan.text = '';
                          _planSetup.text = '';
                          _operationNo.text = '';
                          _lotSize.text = '';
                          _operationDesc.text = '';
                          _lineNo.text = '';
                          _uom1.text = '';
                          _uom2.text = '';
                          _reportedQty.text = "";
                        });
                        FocusScope.of(context).requestFocus(_nodeshopOrderNo);
                      },
                    )
                  : null,
            ),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                _shopOrderNo.text = value.replaceAll("/", "|");
                shopBarcode = value.replaceAll("/", "|");
                _shopOrderNo.selection = TextSelection.fromPosition(
                    TextPosition(offset: _shopOrderNo.text.length));
                isError = true;
              });
            }
          },
          onSubmitted: (value) {
            setState(() {
              _shopOrderNo.text = value.replaceAll("/", "|");
              shopBarcode = value.replaceAll("/", "|");
              _shopOrderNo.selection = TextSelection.fromPosition(
                  TextPosition(offset: _shopOrderNo.text.length));
            });
            // getDataByShopBarcode();
          },
        ),
      ),
    );
  }

  Widget customerBarcode() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: true,
        //autofocus: true,
        focusNode: _nodecustomerBarcode,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _customerBarcode,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#ed7d31"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#ed7d31"),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: HexColor("#ed7d31"),
              width: 2.0,
            ),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a8a8a8"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          labelText: 'Customer Barcode',
          labelStyle: TextStyle(
            color: HexColor("#ed7d31"),
          ),
          counterText: '',
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _customerBarcode.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _customerBarcode.clear();
                        _reportedQty.text = '';
                        FocusScope.of(context)
                            .requestFocus(_nodecustomerBarcode);
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            var text = value;
            var textList = text.split("|");

            _customerBarcode.text = textList[0];
            _customerBarcode.selection = TextSelection.fromPosition(
                TextPosition(offset: _customerBarcode.text.length));
            if (_customerBarcode.text == "") {
              _reportedQty.text = '';
            }
          });
        },
        onSubmitted: (value) {},
      ),
    );
  }

  Widget partNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        // autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        // readOnly: true,
        controller: _partNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Part No',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget partName() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _partName,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Part Name',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget planMan() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _planMan,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Plan Man',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget planSetup() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _planSetup,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Plan Setup Man',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget operationNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _operationNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Operation No',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget lotSize() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _lotSize,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Lot Size',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget operationDesc() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _operationDesc,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Operation Desc',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget lineNo() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _lineNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Line No',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget remainQty() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _remainQty,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Remaining Qty',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget uom1() {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _uom1,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Uom',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget uom2() {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _uom2,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Uom',
          labelStyle: TextStyle(
            color: HexColor("#a6a6a6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a6a6a6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#a6a6a6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#a6a6a6"),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget reportedQty() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Focus(
        onFocusChange: (value) {
          if (reportedQtyInput != '') {
            if (double.parse(reportedQtyInput) <= 0) {
              Tdialog.errorDialog(
                context,
                'Error',
                'Reported Qty need more zero.',
                okButton(),
              );
              setReportZero();
            }
          } else {
            Tdialog.errorDialog(
              context,
              'Error',
              'Reported Qty need more zero.',
              okButton(),
            );
            setReportZero();
          }
        },
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          enabled: true,
          //autofocus: true,
          focusNode: _nodeReportedQty,
          enableInteractiveSelection: false,
          readOnly: false,
          controller: _reportedQty,
          style: const TextStyle(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: HexColor("#ed7d31"))),
            enabledBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: HexColor("#ed7d31"),
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: HexColor("#ed7d31"),
                width: 2.0,
              ),
            ),
            hintText: '',
            hintStyle: TextStyle(
              color: HexColor("#a8a8a8"),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            labelText: 'Reported Qty',
            labelStyle: TextStyle(
              color: HexColor("#ed7d31"),
            ),
            counterText: '',
            suffixIcon: Container(
              padding: const EdgeInsets.all(0),
              width: 15.0,
              height: 15.0,
              child: _reportedQty.text.isNotEmpty
                  ? IconButton(
                      alignment: Alignment.centerLeft,
                      icon: Image.asset(
                        'assets/images/close.png',
                        scale: 1.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _reportedQty.clear();
                          reportedQtyInput = "0";
                        });
                      },
                    )
                  : null,
            ),
          ),
          onChanged: _onChangedreportedQty,
          onSubmitted: (value) {
            if (value != '') {
              if (double.parse(value) <= 0) {
                Tdialog.errorDialog(
                  context,
                  'Error',
                  'Reported Qty need more zero.',
                  okButton(),
                );
                setReportZero();
              } else {
                reportedQtyInput = value;
              }
            } else {
              Tdialog.errorDialog(
                context,
                'Error',
                'Reported Qty need more zero.',
                okButton(),
              );
              setReportZero();
            }
          },
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: isError == true ? Colors.grey : HexColor('#4472c4'),
          minimumSize: const Size.fromHeight(
              50), // fromHeight use double.infinity as width and 40 is the height
        ),
        onPressed: () {
          if (isError == false) {
            if (double.parse(reportedQtyInput) <= 0) {
              Tdialog.errorDialog(
                context,
                'Error',
                'Reported Qty need more zero.',
                okButton(),
              );
              setReportZero();
            } else {
              Tdialog.infoDialog(
                  context,
                  'Confirm reported Qty?',
                  'Are you sure to confirm reported Qty?',
                  actionSave(),
                  cancelButton());
            }
          }
        },
        child: const Text(
          'Confirm Reported Qty',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }

  Widget actionSave() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'OK');
        if (_shopOrderNo.text == '') {
          Tdialog.errorDialog(
            context,
            'Error',
            'Shop Order No is entity.',
            okButton(),
          );
        } else {
          if (double.parse(reportedQtyInput) <= 0) {
            Tdialog.errorDialog(
              context,
              'Error',
              'Reported Qty need more zero.',
              okButton(),
            );
            setReportZero();
          } else {
            if (dataSelect.remainingQty! < double.parse(reportedQtyInput)) {
              Tdialog.infoDialog(
                  context,
                  'Confirm Over Qty?',
                  'Reported qty is over than the remaining qty. Are you sure to report this qty.?',
                  actionOverQtySave(),
                  cancelButton());
            } else {
              shopOrderReported();
            }
          }
        }
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget actionOverQtySave() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'OK');
        if (_shopOrderNo.text == '') {
          Tdialog.errorDialog(
            context,
            'Error',
            'Shop Order No is entity.',
            okButton(),
          );
        } else {
          if (double.parse(reportedQtyInput) <= 0) {
            Tdialog.errorDialog(
              context,
              'Error',
              'Reported Qty need more zero.',
              okButton(),
            );
            setReportZero();
          } else {
            shopOrderReported();
          }
        }
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget cancelButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
      },
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget okButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget selectProductLine() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.pop(context, 'OK');
        if (GlobalParam.oSelectProductionLine.productionLine != null) {
          var data = GlobalParam.oSelectProductionLine;
          List<String> strList = shopBarcode.split("|");
          setState(() {
            _shopOrderNo.text = "${strList[0]}|${strList[1]}|${strList[2]}";
            _partNo.text = "${data.partNo}";
            _partName.text = "${data.partDesc}";
            _planMan.text = numFormat.format(double.parse("${data.planMan}"));
            _planSetup.text =
                numFormat.format(double.parse("${data.planSetupMan}"));
            _operationNo.text = "${data.operationNo}";
            _lotSize.text = numFormat.format(double.parse("${data.lotSize}"));
            _operationDesc.text = "${data.operationDesc}";
            _lineNo.text = "${data.productionLine}";
            _uom1.text = "${data.uom}";
            _uom2.text = "${data.uom}";
            _remainQty.text =
                numFormat.format(double.parse("${data.remainingQty}"));
            _reportedQty.text = strList[4].replaceAll(",", "");
            reportedQtyInput = strList[4].replaceAll(",", "");
            dataSelect = data;
            isError = false;
          });

          getDataByProductionLine();
        }
      },
      child: Text(
        'OK',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  _onChangedCusBarcode(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  setReportZero() {
    setState(() {
      List<String> strList = shopBarcode.split("|");
      _reportedQty.text = strList[4].replaceAll(",", "");
      reportedQtyInput = strList[4].replaceAll(",", "");
    });
    FocusScope.of(context).requestFocus(_nodeReportedQty);
  }

  _onChangedreportedQty(String value) {
    setState(() {
      charLength = value.length;
      // ignore: unnecessary_string_interpolations
      // value = '${Utility.formNum(
      //   value.replaceAll(',', ''),
      // )}';
      // _reportedQty.value = TextEditingValue(
      //   text: value,
      //   selection: TextSelection.collapsed(
      //     offset: value.length,
      //   ),
      // );

      reportedQtyInput = value == "" ? "0" : value;
    });
  }

  getDataByShopBarcode() async {
    try {
      ApiSettings apiData = ApiSettings();
      dataSetting = database.values.toList();
      for (var item in dataSetting) {
        if (item.baseName == ApiProxyParameter.dataBaseSelect) {
          apiData = item;
        }
      }
      EasyLoading.show(status: 'loading...');

      AllApiProxy proxy = AllApiProxy();
      proxy.host = '${apiData.apiUrl}';
      proxy.dbName = '${apiData.serviceName}';
      proxy.dbHost = '${apiData.serviceIp}';
      proxy.dbPort = int.parse('${apiData.port}');
      proxy.dbUser = ApiProxyParameter.userLogin;
      proxy.dbPass = ApiProxyParameter.passLogin;
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');
      GlobalParam.oSelectProductionLine = GetDataByShopBarcodeResp();
      var result = await proxy.oGetDataByShopBarcode(
          GetDataByShopBarcodeReq(shopBarcode: _shopOrderNo.text));
      if (result.isEmpty) {
        Tdialog.errorDialog(
          context,
          'Error',
          "Data not found.",
          okButton(),
        );
        setState(() {
          _partNo.text = '';
          _partName.text = '';
          _planMan.text = '';
          _planSetup.text = '';
          _operationNo.text = '';
          _lotSize.text = '';
          _operationDesc.text = '';
          _lineNo.text = '';
          _uom1.text = '';
          _uom2.text = '';
          _remainQty.text = '';
          _reportedQty.text = "";
          isError = true;
          errorMessage = "Data not found.";
        });
        // FocusScope.of(context).requestFocus(_nodeshopOrderNo);
      } else {
        EasyLoading.dismiss();
        List<String> strList = shopBarcode.split("|");
        if (result.length > 1) {
          await showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => OSelectDialog(
                  data: result,
                  save: selectProductLine(),
                  cancel: cancelButton()));
        } else {
          setState(() {
            _shopOrderNo.text = "${strList[0]}|${strList[2]}|${strList[2]}";
            _partNo.text = "${result[0].partNo}";
            _partName.text = "${result[0].partDesc}";
            _planMan.text =
                numFormat.format(double.parse("${result[0].planMan}"));
            _planSetup.text =
                numFormat.format(double.parse("${result[0].planSetupMan}"));
            _operationNo.text = "${result[0].operationNo}";
            _lotSize.text =
                numFormat.format(double.parse("${result[0].lotSize}"));
            _operationDesc.text = "${result[0].operationDesc}";
            _lineNo.text = "${result[0].productionLine}";
            _uom1.text = "${result[0].uom}";
            _uom2.text = "${result[0].uom}";
            _remainQty.text =
                numFormat.format(double.parse("${result[0].remainingQty}"));
            _reportedQty.text = strList[4].replaceAll(",", "");
            reportedQtyInput = strList[4].replaceAll(",", "");
            dataSelect = result[0];
            isError = false;
          });
          getDataByProductionLine();
        }
      }

      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }

  getDataByProductionLine() async {
    try {
      ApiSettings apiData = ApiSettings();
      dataSetting = database.values.toList();
      for (var item in dataSetting) {
        if (item.baseName == ApiProxyParameter.dataBaseSelect) {
          apiData = item;
        }
      }
      EasyLoading.show(status: 'loading...');

      AllApiProxy proxy = AllApiProxy();
      proxy.host = '${apiData.apiUrl}';
      proxy.dbName = '${apiData.serviceName}';
      proxy.dbHost = '${apiData.serviceIp}';
      proxy.dbPort = int.parse('${apiData.port}');
      proxy.dbUser = ApiProxyParameter.userLogin;
      proxy.dbPass = ApiProxyParameter.passLogin;
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');

      var result = await proxy.oGetDataByProductionLine(GetDataByShopBarcodeReq(
          shopBarcode: shopBarcode, productionLine: _lineNo.text));
      if (result.errorMessage != null) {
        Tdialog.errorDialog(
          context,
          'Error',
          "${result.errorMessage}",
          okButton(),
        );

        setState(() {
          isError = true;
          errorMessage = "${result.errorMessage}";
        });
      } else {
        FocusScope.of(context).requestFocus(_nodeReportedQty);

        setState(() {
          isError = false;
        });
      }

      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }

  shopOrderReported() async {
    try {
      ApiSettings apiData = ApiSettings();
      dataSetting = database.values.toList();
      for (var item in dataSetting) {
        if (item.baseName == ApiProxyParameter.dataBaseSelect) {
          apiData = item;
        }
      }
      EasyLoading.show(status: 'loading...');

      AllApiProxy proxy = AllApiProxy();
      proxy.host = '${apiData.apiUrl}';
      proxy.dbName = '${apiData.serviceName}';
      proxy.dbHost = '${apiData.serviceIp}';
      proxy.dbPort = int.parse('${apiData.port}');
      proxy.dbUser = ApiProxyParameter.userLogin;
      proxy.dbPass = ApiProxyParameter.passLogin;
      // print('++++++++++${proxy.host}');
      // print('++++++++++${proxy.dbName}');
      // print('++++++++++${proxy.dbHost}');
      // print('++++++++++${proxy.dbPort}');
      // print('++++++++++${proxy.dbUser}');
      // print('++++++++++${proxy.dbPass}');

      var result = await proxy.oShopOrderReported(GetDataByShopBarcodeReq(
          shopOrderNo: dataSelect.shopOrderNo,
          relNo: dataSelect.relNo,
          seqNo: dataSelect.seqNo,
          operationNo: dataSelect.operationNo,
          productionLine: dataSelect.productionLine,
          reportedQty: double.parse(reportedQtyInput)));
      if (result.errorMessage != null) {
        Tdialog.errorDialog(
          context,
          'Error',
          "${result.errorMessage}",
          okButton(),
        );
      } else {
        // Tdialog.successDialog(
        //   context,
        //   'Information',
        //   'Reported Quantity has been confirmed.',
        //   okButton(),
        // );

        ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
            context, 'Reported Quantity has been confirmed.', heightScreen));
        Navigator.pop(context, 'OK');
        setState(() {
          _shopOrderNo.text = "";
          _partNo.text = '';
          _partName.text = '';
          _planMan.text = '';
          _planSetup.text = '';
          _operationNo.text = '';
          _lotSize.text = '';
          _operationDesc.text = '';
          _lineNo.text = '';
          _uom1.text = '';
          _uom2.text = '';
          _remainQty.text = '';
          _reportedQty.text = "";
        });
        FocusScope.of(context).requestFocus(_nodeshopOrderNo);
      }

      EasyLoading.dismiss();
    } on SocketException catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.message,
        okButton(),
      );
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Tdialog.errorDialog(
        context,
        'Error',
        e.toString(),
        okButton(),
      );
    }
  }
}
