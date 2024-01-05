import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/globalParamitor.dart';

class BottomBarFooter extends StatelessWidget {
  const BottomBarFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('2056AE'),
      height: 36,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Row(
          children: [
            Text(
              'Database : ${ApiProxyParameter.dataBaseSelect}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              'User Name: ${ApiProxyParameter.userLogin}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
