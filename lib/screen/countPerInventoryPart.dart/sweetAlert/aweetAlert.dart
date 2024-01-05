import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

showAlertInfo(context, clearAll) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    // showCloseIcon: true,
    dialogType: DialogType.infoReverse,
    body: Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "Confirm Counted Qty",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 15,
          ),
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "Are you sure to confirm Counted qty?",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            )
          ]),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("CANCEL"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showAlertConfirm(context, clearAll);
                  },
                  child: const Text("ACCEPT"),
                ),
              )
            ],
          )
        ],
      ),
    ),
  ).show();
}

showAlertConfirm(context, clearAll) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    // showCloseIcon: true,
    dialogType: DialogType.success,
    body: Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "Infomation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 15,
          ),
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "Counted Quantity has been reported. ",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            )
          ]),
          const SizedBox(
            height: 15,
          ),
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "Please contact to approver to get approval.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            )
          ]),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    clearAll();
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  ).show();
}

showAlertError(context) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    // showCloseIcon: true,
    dialogType: DialogType.success,
    body: Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "Error",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]),
          const SizedBox(
            height: 15,
          ),
          Row(children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 20),
              child: const Text(
                "error",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            )
          ]),
          // const SizedBox(
          //   height: 15,
          // ),
          // Row(children: <Widget>[
          //   Container(
          //     padding: const EdgeInsets.only(left: 20),
          //     child: const Text(
          //       "Please contact to approver to get approval.",
          //       style: TextStyle(
          //         fontSize: 14,
          //       ),
          //     ),
          //   )
          // ]),
          const SizedBox(height: 50),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
