import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/api/proxy/apiAll.dart';
import 'package:ogawa_nec/api/request/shopOrderReceiveReq.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';

class ShopOrderReceiveFGMain extends StatefulWidget {
  const ShopOrderReceiveFGMain({Key? key}) : super(key: key);

  @override
  State<ShopOrderReceiveFGMain> createState() => _ShopOrderReceiveFGMainState();
}

class _ShopOrderReceiveFGMainState extends State<ShopOrderReceiveFGMain> {
  final FocusNode _nodeshopOrderNo = FocusNode();

  final FocusNode _nodecustomerBarcode = FocusNode();
  final FocusNode _nodeLocationNo = FocusNode();
  final FocusNode _nodeReportedQty = FocusNode();
  final TextEditingController _shopOrderNo = TextEditingController();
  final TextEditingController _customerBarcode = TextEditingController();
  final TextEditingController _partNo = TextEditingController();
  final TextEditingController _partName = TextEditingController();
  final TextEditingController _shopOrdNo = TextEditingController();
  final TextEditingController _relNo = TextEditingController();
  final TextEditingController _seqNo = TextEditingController();
  final TextEditingController _lotNo = TextEditingController();
  final TextEditingController _fgNo = TextEditingController();
  final TextEditingController _locationNo = TextEditingController();
  final TextEditingController _parentOrder = TextEditingController();
  final TextEditingController _locationDesc = TextEditingController();
  final TextEditingController _remainQty = TextEditingController();
  final TextEditingController _uom1 = TextEditingController();
  final TextEditingController _uom2 = TextEditingController();
  final TextEditingController _reportedQty = TextEditingController();
  List<ApiSettings> dataSetting = [];
  late Box<ApiSettings> database;
  String reportedQtyInput = '0';
  bool isError = true;
  String errorMessage = "";

  int charLength = 0;
  double heightScreen = 0;
//--
  _onChanged(String value) {
    setState(() {
      charLength = value.length;
      _partNo.text = 'JV614';
      _partName.text = 'SPRAY 2nd CAR BODY';
      _remainQty.text = Utility.formatNumber(3000.00);
    });
  }

  _onChangedCusBarcode(String value) {
    setState(() {
      charLength = value.length;
    });
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
      reportedQtyInput = value;
    });
  }

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
          title: const Text('Shop Order Receive for FG'),
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
                      child: customerBarcode(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: partNo(),
                    ),
                    Expanded(
                      child: lotNo(),
                    ),
                  ],
                ),
                partName(),
                Row(
                  children: [
                    Expanded(
                      child: shopOrdNo(),
                    ),
                    Expanded(
                      child: relNo(),
                    ),
                    Expanded(
                      child: seqNo(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: locationNo(),
                    ),
                    Expanded(
                      child: parentOrder(),
                    ),
                  ],
                ),
                locationDesc(),
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
          getDataByShopBarcode(_shopOrderNo.text);
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
                          _lotNo.text = '';
                          _parentOrder.text = '';
                          _shopOrdNo.text = '';
                          _relNo.text = '';
                          _seqNo.text = '';
                          _uom1.text = '';
                          _uom2.text = '';
                          _locationNo.text = '';
                          _locationDesc.text = '';
                          _customerBarcode.text = "";
                          _reportedQty.text = "";
                        });
                        FocusScope.of(context).requestFocus(_nodeshopOrderNo);
                      },
                    )
                  : null,
            ),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _partNo.text = '';
                _shopOrderNo.text = value;
                _shopOrderNo.selection = TextSelection.fromPosition(
                    TextPosition(offset: _shopOrderNo.text.length));
                // _partName.text = 'SPRAY 2nd CAR BODY';
                _remainQty.text = Utility.formatNumber(0);
                _lotNo.text = '';
                isError = true;
              });
            }
          },
          onSubmitted: (value) {
            // getDataByShopBarcode(value);
          },
        ),
      ),
    );
  }

  Widget customerBarcode() {
    return Focus(
      onFocusChange: (value) {
        if (value == false && _customerBarcode.text != "") {
          getDataByCustomerBarcode(_customerBarcode.text);
        }
      },
      child: Container(
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
              isError = true;
            });
          },
          onSubmitted: (value) {
            // getDataByCustomerBarcode(value);
          },
        ),
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

  Widget shopOrdNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _shopOrdNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Shop Ord No',
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

  Widget relNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _relNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Rel No',
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

  Widget seqNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _seqNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Seq No',
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

  Widget lotNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        // autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        // readOnly: true,
        controller: _lotNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Lot No',
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

  Widget fgNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _fgNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'FG No',
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

  Widget locationNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: true,
        // autofocus: true,
        focusNode: _nodeLocationNo,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _locationNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: const EdgeInsets.only(top: 15, left: 15.0),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#9dc3e6"))),
          enabledBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: HexColor("#9dc3e6"),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            //borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: HexColor("#9dc3e6"),
              width: 2.0,
            ),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#a8a8a8"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          labelText: 'Location No',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          counterText: '',
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _locationNo.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _locationNo.clear();
                        _locationDesc.text = '';
                      });
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              _locationDesc.text = '';
            });
          }
        },
        onSubmitted: (value) {
          getLocationDescription(value);
        },
      ),
    );
  }

  Widget parentOrder() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _parentOrder,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Std. Pack Size',
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

  Widget locationDesc() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        // autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        // readOnly: true,
        controller: _locationDesc,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Location Desc',
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
            }
          }
        },
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

  getDataByShopBarcode(String shopBarcode) async {
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

      var result = await proxy.getDataByShopBarcode(ShopOrderReceiveReq(
          shopBarcode: shopBarcode,
          remainingQty: 0,
          reportedQty: 0,
          stdPackSize: 0));
      if (result.errorMessage == null) {
        setState(() {
          charLength = shopBarcode.length;
          _shopOrderNo.text = shopBarcode;
          _partNo.text = '${result.partNo}';
          _partName.text = '${result.partDesc}';
          _remainQty.text = Utility.formatNumber(result.remainingQty!);
          _lotNo.text = '${result.lotNo}';
          _parentOrder.text = '${result.stdPackSize}';
          _shopOrdNo.text = '${result.shopOrderNo}';
          _relNo.text = '${result.relNo}';
          _seqNo.text = '${result.seqNo}';
          _uom1.text = '${result.uom}';
          _uom2.text = '${result.uom}';
          _locationNo.text = '${result.locationNo}';
          isError = false;
        });
        FocusScope.of(context).requestFocus(_nodecustomerBarcode);
        getLocationDescription('${result.locationNo}');
      } else {
        var text = '${result.errorMessage}';
        var textList = text.split("|");
        Tdialog.errorDialog(
          context,
          'Error',
          textList[0],
          okButton(),
        );
        setState(() {
          charLength = shopBarcode.length;
          _shopOrderNo.text = '';
          _partNo.text = '';
          _partName.text = '';
          _remainQty.text = '';
          _lotNo.text = '';
          _parentOrder.text = '';
          _shopOrdNo.text = '';
          _relNo.text = '';
          _seqNo.text = '';
          _uom1.text = '';
          _uom2.text = '';
          _locationNo.text = '';
          _locationDesc.text = '';
          _customerBarcode.text = '';
          isError = true;
          errorMessage = "${result.errorMessage}";
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

  getDataByCustomerBarcode(String customerBarcode) async {
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

      var result = await proxy.getDataByCustomerBarcode(ShopOrderReceiveReq(
          customerBarcode: customerBarcode,
          partNo: _partNo.text,
          remainingQty: 0,
          reportedQty: 0,
          stdPackSize: 0));
      if (result.errorMessage == null) {
        setState(() {
          charLength = customerBarcode.length;
          _customerBarcode.text = customerBarcode;
          _reportedQty.text = '${result.reportedQty}';
          reportedQtyInput = '${result.reportedQty}';
          _parentOrder.text = '${result.stdPackSize}';
          isError = false;
        });
        FocusScope.of(context).requestFocus(_nodeReportedQty);
      } else {
        Tdialog.errorDialog(
          context,
          'Error',
          '${result.errorMessage}',
          okButton(),
        );
        setState(() {
          _customerBarcode.clear();
          isError = true;
          errorMessage = "${result.errorMessage}";
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

  getLocationDescription(String locationNo) async {
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

      var result = await proxy.getLocationDescription(ShopOrderReceiveReq(
          locationNo: locationNo,
          remainingQty: 0,
          reportedQty: 0,
          stdPackSize: 0));
      if (result.errorMessage == null) {
        setState(() {
          charLength = locationNo.length;
          _locationNo.text = locationNo;
          _locationDesc.text = '${result.locationDesc}';
          isError = false;
        });
        // FocusScope.of(context).requestFocus(_nodeReportedQty);
      } else {
        var text = '${result.errorMessage}';
        var textList = text.split("|");
        Tdialog.errorDialog(
          context,
          'Error',
          textList[0],
          okButton(),
        );

        setState(() {
          isError = true;
          errorMessage = "${result.errorMessage}";
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

  shopOrderReceived() async {
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

      var result = await proxy.shopOrderReceived(ShopOrderReceiveReq(
          customerBarcode: _customerBarcode.text,
          shopOrderNo: _shopOrdNo.text,
          relNo: _relNo.text,
          seqNo: _seqNo.text,
          locationNo: _locationNo.text,
          remainingQty: 0,
          reportedQty: double.parse(reportedQtyInput),
          stdPackSize: 0));
      if (result.errorMessage == null) {
        // Tdialog.successDialog(context, 'Information',
        //     'Reported Quantity has been confirmed.', okButton());
        ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
            context, 'Reported Quantity has been confirmed.', heightScreen));
        setState(() {
          _shopOrderNo.clear();
          _partNo.clear();
          _partName.clear();
          _lotNo.clear();
          _fgNo.clear();
          _locationNo.clear();
          _parentOrder.clear();
          _locationDesc.clear();
          _remainQty.clear();
          _uom1.clear();
          _uom2.clear();
          _reportedQty.clear();
          _customerBarcode.clear();
          _shopOrdNo.clear();
          _relNo.clear();
          _seqNo.clear();
        });
        FocusScope.of(context).requestFocus(_nodeshopOrderNo);
      } else {
        var text = '${result.errorMessage}';
        var textList = text.split("|");
        Tdialog.errorDialog(
          context,
          'Error',
          textList[0],
          okButton(),
        );
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

  Widget actionSave() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context, 'OK');
        if (_shopOrdNo.text == '') {
          Tdialog.errorDialog(
            context,
            'Error',
            'Shop Order No is entity.',
            okButton(),
          );
        } else {
          if (_customerBarcode.text == '') {
            Tdialog.errorDialog(
              context,
              'Error',
              'Customer Barcode is entity.',
              okButton(),
            );
          } else {
            if (_locationNo.text == '') {
              Tdialog.errorDialog(
                context,
                'Error',
                'Location No is entity.',
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
              } else {
                shopOrderReceived();
              }
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
}
