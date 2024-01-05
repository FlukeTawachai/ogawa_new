// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/api/proxy/apiAll_Tew.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/api/request/ShopOrderReceiveWIPReq.dart';
import 'package:ogawa_nec/screen/productionReceipt/productionReceiptApi.dart';

class ProductionReceipt extends StatefulWidget {
  const ProductionReceipt({Key? key}) : super(key: key);

  @override
  State<ProductionReceipt> createState() => _ProductionReceiptState();
}

class _ProductionReceiptState extends State<ProductionReceipt> {
  final FocusNode _nodePartno = FocusNode();
  final FocusNode _nodeLotNo1 = FocusNode();
  final FocusNode _nodeLotNo2 = FocusNode();
  final FocusNode _nodeReportDate = FocusNode();
  final FocusNode _nodeLocationNo = FocusNode();
  final FocusNode _nodeProductionLine = FocusNode();
  final FocusNode _nodesBackflush = FocusNode();
  final FocusNode _nodeReportedQty = FocusNode();
  final TextEditingController _partNo = TextEditingController();
  final TextEditingController _lotNo1 = TextEditingController();
  final TextEditingController _partName = TextEditingController();
  final TextEditingController _lotNo2 = TextEditingController();
  final TextEditingController _reportDate = TextEditingController();
  final TextEditingController _locationNo = TextEditingController();
  final TextEditingController _productionLine = TextEditingController();
  final TextEditingController _backflush = TextEditingController();
  final TextEditingController _reportedQty = TextEditingController();
  final TextEditingController _uom = TextEditingController();
  var _userName = TextEditingController();
  var _passWord = TextEditingController();
  var _StdPackSize = TextEditingController();
  var _NumLabel = TextEditingController();

  ProductionReceiptApi productionReceiptApi = ProductionReceiptApi();

  late Box<ApiSettings> database;
  List<ApiSettings> dataSetting = [];
  int charLength = 0;
  bool isLastBarcode = false;
  bool? isOverRemaining;
  bool ischeckbarcode = false;
  bool ischecklocationNo = false;
  // var disActivenodeLocationNo = false;
  // var disActivenodebarcode = false;
  double stdPackSize = 0.0;

  int countBarcodeID = 0;
  int countLocationNo = 0;

  bool disActivenodeBarcode = false;
  bool disActivenodelocationNo = false;
  bool disActivenodeQty = false;

  bool barcodeIdSuccess = false;
  bool locationNoSuccess = false;
  bool qtySuccess = false;
  bool disbutton = false;
  double heightScreen = 0;
  double widthScreen = 0.0;
  String username = "";
  String usernameCheck = "";
  String password = "";
  bool _isObscure = true;
  String schedOption = "";

  List<DropdownMenuItem<String>> dropdownSchedOption = [
    // const DropdownMenuItem(child: Text("Scheduled"), value: "Scheduled"),
    // const DropdownMenuItem(child: Text("Unscheduled"), value: "Unscheduled"),
  ];

  var isError = {
    'barcodeIdSuccess': 'Please check the information is correct.',
    'locationNoSuccess': 'Please check the information is correct.',
    'qtySuccess': 'Please check the information is correct.',
  };

  @override
  void initState() {
    super.initState();
    database = Hive.box('ApiSettings');

    getSchedOptionList();
  }

  getSchedOptionList() async {
    var dataList =
        await productionReceiptApi.pGetSchedOptionList(context, database);
    if (dataList.isNotEmpty) {
      setState(() {
        // dropdownSchedOption = [];
        schedOption = "${dataList[0].value}";
        dropdownSchedOption = dataList;
      });
    }
  }

  _onChangedreportedQty(String value) {
    try {
      if (value != '') {
        print(value);
        double txt =
            double.tryParse(value.replaceAll(',', '').replaceAll('-', '0')) ??
                0;
        _reportedQty.text = 0.toString();
        if (txt > 0) {
          if (isLastBarcode == false) {
            if (txt > stdPackSize) {
              if (isOverRemaining != true) {
                Tdialog.errorDialog(
                  context,
                  'Error',
                  'Max of Reported Qty ${stdPackSize.toString()}.',
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        _reportedQty.text = stdPackSize.toString();
                      });
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: HexColor("#5b9bd5"),
                      ),
                    ),
                  ),
                );
              }
            } else {
              // value = Utility.formNum(
              //   value.replaceAll(',', '').replaceAll('-', ''),
              // );
              _reportedQty.value = TextEditingValue(
                text: value,
                selection: TextSelection.collapsed(
                  offset: value.length,
                ),
              );
            }
          } else {
            // value = Utility.formNum(
            //   value.replaceAll(',', '').replaceAll('-', ''),
            // );
            _reportedQty.value = TextEditingValue(
              text: value,
              selection: TextSelection.collapsed(
                offset: value.length,
              ),
            );
          }
        } else {
          Tdialog.errorDialog(
            context,
            'Error',
            'Reported Qty is zero.',
            okButton(),
          );
        }
      } else {
        setState(() {
          _reportedQty.text = '0';
        });
        Tdialog.errorDialog(
          context,
          'Error',
          'Reported Qty is zero.',
          okButton(),
        );
      }
    } on Exception catch (e) {
      setState(() {
        _reportedQty.text = '1';
      });
    }
    setState(() {
      charLength = value.length;
    });
  }

  _resetData() {
    setState(() {
      // charLength = value.length;
      // _barcodeID.text = "";
      _partNo.text = "";
      _lotNo1.text = "";
      _partName.text = "";
      _lotNo2.text = "";
      _reportDate.text = "";
      _locationNo.text = "";
      _productionLine.text = "";
      schedOption = "";
      _backflush.text = "";
      _reportedQty.text = "";
      _uom.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    heightScreen = MediaQuery.of(context).size.height;
    widthScreen = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Shop Order Receive for WIP'),
        ),
        drawer: const MenuSide(),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: inputPartNo(),
                    ),
                    Expanded(
                      child: inputLotNo1(),
                    ),
                  ],
                ),
                showPartName(),
                Row(
                  children: [
                    Expanded(
                      child: inputLotNo2(),
                    ),
                    Expanded(
                      child: inputReportDate(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: inputLocationNo(),
                    ),
                    Expanded(
                      child: inputProductionLine(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: inputSchedOption(),
                    ),
                    Expanded(
                      child: inputBackflush(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: inputReportedQty(),
                    ),
                    showUom(),
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

  Widget inputPartNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: true,
        autofocus: true,
        focusNode: _nodePartno,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _partNo,
        style: const TextStyle(
          fontSize: 16,
        ),
        keyboardType: TextInputType.number,
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
          labelText: 'Barcode ID',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          counterText: '',
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _partNo.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      // disActivenodeLocationNo = false;
                      _resetData();
                      FocusScope.of(context).requestFocus(_nodePartno);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            var text = value;
            var textList = text.split("|");

            _partNo.text = textList[0];
            _partNo.selection = TextSelection.fromPosition(
                TextPosition(offset: _partNo.text.length));
          });
          barcodeIdSuccess = false;
          isError['barcodeIdSuccess'] = 'Please check the information again.';
        },
        onFieldSubmitted: (v) async {
          // await getDataByBarcodeIdWIP(v, true)
        },
      ),
    );
  }

  Widget inputLotNo1() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: true,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _lotNo1,
        focusNode: _nodeLotNo1,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Lot No',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#9dc3e6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
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
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _lotNo1.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _lotNo1.clear();
                      });
                      FocusScope.of(context).requestFocus(_nodeLotNo1);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _lotNo1.text = value;
            _lotNo1.selection = TextSelection.fromPosition(
                TextPosition(offset: _lotNo1.text.length));
          });
        },
      ),
    );
  }

  Widget showPartName() {
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

  Widget inputLotNo2() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _lotNo2,
        focusNode: _nodeLotNo2,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Lot No',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#9dc3e6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
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
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _lotNo2.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _lotNo2.clear();
                      });
                      FocusScope.of(context).requestFocus(_nodeLotNo2);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _lotNo2.text = value;
            _lotNo2.selection = TextSelection.fromPosition(
                TextPosition(offset: _lotNo1.text.length));
          });
        },
      ),
    );
  }

  Widget inputReportDate() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _reportDate,
        focusNode: _nodeReportDate,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Report Date',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#9dc3e6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
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
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _reportDate.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _reportDate.clear();
                      });
                      FocusScope.of(context).requestFocus(_nodeReportDate);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _reportDate.text = value;
            _reportDate.selection = TextSelection.fromPosition(
                TextPosition(offset: _reportDate.text.length));
          });
        },
      ),
    );
  }

  Widget inputLocationNo() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: true,
        //autofocus: true,
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
                      });
                      FocusScope.of(context).requestFocus(_nodeLocationNo);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _locationNo.text = value;
            _locationNo.selection = TextSelection.fromPosition(
                TextPosition(offset: _locationNo.text.length));
          });
        },
        onSubmitted: (v) async {
          // FocusScope.of(context).requestFocus(_nodeReportedQty);
          // await getLocationDescriptionWIP(_locationNo.text, true);
          // countBarcodeID = 0;
          // countLocationNo = 0;
        },
      ),
    );
  }

  Widget inputProductionLine() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: true,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _productionLine,
        focusNode: _nodeProductionLine,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: 'Production Line',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          hintText: '',
          hintStyle: TextStyle(
            color: HexColor("#9dc3e6"),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          counterText: '',
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
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _productionLine.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _productionLine.clear();
                      });
                      FocusScope.of(context).requestFocus(_nodeProductionLine);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _productionLine.text = value;
            _productionLine.selection = TextSelection.fromPosition(
                TextPosition(offset: _productionLine.text.length));
          });
        },
      ),
    );
  }

  Widget inputSchedOption() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: dropdownSchedOption.isNotEmpty
            ? DropdownButtonFormField(
                icon: const Visibility(
                    visible: true, child: Icon(LineAwesomeIcons.angle_down)),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                dropdownColor: Colors.white,
                value: schedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    schedOption = newValue!;
                  });
                },
                items: dropdownSchedOption)
            : Container(),
      ),
    );
  }

  Widget inputBackflush() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        enabled: true,
        //autofocus: true,
        focusNode: _nodesBackflush,
        enableInteractiveSelection: false,
        readOnly: false,
        controller: _backflush,
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
          labelText: 'Back flush',
          labelStyle: TextStyle(
            color: HexColor("#9dc3e6"),
          ),
          counterText: '',
          suffixIcon: Container(
            padding: const EdgeInsets.all(0),
            width: 15.0,
            height: 15.0,
            child: _backflush.text.isNotEmpty
                ? IconButton(
                    alignment: Alignment.centerLeft,
                    icon: Image.asset(
                      'assets/images/close.png',
                      scale: 1.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _backflush.clear();
                      });
                      FocusScope.of(context).requestFocus(_nodesBackflush);
                    },
                  )
                : null,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _backflush.text = value;
            _backflush.selection = TextSelection.fromPosition(
                TextPosition(offset: _backflush.text.length));
          });
        },
        onSubmitted: (v) async {
          // FocusScope.of(context).requestFocus(_nodeReportedQty);
          // await getLocationDescriptionWIP(_locationNo.text, true);
          // countBarcodeID = 0;
          // countLocationNo = 0;
        },
      ),
    );
  }

  Widget showUom() {
    return Container(
      width: 150.0,
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: false,
        //autofocus: true,
        enableInteractiveSelection: false,
        maxLength: 100,
        readOnly: true,
        controller: _uom,
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

  Widget inputReportedQty() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9.]*$')),
          ],
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
            labelText: 'Reported Qty',
            labelStyle: TextStyle(
              color: HexColor("#9dc3e6"),
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
                        });
                        FocusScope.of(context).requestFocus(_nodeReportedQty);
                        // disActivenodeBarcode = false;
                        // disActivenodelocationNo = false;
                      },
                    )
                  : null,
            ),
          ),
          onChanged: (value) {
            setState(() {
              var text = value;
              _reportedQty.text = text;
              _reportedQty.selection = TextSelection.fromPosition(
                  TextPosition(offset: _reportedQty.text.length));

              if ((double.tryParse(text) ?? 0.0) > 0.0) {
                qtySuccess = true;
              } else {
                qtySuccess = false;
                isError['qtySuccess'] = 'Please check the information again.';
              }
            });
          },
          onFieldSubmitted: (v) {}),
    );
  }

  Widget saveButton() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
        child: const Text(
          'Confirm Report Qty',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: HexColor('#4472c4'),
          minimumSize: const Size.fromHeight(
              50), // fromHeight use double.infinity as width and 40 is the height
        ),
        onPressed: () {
          // Tdialog.inputDialog(context, "Authorization", authorizationDetail(),
          //     acceptPassButton(), cancelAuthorizationButton(), () {
          //   Navigator.pop(context, 'Cancel');
          //   setState(() {
          //     _userName.text = "";
          //     _passWord.text = "";
          //   });
          // });

          Tdialog.inputDialog(context, "Barcode Label", barcodeLabelDetail(),
              acceptBarcodeLabelButton(), cancelBarcodeLabelButton(), () {
            Navigator.pop(context, 'Cancel');
            setState(() {
              _StdPackSize.text = "";
              _NumLabel.text = "";
            });
          });
        },
      ),
    );
  }

  Widget authorizationDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userNameField(),
        const SizedBox(
          height: 8,
        ),
        passwordField(),
      ],
    );
  }

  Widget barcodeLabelDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        stdPackSizeField(),
        const SizedBox(
          height: 8,
        ),
        numberOfLabelField(),
      ],
    );
  }

  Widget userNameField() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: widthScreen * 0.2,
              child: const Text(
                "UserName:",
                style: TextStyle(fontSize: 12),
              )),
          Container(
            width: widthScreen * 0.3,
            height: 54,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              controller: _userName,
              style: const TextStyle(
                fontSize: 14,
                // color: Colors.blue,
                // fontWeight: FontWeight.w600,
              ),
              // onSubmitted: (value) {
              //   setState(() {
              //     userName.text = value.toUpperCase();
              //   });
              // },
              onChanged: (value) {
                if (value != '' && value != null) {
                  setState(() {
                    usernameCheck = value;
                    // username = value;
                    _userName.text = value;
                    _userName.selection = TextSelection.fromPosition(
                        TextPosition(offset: _userName.text.length));
                  });
                }
              },
              decoration: InputDecoration(
                // suffixIcon: InkWell(
                //   onTap: () {
                //     setState(() {
                //       userName.text = '';
                //       usernameCheck = '';
                //     });
                //   },
                //   child: usernameCheck != ''
                //       ? Image.asset(
                //           'assets/images/close.png',
                //           height: 24,
                //           scale: 1,
                //         )
                //       : Container(
                //           width: 12,
                //         ),
                // ),
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                fillColor: Colors.grey,
                // hintText: "User Name",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                // labelText: 'User Name',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: widthScreen * 0.2,
            child: const Text(
              "Password:",
              style: TextStyle(fontSize: 14),
            )),
        Container(
          margin: const EdgeInsets.all(2.0),
          width: widthScreen * 0.3,
          height: 54,
          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: TextFormField(
            // textInputAction: TextInputAction.next,
            obscureText: _isObscure,
            obscuringCharacter: '●',
            // maxLength: 16,
            controller: _passWord,
            style: const TextStyle(
              fontSize: 12,
              // color: Colors.blue,
              // fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            decoration: InputDecoration(
              // suffixIcon: IconButton(
              //     icon: Icon(
              //         _isObscure ? Icons.visibility : Icons.visibility_off),
              //     onPressed: () {
              //       setState(() {
              //         _isObscure = !_isObscure;
              //       });
              //     }),
              focusColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(0.0),
              ),
              fillColor: Colors.grey,
              // hintText: "Password",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              // labelText: 'Password',
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget stdPackSizeField() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: widthScreen * 0.2,
              child: const Text(
                "Std Pack Size:",
                style: TextStyle(fontSize: 12),
              )),
          Container(
            width: widthScreen * 0.3,
            height: 54,
            // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              controller: _StdPackSize,
              style: const TextStyle(
                fontSize: 14,
                // color: Colors.blue,
                // fontWeight: FontWeight.w600,
              ),
              // onSubmitted: (value) {
              //   setState(() {
              //     userName.text = value.toUpperCase();
              //   });
              // },
              onChanged: (value) {
                if (value != '' && value != null) {
                  setState(() {
                    // username = value;
                    _StdPackSize.text = value;
                    _StdPackSize.selection = TextSelection.fromPosition(
                        TextPosition(offset: _StdPackSize.text.length));
                  });
                }
              },
              decoration: InputDecoration(
                focusColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(0.0),
                ),
                fillColor: Colors.grey,
                // hintText: "User Name",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                // labelText: 'User Name',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget numberOfLabelField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            width: widthScreen * 0.2,
            child: const Text(
              "Number Of Label:",
              style: TextStyle(fontSize: 14),
            )),
        Container(
          margin: const EdgeInsets.all(2.0),
          width: widthScreen * 0.3,
          height: 54,
          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: TextFormField(
            // textInputAction: TextInputAction.next,
            // obscureText: _isObscure,
            // obscuringCharacter: '●',
            // maxLength: 16,
            controller: _NumLabel,
            style: const TextStyle(
              fontSize: 12,
              // color: Colors.blue,
              // fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              setState(() {
                _NumLabel.text = value;
                _NumLabel.selection = TextSelection.fromPosition(
                    TextPosition(offset: _NumLabel.text.length));
              });
            },
            decoration: InputDecoration(
              // suffixIcon: IconButton(
              //     icon: Icon(
              //         _isObscure ? Icons.visibility : Icons.visibility_off),
              //     onPressed: () {
              //       setState(() {
              //         _isObscure = !_isObscure;
              //       });
              //     }),
              focusColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(0.0),
              ),
              fillColor: Colors.grey,
              // hintText: "Password",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
              // labelText: 'Password',
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget acceptPassButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, 'OK');
        setState(() {
          _userName.text = "";
          _passWord.text = "";
        });
      },
      child: Container(
        height: 54,
        width: widthScreen * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HexColor('#4472c4'),
        ),
        child: const Center(
            child: Text(
          "OK",
          style: TextStyle(fontSize: 14, color: Colors.white),
        )),
      ),
    );
  }

  Widget acceptBarcodeLabelButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, 'OK');
        setState(() {
          _StdPackSize.text = "";
          _NumLabel.text = "";
        });
      },
      child: Container(
        height: 54,
        width: widthScreen * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HexColor('#4472c4'),
        ),
        child: const Center(
            child: Text(
          "OK",
          style: TextStyle(fontSize: 14, color: Colors.white),
        )),
      ),
    );
  }

  Widget acceptButton(function_) {
    return TextButton(
      onPressed: () async {
        // if (_onChangedreportedQty(_reportedQty.text))
        Navigator.pop(context, 'ACCEPT');
        if (isOverRemaining == true) {
          if (isLastBarcode == true) {
            Tdialog.infoDialog(
              context,
              'Confirm reported Qty',
              'Reported qty is over than the remaining qty. Are you sure to report this qty?',
              acceptRemainTrue(() {}),
              cancelButton(),
            );
          }
        } else {
          double value = double.parse(
              _reportedQty.text.replaceAll(',', '').replaceAll('-', ''));
          if (stdPackSize == value) {
            if (await function_()) {
              // Tdialog.successDialog(
              //   context,
              //   'Information',
              //   'Reported Quantity has been confirmed.',
              //   TextButton(
              //     onPressed: () {
              //       Navigator.pop(context, 'OK');
              //       _barcodeID.text = '';
              //       _resetData();
              //       FocusScope.of(context).requestFocus(_nodeBarcodeID);
              //     },
              //     child: Text(
              //       'OK',
              //       style: TextStyle(
              //         color: HexColor("#5b9bd5"),
              //       ),
              //     ),
              //   ),
              // );

              ScaffoldMessenger.of(context).showSnackBar(
                  Tdialog.successSnackbar(context,
                      'Reported Quantity has been confirmed.', heightScreen));
              Navigator.pop(context, 'OK');
              _partNo.text = '';
              _resetData();
              FocusScope.of(context).requestFocus(_nodePartno);
            } else {
              FocusScope.of(context).requestFocus(_nodePartno);
            }
          } else {
            if (stdPackSize > value) {
              Tdialog.infoDialog(
                context,
                'Confirm reported Qty',
                'Reported qty is lower than the original qty. Are you sure to report this qty?',
                acceptRemainFalse(() {}),
                cancelButton(),
              );
            } else {
              if (isLastBarcode == true) {
                Tdialog.infoDialog(
                  context,
                  'Confirm reported Qty',
                  'Reported qty is over than the remaining qty. Are you sure to report this qty?',
                  acceptRemainTrue(() {}),
                  cancelButton(),
                );
              } else {
                Tdialog.errorDialog(
                  context,
                  'Error',
                  'Max of Reported Qty ${stdPackSize.toString()}.',
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        _reportedQty.text = stdPackSize.toString();
                      });
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: HexColor("#5b9bd5"),
                      ),
                    ),
                  ),
                );
              }
            }
          }
        }

        //_save();
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget acceptRemainFalse(function_) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'ACCEPT');
        if (await function_()) {
          // Tdialog.successDialog(
          //   context,
          //   'Information',
          //   'Reported Quantity has been confirmed. There is a new generated Barcode ID.',
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context, 'OK');
          //       _barcodeID.text = '';
          //       _resetData();
          //       FocusScope.of(context).requestFocus(_nodeBarcodeID);
          //     },
          //     child: Text(
          //       'OK',
          //       style: TextStyle(
          //         color: HexColor("#5b9bd5"),
          //       ),
          //     ),
          //   ),
          // );

          ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
              context,
              'Reported Quantity has been confirmed. There is a new generated Barcode ID.',
              heightScreen));
          Navigator.pop(context, 'OK');
          _partNo.text = '';
          _resetData();
          FocusScope.of(context).requestFocus(_nodePartno);
        } else {
          FocusScope.of(context).requestFocus(_nodePartno);
        }
        //_save();
      },
      child: Text(
        'ACCEPT',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget acceptRemainTrue(function_) {
    return TextButton(
      onPressed: () async {
        Navigator.pop(context, 'ACCEPT');
        if (await function_()) {
          // Tdialog.successDialog(
          //   context,
          //   'Information',
          //   'Reported Quantity has been confirmed.',
          //   TextButton(
          //     onPressed: () {
          //       Navigator.pop(context, 'OK');
          //       _barcodeID.text = '';
          //       _resetData();
          //       FocusScope.of(context).requestFocus(_nodeBarcodeID);
          //     },
          //     child: Text(
          //       'OK',
          //       style: TextStyle(
          //         color: HexColor("#5b9bd5"),
          //       ),
          //     ),
          //   ),
          // );

          ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
              context, 'Reported Quantity has been confirmed.', heightScreen));
          Navigator.pop(context, 'OK');
          _partNo.text = '';
          _resetData();
          FocusScope.of(context).requestFocus(_nodePartno);
        } else {
          FocusScope.of(context).requestFocus(_nodePartno);
        }
        //_save();
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
        Navigator.pop(context, 'CANCEL');
      },
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: HexColor("#5b9bd5"),
        ),
      ),
    );
  }

  Widget cancelAuthorizationButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, 'CANCEL');
        setState(() {
          _userName.text = "";
          _passWord.text = "";
        });
      },
      child: Container(
        height: 54,
        width: widthScreen * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HexColor('#4472c4'),
        ),
        child: const Center(
            child: Text(
          "CANCEL",
          style: TextStyle(fontSize: 14, color: Colors.white),
        )),
      ),
    );
  }

  Widget cancelBarcodeLabelButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context, 'CANCEL');
        setState(() {
          _StdPackSize.text = "";
          _NumLabel.text = "";
        });
      },
      child: Container(
        height: 54,
        width: widthScreen * 0.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: HexColor('#4472c4'),
        ),
        child: const Center(
            child: Text(
          "CANCEL",
          style: TextStyle(fontSize: 14, color: Colors.white),
        )),
      ),
    );
  }

  Widget okButton() {
    return TextButton(
      onPressed: () {
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
}
