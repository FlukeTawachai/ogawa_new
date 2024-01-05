import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ogawa_nec/dataBase/hiveClass.dart';
import 'package:ogawa_nec/screen/login/login.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ApiSettingsAdapter());
  Hive.registerAdapter(MenuLocationAdapter());
  Hive.registerAdapter(SearchDefaultAdapter());
  Hive.registerAdapter(CountReportBarcodeAdapter());
  Hive.registerAdapter(ConfirmDeliveryBarcodeAdapter());
  Hive.registerAdapter(ReportTransportTaskDBAdapter());
  Hive.registerAdapter(ReportMaterialRequisitionBarcodeAdapter());
  Hive.registerAdapter(PurchaseOrderReceiveBarcodeAdapter());
  Hive.registerAdapter(MoveToNewLocationRepAdapter());
  Hive.registerAdapter(LocationJFromAndToAdapter());
  await Hive.openBox<ApiSettings>('ApiSettings');
  await Hive.openBox<MenuLocation>('MenuLocation');
  await Hive.openBox("User");
  await Hive.openBox<SearchDefault>('SearchDefault');
  await Hive.openBox<CountReportBarcode>('CountReportBarcode');
  await Hive.openBox<ConfirmDeliveryBarcode>('ConfirmDeliveryBarcode');
  await Hive.openBox<ConfirmDeliveryBarcode>('ConfirmDeliveryContainerNo');
  await Hive.openBox<ReportTransportTaskDB>('ReportTransportTaskDB');
  await Hive.openBox<MoveToNewLocationRep>('MoveToNewLocationRep');
  await Hive.openBox<LocationJFromAndTo>('LocationJFromAndTo');
  await Hive.openBox<ReportMaterialRequisitionBarcode>(
      'ReportMaterialRequisitionBarcode');
  await Hive.openBox<PurchaseOrderReceiveBarcode>(
      'PurchaseOrderReceiveBarcode');
  await Hive.openBox<PurchaseOrderReceiveBarcode>('PurchaseOrderInvoiceNo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeColor(),
      home: const Login(),
      builder: EasyLoading.init(),
    );
  }

  themeColor() {
    return ThemeData(
      scaffoldBackgroundColor: HexColor('#ffffff'),
      appBarTheme: AppBarTheme(
        backgroundColor: HexColor('#4472c4'),
        elevation: 0.0,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
    );
  }
}
