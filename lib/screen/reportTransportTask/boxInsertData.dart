import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ogawa_nec/api/class/utility.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/globalParamitor.dart';
import 'package:ogawa_nec/screen/reportTransportTask/calendarDialog.dart';
import 'package:ogawa_nec/screen/reportTransportTask/utils.dart';
import 'package:table_calendar/table_calendar.dart';

boxNewData(context, func, barcodeID, qtyPerBarcode, i) {
  final TextEditingController newInputBarcode = TextEditingController();
  newInputBarcode.text = qtyPerBarcode;
  String newValue =
      double.parse(qtyPerBarcode.replaceAll('-', '').replaceAll(',', ''))
          .toString();
  bool checkformatnum = false;
  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
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
          top: 5.0,
          bottom: 10.0,
        ),
        child: Container(
          height: 70.0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'New Quantity',
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
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                height: 40.0,
                decoration: BoxDecoration(
                  border: const Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                  color: HexColor("#d9e1f2"),
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  controller: newInputBarcode,
                  autofocus: true,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    isDense: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: ((value) {
                    var txt = (value.isNotEmpty
                            ? value
                            : (newInputBarcode.text.isNotEmpty
                                ? newInputBarcode.text
                                : ''))
                        .replaceAll('-', '')
                        .replaceAll(',', '');

                    // newValue = double.parse((value.isNotEmpty ? value : '0'));
                    // newInputBarcode.value = TextEditingValue(
                    //   text: value,
                    //   selection: TextSelection.collapsed(
                    //     offset: value.length,
                    //   ),
                    // );
                    if (txt.isNotEmpty) {
                      try {
                        if (double.parse(txt) > 0) {
                          newValue = double.parse(txt).toString();
                          // txt = Utility.formNum(txt);
                          newInputBarcode.value = TextEditingValue(
                            text: txt,
                            selection: TextSelection.collapsed(
                              offset: txt.length,
                            ),
                          );
                          checkformatnum = true;
                        } else {
                          checkformatnum = true;
                          newValue = txt;
                        }
                      } on Exception catch (_) {
                        checkformatnum = false;
                        newValue = txt;
                      }
                    } else {
                      checkformatnum = true;
                      newValue = double.parse('0').toString();
                    }
                  }),
                  onFieldSubmitted: (value) {
                    try {
                      var txt = (value.isNotEmpty
                              ? value
                              : (newInputBarcode.text.isNotEmpty
                                  ? newInputBarcode.text
                                  : ''))
                          .replaceAll('-', '')
                          .replaceAll(',', '');
                      if (double.parse(txt) > 0) {
                        newValue = double.parse(txt).toString();
                        checkformatnum = true;
                      } else {
                        checkformatnum = true;
                      }
                    } on Exception catch (_) {
                      checkformatnum = false;
                    }
                    if (!checkformatnum) {
                      Tdialog.errorDialog(
                        context,
                        'Error',
                        'The numerical format is incorrect.',
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: HexColor("#5b9bd5"),
                            ),
                          ),
                        ),
                      );
                    } else if (double.parse(newValue) <= 0) {
                      Tdialog.errorDialog(
                        context,
                        'Error',
                        'Reported Qty is zero.',
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: HexColor("#5b9bd5"),
                            ),
                          ),
                        ),
                      );
                      newInputBarcode.text = '1';
                      newValue = double.parse('1').toString();
                    } else {
                      Navigator.pop(context, 'Save');
                      func(newValue, barcodeID, i);
                    }
                  },
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
                  newInputBarcode.clear();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  try {
                    var txt = (newInputBarcode.text.isNotEmpty
                            ? newInputBarcode.text
                            : '')
                        .replaceAll('-', '')
                        .replaceAll(',', '');
                    if (double.parse(txt) > 0) {
                      newValue = double.parse(txt).toString();
                      checkformatnum = true;
                    } else {
                      checkformatnum = true;
                    }
                  } on Exception catch (_) {
                    checkformatnum = false;
                  }
                  if (!checkformatnum) {
                    Tdialog.errorDialog(
                      context,
                      'Error',
                      'The numerical format is incorrect.',
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: HexColor("#5b9bd5"),
                          ),
                        ),
                      ),
                    );
                  } else if (double.parse(newValue) <= 0) {
                    Tdialog.errorDialog(
                      context,
                      'Error',
                      'Reported Qty is zero.',
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: HexColor("#5b9bd5"),
                          ),
                        ),
                      ),
                    );
                    newInputBarcode.text = '1';
                    newValue = double.parse('1').toString();
                  } else {
                    Navigator.pop(context, 'Save');
                    func(newValue, barcodeID, i);
                  }
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

addBarcodeIDDialog(context, Function func) {
  final TextEditingController searchOptionNo = TextEditingController();
  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
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
          top: 5.0,
          bottom: 10.0,
        ),
        child: Container(
          height: 70.0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'Barcode ID',
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
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                height: 40.0,
                decoration: BoxDecoration(
                  border: const Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                  color: HexColor("#d9e1f2"),
                ),
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  controller: searchOptionNo,
                  autofocus: true,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    isDense: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    if (value != '') {
                      var text = value;
                      var textList = text.split("|");

                      searchOptionNo.text = textList[0];
                      searchOptionNo.selection = TextSelection.fromPosition(
                          TextPosition(offset: searchOptionNo.text.length));
                    }
                  },
                  onFieldSubmitted: (value) {
                    Navigator.pop(context, 'Save');
                    func(searchOptionNo.text);
                  },
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
                  searchOptionNo.clear();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Save');
                  func(searchOptionNo.text);
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

appliedDateDialog(context, Function func, DateTime daySave, bool isSave) {
  final TextEditingController searchOptionNo = TextEditingController();
  var dateSelected = DateFormat('d-MMM-yy')
      .format(GlobalParam.reportTransportTaskAppliedDaySave);

  if (isSave == true) {
    dateSelected = DateFormat('d-MMM-yy').format(daySave);
  }

  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
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
          top: 5.0,
          bottom: 10.0,
        ),
        child: Container(
          height: 70.0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10.0),
                child: const Text(
                  'Applied Date',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context, 'SET APPLIED DATE');
                  calendarDialog(context, func);
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 40.0,
                  decoration: BoxDecoration(
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                    color: HexColor("#d9e1f2"),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: Text(
                      dateSelected,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
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
                  searchOptionNo.clear();
                  GlobalParam.reportTransportTaskAppliedDay = DateTime.now();
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'Save');
                  func(searchOptionNo.text);
                  if (isSave == true) {
                    GlobalParam.reportTransportTaskAppliedDaySave = daySave;
                  }
                },
                child: const Text('SAVE'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

calendarDialog(context, Function func) {
  return showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      // shape: RoundedRectangleBorder(
      //   side: BorderSide(
      //     color: HexColor("#5b9bd5"),
      //   ),
      //   borderRadius: BorderRadius.circular(5),
      // ),
      content: Container(
        //height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(
          bottom: 10.0,
        ),
        child: Container(
            height: 480.0,
            alignment: Alignment.centerLeft,
            child: TableBasicsExample()),
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
                  appliedDateDialog(context, func, DateTime.now(), false);
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  appliedDateDialog(context, func,
                      GlobalParam.reportTransportTaskAppliedDay, true);
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
