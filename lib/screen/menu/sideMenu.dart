import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/screen/login/login.dart';
import 'package:ogawa_nec/screen/menu/homeMenu.dart';
import '../../globalParamitor.dart';

class MenuSide extends StatefulWidget {
  const MenuSide({Key? key}) : super(key: key);

  @override
  State<MenuSide> createState() => _MenuSideState();
}

class _MenuSideState extends State<MenuSide> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
          body: Column(
            children: [
              DrawerHeader(
                padding: const EdgeInsets.only(),
                child: Container(
                  color: HexColor("#4472c4"),
                  padding: const EdgeInsets.only(),
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logo-1.png",
                    height: 100,
                  ),
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeMenu(),
                    ),
                  );
                },
                title: const Text(
                  'Main Menu',
                  style: TextStyle(fontSize: 16.0),
                ),
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
              ),
              const Divider(),
            ],
          ),
          bottomNavigationBar: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(),
            height: 100.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(),
                  child: Text(
                    GlobalParam.appVersion,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  //leading: Container(),
                ),
                const Divider(),
                ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  onTap: () {
                    Tdialog.infoDialog(
                      context,
                      'Are you sure to logout ?',
                      '',
                      acceptButton(),
                      cancelButton(),
                    );
                  },
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget acceptButton() {
    return TextButton(
      onPressed: () {
        //go to function.....
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const Login()),
          (_) => false,
        );
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
}
