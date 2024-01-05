import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class WidgetStyle {
  //---------------
  static decorationForList() {
    return BoxDecoration(
      color: HexColor("#ffffff"),
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(
        Radius.circular(3.0),
      ),
      boxShadow: [
        BoxShadow(
          color: HexColor("#ffffff").withOpacity(0.9),
          offset: const Offset(-3.5, -3.5),
          blurRadius: 7.0,
          //spreadRadius: 0.5,
        ),
        BoxShadow(
          color: HexColor("#a6abbd").withOpacity(0.5),
          offset: const Offset(3.0, 3.0),
          blurRadius: 5.0,
          //spreadRadius: 0.5,
        ),
      ],
    );
  }

  //---------------
  static decorationForListOdd() {
    return BoxDecoration(
      color: HexColor("#ecf0f7"),
      shape: BoxShape.rectangle,
      borderRadius: const BorderRadius.all(
        Radius.circular(3.0),
      ),
      boxShadow: [
        BoxShadow(
          color: HexColor("#ffffff").withOpacity(0.9),
          offset: const Offset(-3.5, -3.5),
          blurRadius: 7.0,
          //spreadRadius: 0.5,
        ),
        BoxShadow(
          color: HexColor("#a6abbd").withOpacity(0.5),
          offset: const Offset(3.0, 3.0),
          blurRadius: 5.0,
          //spreadRadius: 0.5,
        ),
      ],
    );
  }
}
