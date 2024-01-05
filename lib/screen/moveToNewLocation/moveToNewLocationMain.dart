import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/moveToNewLocation/fromLocation.dart';
import 'package:ogawa_nec/screen/moveToNewLocation/toLocation.dart';

class MoveToNewLocationMain extends StatefulWidget {
  const MoveToNewLocationMain({Key? key}) : super(key: key);

  @override
  State<MoveToNewLocationMain> createState() => _MoveToNewLocationMainState();
}

class _MoveToNewLocationMainState extends State<MoveToNewLocationMain> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Move part to other location'),
          leading: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    Scaffold.of(context).openDrawer();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("#4e73be"),
                    shape: BoxShape.rectangle,
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: const Text('FROM LOCATION'),
                ),
              ),
              Tab(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: const Text('TO LOCATION'),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FromLocation(),
            ToLocation(),
          ],
        ),
        drawer: const MenuSide(),
      ),
    );
  }
}
