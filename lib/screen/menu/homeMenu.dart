import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:ogawa_nec/api/class/dialogAll.dart';
import 'package:ogawa_nec/api/class/globalParam.dart';
import 'package:ogawa_nec/screen/countPerCountReport/countPerCountReport.dart';
import 'package:ogawa_nec/screen/lshopOrderReceiveWIP/lshopOrderReceiveWIPMain.dart';
import 'package:ogawa_nec/screen/menu/bottomBar.dart';
import 'package:ogawa_nec/screen/menu/sideMenu.dart';
import 'package:ogawa_nec/screen/countPerInventoryPart.dart/countPerInventoryPart.dart';
import 'package:ogawa_nec/screen/deliveryConfirmation/deliveryConfirmationMain.dart';
import 'package:ogawa_nec/screen/moveToNewLocation/moveToNewLocationMain.dart';
import 'package:ogawa_nec/screen/movefromIQCAQC/movefromIQCAQC.dart';
import 'package:ogawa_nec/screen/mshopOrderReceiveFG/mshopOrderReceiveFGMain.dart';
import 'package:ogawa_nec/screen/productionReceipt/productionReceipt.dart';
import 'package:ogawa_nec/screen/purchaseOrderReceive/purchaseOrderReceiveMain.dart';
import 'package:ogawa_nec/screen/reportMaterialRequisition/reportMaterialRequisition.dart';
import 'package:ogawa_nec/screen/reportTransportTask/reportTransportTask.dart';
import 'package:ogawa_nec/screen/shopOrderOperationReport/shopOrderOperationReport.dart';
import 'package:ogawa_nec/screen/stockPerLocation.dart/stockPerLocationNO.dart';
import 'package:ogawa_nec/screen/stockPerPart.dart/stockPerParth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  final List<DraggableGridItem> _listOfDraggableGridItem = [];

  late Box<MenuLocation> menuList;
  late Box<SearchDefault> searchDefaultList;
  List<SearchDefault> defaultSearch = [
    // CRN = Count Report No
    // PN = Part No
    SearchDefault(
        id: '${ApiProxyParameter.userLogin}_F',
        userID: ApiProxyParameter.userLogin,
        menuCode: 'F',
        menuName: 'Count per Count Report',
        searchBy: 'CRN'),
    //---------------------
    // TT = Transport Task id
    // EL = Expt List no
    // PN = Part No
    // SO = Shop Order No
    SearchDefault(
        id: '${ApiProxyParameter.userLogin}_G',
        userID: ApiProxyParameter.userLogin,
        menuCode: 'G',
        menuName: 'Report Transport Task',
        searchBy: 'TT'),
    //---------------------
    // SN = Shipment No
    // CN = Customer No
    // PN = Part No
    // IN = Invoice No
    SearchDefault(
        id: '${ApiProxyParameter.userLogin}_K',
        userID: ApiProxyParameter.userLogin,
        menuCode: 'K',
        menuName: 'Delivery Confirmation',
        searchBy: 'SN'),
    //---------------------
    // MN = Material Req No
    // CN = Customer No
    // PN = Part No
    // DN = Destination No
    SearchDefault(
        id: '${ApiProxyParameter.userLogin}_H',
        userID: ApiProxyParameter.userLogin,
        menuCode: 'H',
        menuName: 'Report Material Requisition',
        searchBy: 'MN'),
    //---------------------
    // PON = PO No
    // VN = Vender No
    // PN = Part No
    // LN = Lot No
    SearchDefault(
        id: '${ApiProxyParameter.userLogin}_I',
        userID: ApiProxyParameter.userLogin,
        menuCode: 'I',
        menuName: 'Move from IQC / AQC',
        searchBy: 'PON'),
    //---------------------
    // PON = Purchase Order No
    // SN = Supplier No
    // PN = Part No
    // SON = Shop order No
    SearchDefault(
        id: '${ApiProxyParameter.userLogin}_N',
        userID: ApiProxyParameter.userLogin,
        menuCode: 'N',
        menuName: 'Purchase Order Receive',
        searchBy: 'PON'),
  ];

  late List<MenuLocation> dataBaseMenu = [];
  List<SearchDefault> userSearchDefault = [];

  @override
  void initState() {
    super.initState();
    menuList = Hive.box('MenuLocation');
    searchDefaultList = Hive.box('SearchDefault');
    userSearchDefault = searchDefaultList.values.toList();
    if (userSearchDefault.isEmpty) {
      for (int i = 0; i < defaultSearch.length; i++) {
        searchDefaultList.put(defaultSearch[i].id, defaultSearch[i]);
      }
    } else {
      var check = false;
      for (int i = 0; i < userSearchDefault.length; i++) {
        if (userSearchDefault[i].userID == ApiProxyParameter.userLogin) {
          check = true;
        }
      }
      if (check == false) {
        for (int i = 0; i < defaultSearch.length; i++) {
          searchDefaultList.put(defaultSearch[i].id, defaultSearch[i]);
        }
      }
    }
    // delete search Default List
    // for (int i = 0; i < userSearchDefault.length; i++) {
    //   searchDefaultList.delete(userSearchDefault[i].key);
    // }

    // menuList.deleteFromDisk(); // delete MenuLocation table
    // var t = menuList.values.toList();
    // for (var item in t) {
    //   // menuList.delete(item.id);
    //   print('***************************${item.id},${item.seq}');
    // }

    var newList = menuList.values.toList();
    var test = newList
        .where((element) => element.userID == ApiProxyParameter.userLogin)
        .toList();
    for (var item in test) {
      if (item.userID == ApiProxyParameter.userLogin) {
        dataBaseMenu.add(item);
        // print('##############################');
        // print('*******************${item.id}');
        // print('*******************${item.seq}');
        // print('*******************${item.userID}');
      }
    }
    // print('----------------------${newList.length}');
    _generateImageData();
  }

  // // ignore: non_constant_identifier_names
  // static List<String> Listofimages = List.generate(2, (index) => images[index]);
  // // ignore: non_constant_identifier_names
  // static List<Widget> Listofwidgets = List.generate(
  //   Listofwidgets.length,
  //   (index) => Container(
  //     padding:
  //         const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
  //     child: Image.asset(
  //       Listofimages[index],
  //       fit: BoxFit.cover,
  //     ),
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      drawer: const MenuSide(),
      body: Center(
        child: DraggableGridViewBuilder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 3.15,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: _listOfDraggableGridItem,
          isOnlyLongPress: false,
          padding: const EdgeInsets.all(10),
          dragCompletion:
              (List<DraggableGridItem> list, int beforeIndex, int afterIndex) {
            // for (int i = 0; i < list.length; i++) {
            //   var aaa = list[beforeIndex];
            //   print('yyyyyyyyy ${aaa}');
            // }
            var aaa = list[beforeIndex];
            print('yyyyyyyyy ${aaa}');
            print('onDragAccept: $beforeIndex -> $afterIndex');
            MenuLocation oldData = MenuLocation();
            MenuLocation newData = MenuLocation();

            if (beforeIndex != afterIndex) {
              for (var item in dataBaseMenu) {
                if (item.seq == beforeIndex) {
                  oldData = item;
                } else if (item.seq == afterIndex) {
                  newData = item;
                }
              }

              for (var item in dataBaseMenu) {
                if (item.id == oldData.id) {
                  item.seq = afterIndex;
                  menuList.delete(item.key);
                  menuList.put('${item.id}', item);
                } else if (item.id == newData.id) {
                  item.seq = beforeIndex;
                  menuList.delete(item.key);
                  menuList.put('${item.id}', item);
                }
              }
              // for (var item in dataBaseMenu) {
              //   if (item.seq == beforeIndex) {
              //     // item.seq = afterIndex;
              //     newData = MenuLocation(
              //         id: '${item.id}',
              //         menuCode: item.menuCode,
              //         menuName: item.menuName,
              //         seq: afterIndex,
              //         color: item.color,
              //         img: item.img,
              //         userID: item.userID);
              //     menuList.put('${newData.id}', newData);
              //   } else if (item.seq == afterIndex) {
              //     // item.seq = beforeIndex;
              //     oldData = MenuLocation(
              //         id: '${item.id}',
              //         menuCode: item.menuCode,
              //         menuName: item.menuName,
              //         seq: beforeIndex,
              //         color: item.color,
              //         img: item.img,
              //         userID: item.userID);
              //     menuList.put('${oldData.id}', oldData);
              //   }
              // }
            }
          },
          dragFeedback: (List<DraggableGridItem> list, int index) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: list[index].child,
              width: 120,
              height: 120,
            );
          },
          dragPlaceHolder: (List<DraggableGridItem> list, int index) {
            return PlaceHolderWidget(
              child: Container(
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const BottomBarFooter(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).showSnackBar(Tdialog.successSnackbar(
      //         context, 'Success', height));
      //   },
      //   child: Icon(Icons.ac_unit),
      // ),
    );
  }

  Widget feedback(List<DraggableGridItem> list, int index) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(0),
      child: list[index].child,
      width: 50,
      height: 50,
    );
  }

  PlaceHolderWidget placeHolder(List<DraggableGridItem> list, int index) {
    return PlaceHolderWidget(
      child: Container(
        color: Colors.white,
      ),
    );
  }

  void _generateImageData() {
    var list = menuList.values.toList();
    List<String> userList = [];
    List<MenuLocation> dataList = [];
    for (var item in list) {
      if (item.userID == ApiProxyParameter.userLogin) {
        dataList.add(item);
      }
    }

    if (dataList.length > 0) {
      dataList.sort((a, b) => a.seq!.compareTo(b.seq!));
      for (var item in dataList) {
        _listOfDraggableGridItem.add(
          DraggableGridItem(
              child: Card(
                color: HexColor('${item.color}'),
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: HexColor('2056AE'), width: 1.0),
                    borderRadius: BorderRadius.circular(4.0)),
                child: InkWell(
                  onTap: () {
                    switch (item.menuCode) {
                      case "1":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const StockPerPart(
                                  autoFocusSearch: true,
                                )));
                        break;
                      case "2":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const StockPerLocation(
                                  autoFocusSearch: true,
                                )));
                        break;
                      case "3":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const PurchaseOrderReceiveMain(reset: true)));
                        break;
                      case "4":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ReportTransportTask(reset: true)));
                        break;
                      case "5":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const MoveToNewLocationMain()));
                        break;
                      case "6":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const MovefromIQCAQC(reset: true)));
                        break;
                      case "7":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ShopOrdernReceiveWIPMain()));
                        break;
                      case "8":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ShopOrderReceiveFGMain()));
                        break;
                      case "9":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const DeliveryConfirmationMain(reset: true)));
                        break;
                      case "10":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ReportMaterialRequisition(reset: true)));
                        break;
                      case "11":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CountPerCountReport(
                                  reset: true,
                                )));
                        break;
                      case "12":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const CountPerInventoryPart()));
                        break;
                      case "13":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ShopOrderOperationReport()));
                        break;
                      case "14":
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProductionReceipt()));
                        break;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              '${item.img}',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Container(
                          height: 30.0,
                          alignment: Alignment.topCenter,
                          child: Text(
                            '${item.menuName}',
                            textAlign: TextAlign.center,
                            // ignore: prefer_const_constructors
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                        // Container(
                        //   height: 30.0,
                        //   alignment: Alignment.topCenter,
                        //   child: Text(
                        //     '${item.menuName}',
                        //     textAlign: TextAlign.center,
                        //     // ignore: prefer_const_constructors
                        //     style: TextStyle(fontSize: 14.0),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              isDraggable: true),
        );
      }
    }
  }
}
