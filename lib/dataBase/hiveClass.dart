import 'package:hive/hive.dart';
part 'hiveClass.g.dart';

@HiveType(typeId: 0)
class ApiSettings extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? baseName;
  @HiveField(2)
  String? apiUrl;
  @HiveField(3)
  String? serviceIp;
  @HiveField(4)
  String? serviceName;
  @HiveField(5)
  String? port;
  @HiveField(6)
  bool? setDefault;

  ApiSettings(
      {this.baseName,
      this.apiUrl,
      this.serviceIp,
      this.serviceName,
      this.port,
      this.id,
      this.setDefault});

  @override
  String toString() =>
      '$id,$baseName,$apiUrl,$serviceIp,$serviceName,$port'; // Just for print()
}

@HiveType(typeId: 1)
class MenuLocation extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? menuCode;
  @HiveField(2)
  String? menuName;
  @HiveField(3)
  int? seq;
  @HiveField(4)
  String? img;
  @HiveField(5)
  String? color;
  @HiveField(6)
  String? userID;

  MenuLocation(
      {this.id,
      this.menuCode,
      this.menuName,
      this.seq,
      this.img,
      this.color,
      this.userID});
}

@HiveType(typeId: 2)
class SearchDefault extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? userID;
  @HiveField(2)
  String? menuCode;
  @HiveField(3)
  String? menuName;
  @HiveField(4)
  String? searchBy;

  SearchDefault(
      {this.id, this.userID, this.menuCode, this.menuName, this.searchBy});
}

@HiveType(typeId: 3)
class CountReportBarcode extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? countReportNo;
  @HiveField(3)
  String? countReportSeq;
  @HiveField(4)
  int? barcodeId;
  @HiveField(5)
  String? partNo;
  @HiveField(6)
  String? partDesc;
  @HiveField(7)
  String? locationNo;
  @HiveField(8)
  String? locationDesc;
  @HiveField(9)
  String? lotNo;
  @HiveField(10)
  String? wdrNo;
  @HiveField(11)
  double? countQty;
  @HiveField(12)
  String? errorMessage;

  CountReportBarcode(
      {this.id,
      this.type,
      this.countReportNo,
      this.countReportSeq,
      this.barcodeId,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.countQty,
      this.errorMessage});
}

@HiveType(typeId: 4)
class ConfirmDeliveryBarcode extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? customerBarcode;
  @HiveField(3)
  String? shipmentNo;
  @HiveField(4)
  String? lineNo;
  @HiveField(5)
  String? customerNo;
  @HiveField(6)
  String? customerName;
  @HiveField(7)
  String? etdDate;
  @HiveField(8)
  String? invoiceNo;
  @HiveField(9)
  String? partNo;
  @HiveField(10)
  String? partDesc;
  @HiveField(11)
  String? itemNo;
  @HiveField(12)
  String? containerNo;
  @HiveField(13)
  double? noOfCarton;
  @HiveField(14)
  double? reservedQty;
  @HiveField(15)
  double? reportedQty;
  @HiveField(16)
  String? errorMessage;
  @HiveField(17)
  double? sps;

  ConfirmDeliveryBarcode(
      {this.id,
      this.type,
      this.customerBarcode,
      this.shipmentNo,
      this.lineNo,
      this.customerNo,
      this.customerName,
      this.etdDate,
      this.invoiceNo,
      this.partNo,
      this.partDesc,
      this.itemNo,
      this.containerNo,
      this.noOfCarton,
      this.reservedQty,
      this.reportedQty,
      this.errorMessage,
      this.sps});
}

@HiveType(typeId: 5)
class ReportTransportTaskDB extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  int? barcodeId;
  @HiveField(2)
  String? transportTaskId;
  @HiveField(3)
  String? transportTaskLineNo;
  @HiveField(4)
  String? shopOrderNo;
  @HiveField(5)
  String? expListNo;
  @HiveField(6)
  String? partNo;
  @HiveField(7)
  String? partDesc;
  @HiveField(8)
  String? lotNo;
  @HiveField(9)
  String? wdrNo;
  @HiveField(10)
  double? qty;
  @HiveField(11)
  double? reportedQty;
  @HiveField(12)
  double? remainingQty;
  @HiveField(13)
  String? uom;
  @HiveField(14)
  String? errorMessage;

  ReportTransportTaskDB(
      {this.id,
      this.barcodeId,
      this.transportTaskId,
      this.transportTaskLineNo,
      this.shopOrderNo,
      this.expListNo,
      this.partNo,
      this.partDesc,
      this.lotNo,
      this.wdrNo,
      this.qty,
      this.reportedQty,
      this.remainingQty,
      this.uom,
      this.errorMessage});
}

@HiveType(typeId: 6)
class ReportMaterialRequisitionBarcode extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? type;
  @HiveField(2)
  int? barcodeId;
  @HiveField(3)
  String? materialReqNo;
  @HiveField(4)
  String? lineNo;
  @HiveField(5)
  String? relNo;
  @HiveField(6)
  String? internalCustomerNo;
  @HiveField(7)
  String? internalCustomerName;
  @HiveField(8)
  String? internalDestinationNo;
  @HiveField(9)
  String? internalDestinationName;
  @HiveField(10)
  String? dueDate;
  @HiveField(11)
  double? noOfLine;
  @HiveField(12)
  String? partNo;
  @HiveField(13)
  String? partDesc;
  @HiveField(14)
  String? locationNo;
  @HiveField(15)
  String? locationDesc;
  @HiveField(16)
  String? lotNo;
  @HiveField(17)
  String? wdrNo;
  @HiveField(18)
  double? reservedQty;
  @HiveField(19)
  double? reportedQty;
  @HiveField(20)
  String? errorMessage;

  ReportMaterialRequisitionBarcode(
      {this.id,
      this.type,
      this.barcodeId,
      this.materialReqNo,
      this.lineNo,
      this.relNo,
      this.internalCustomerNo,
      this.internalCustomerName,
      this.internalDestinationNo,
      this.internalDestinationName,
      this.dueDate,
      this.noOfLine,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.reservedQty,
      this.reportedQty,
      this.errorMessage});
}

@HiveType(typeId: 7)
class PurchaseOrderReceiveBarcode extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  int? barcodeId;
  @HiveField(2)
  String? purchaseOrderNo;
  @HiveField(3)
  String? lineNo;
  @HiveField(4)
  String? relNo;
  @HiveField(5)
  String? supplierNo;
  @HiveField(6)
  String? supplierName;
  @HiveField(7)
  String? shopOrderNo;
  @HiveField(8)
  String? partNo;
  @HiveField(9)
  String? partDesc;
  @HiveField(10)
  String? lotNo;
  @HiveField(11)
  String? wdrNo;
  @HiveField(12)
  double? purchOrderQty;
  @HiveField(13)
  double? purchReceivedQty;
  @HiveField(14)
  String? purchUom;
  @HiveField(15)
  double? invOrderQty;
  @HiveField(16)
  double? invReceivedQty;
  @HiveField(17)
  String? invUom;
  @HiveField(18)
  double? conversionFactor;
  @HiveField(19)
  String? invoiceNo;
  @HiveField(20)
  String? actualArrivalDate;
  @HiveField(21)
  String? errorMessage;
  @HiveField(22)
  String? sequenceId;

  PurchaseOrderReceiveBarcode(
      {this.id,
      this.barcodeId,
      this.purchaseOrderNo,
      this.lineNo,
      this.relNo,
      this.supplierNo,
      this.supplierName,
      this.shopOrderNo,
      this.partNo,
      this.partDesc,
      this.lotNo,
      this.wdrNo,
      this.purchOrderQty,
      this.purchReceivedQty,
      this.purchUom,
      this.invOrderQty,
      this.invReceivedQty,
      this.invUom,
      this.conversionFactor,
      this.invoiceNo,
      this.actualArrivalDate,
      this.errorMessage,
      this.sequenceId});
}

@HiveType(typeId: 8)
class MoveToNewLocationRep extends HiveObject {
  @HiveField(0)
  int? barcodeId;
  @HiveField(1)
  String? partNo;
  @HiveField(2)
  String? partDesc;
  @HiveField(3)
  String? fromLocation;
  @HiveField(4)
  String? toLocation;
  @HiveField(5)
  String? lotNo;
  @HiveField(6)
  String? wdrNo;
  @HiveField(7)
  double? movedQty;
  @HiveField(8)
  String? errorMessage;
  @HiveField(9)
  String? userLogin;
  @HiveField(10)
  String? classBox;

  MoveToNewLocationRep(
      {this.barcodeId,
      this.partNo,
      this.partDesc,
      this.fromLocation,
      this.toLocation,
      this.lotNo,
      this.wdrNo,
      this.movedQty,
      this.errorMessage,
      this.userLogin,
      this.classBox});
}

@HiveType(typeId: 9)
class LocationJFromAndTo extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? locationFrom;
  @HiveField(2)
  String? classBox;
  @HiveField(3)
  String? userLogin;

  LocationJFromAndTo(
      {this.id, this.locationFrom, this.classBox, this.userLogin});
}
