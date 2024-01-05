import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

boxNewData(context, func, barcodeID, qtyPerBarcode) {
  final TextEditingController newInputBarcode = TextEditingController();
  newInputBarcode.text = qtyPerBarcode;
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
                child: TextField(
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
                    // value = Utility.formNum(
                    //   value.replaceAll(',', ''),
                    // );
                    value = value.replaceAll(',', '');
                    newInputBarcode.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(
                        offset: value.length,
                      ),
                    );
                  }),
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
                  Navigator.pop(context, 'Save');
                  String num = newInputBarcode.text.replaceAll(',','');
                  func(double.parse(num), barcodeID);
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

addBarcodeIDDialog(context, func) {
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
                  keyboardType: TextInputType.text,
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
