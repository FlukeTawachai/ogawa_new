// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiSettingsAdapter extends TypeAdapter<ApiSettings> {
  @override
  final int typeId = 0;

  @override
  ApiSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiSettings(
      baseName: fields[1] as String?,
      apiUrl: fields[2] as String?,
      serviceIp: fields[3] as String?,
      serviceName: fields[4] as String?,
      port: fields[5] as String?,
      id: fields[0] as String?,
      setDefault: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ApiSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.baseName)
      ..writeByte(2)
      ..write(obj.apiUrl)
      ..writeByte(3)
      ..write(obj.serviceIp)
      ..writeByte(4)
      ..write(obj.serviceName)
      ..writeByte(5)
      ..write(obj.port)
      ..writeByte(6)
      ..write(obj.setDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MenuLocationAdapter extends TypeAdapter<MenuLocation> {
  @override
  final int typeId = 1;

  @override
  MenuLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuLocation(
      id: fields[0] as String?,
      menuCode: fields[1] as String?,
      menuName: fields[2] as String?,
      seq: fields[3] as int?,
      img: fields[4] as String?,
      color: fields[5] as String?,
      userID: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MenuLocation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.menuCode)
      ..writeByte(2)
      ..write(obj.menuName)
      ..writeByte(3)
      ..write(obj.seq)
      ..writeByte(4)
      ..write(obj.img)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.userID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SearchDefaultAdapter extends TypeAdapter<SearchDefault> {
  @override
  final int typeId = 2;

  @override
  SearchDefault read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchDefault(
      id: fields[0] as String?,
      userID: fields[1] as String?,
      menuCode: fields[2] as String?,
      menuName: fields[3] as String?,
      searchBy: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchDefault obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userID)
      ..writeByte(2)
      ..write(obj.menuCode)
      ..writeByte(3)
      ..write(obj.menuName)
      ..writeByte(4)
      ..write(obj.searchBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchDefaultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CountReportBarcodeAdapter extends TypeAdapter<CountReportBarcode> {
  @override
  final int typeId = 3;

  @override
  CountReportBarcode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountReportBarcode(
      id: fields[0] as String?,
      type: fields[1] as String?,
      countReportNo: fields[2] as String?,
      countReportSeq: fields[3] as String?,
      barcodeId: fields[4] as int?,
      partNo: fields[5] as String?,
      partDesc: fields[6] as String?,
      locationNo: fields[7] as String?,
      locationDesc: fields[8] as String?,
      lotNo: fields[9] as String?,
      wdrNo: fields[10] as String?,
      countQty: fields[11] as double?,
      errorMessage: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CountReportBarcode obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.countReportNo)
      ..writeByte(3)
      ..write(obj.countReportSeq)
      ..writeByte(4)
      ..write(obj.barcodeId)
      ..writeByte(5)
      ..write(obj.partNo)
      ..writeByte(6)
      ..write(obj.partDesc)
      ..writeByte(7)
      ..write(obj.locationNo)
      ..writeByte(8)
      ..write(obj.locationDesc)
      ..writeByte(9)
      ..write(obj.lotNo)
      ..writeByte(10)
      ..write(obj.wdrNo)
      ..writeByte(11)
      ..write(obj.countQty)
      ..writeByte(12)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountReportBarcodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConfirmDeliveryBarcodeAdapter
    extends TypeAdapter<ConfirmDeliveryBarcode> {
  @override
  final int typeId = 4;

  @override
  ConfirmDeliveryBarcode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfirmDeliveryBarcode(
      id: fields[0] as String?,
      type: fields[1] as String?,
      customerBarcode: fields[2] as String?,
      shipmentNo: fields[3] as String?,
      lineNo: fields[4] as String?,
      customerNo: fields[5] as String?,
      customerName: fields[6] as String?,
      etdDate: fields[7] as String?,
      invoiceNo: fields[8] as String?,
      partNo: fields[9] as String?,
      partDesc: fields[10] as String?,
      itemNo: fields[11] as String?,
      containerNo: fields[12] as String?,
      noOfCarton: fields[13] as double?,
      reservedQty: fields[14] as double?,
      reportedQty: fields[15] as double?,
      errorMessage: fields[16] as String?,
      sps: fields[17] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ConfirmDeliveryBarcode obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.customerBarcode)
      ..writeByte(3)
      ..write(obj.shipmentNo)
      ..writeByte(4)
      ..write(obj.lineNo)
      ..writeByte(5)
      ..write(obj.customerNo)
      ..writeByte(6)
      ..write(obj.customerName)
      ..writeByte(7)
      ..write(obj.etdDate)
      ..writeByte(8)
      ..write(obj.invoiceNo)
      ..writeByte(9)
      ..write(obj.partNo)
      ..writeByte(10)
      ..write(obj.partDesc)
      ..writeByte(11)
      ..write(obj.itemNo)
      ..writeByte(12)
      ..write(obj.containerNo)
      ..writeByte(13)
      ..write(obj.noOfCarton)
      ..writeByte(14)
      ..write(obj.reservedQty)
      ..writeByte(15)
      ..write(obj.reportedQty)
      ..writeByte(16)
      ..write(obj.errorMessage)
      ..writeByte(17)
      ..write(obj.sps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfirmDeliveryBarcodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportTransportTaskDBAdapter extends TypeAdapter<ReportTransportTaskDB> {
  @override
  final int typeId = 5;

  @override
  ReportTransportTaskDB read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportTransportTaskDB(
      id: fields[0] as String?,
      barcodeId: fields[1] as int?,
      transportTaskId: fields[2] as String?,
      transportTaskLineNo: fields[3] as String?,
      shopOrderNo: fields[4] as String?,
      expListNo: fields[5] as String?,
      partNo: fields[6] as String?,
      partDesc: fields[7] as String?,
      lotNo: fields[8] as String?,
      wdrNo: fields[9] as String?,
      qty: fields[10] as double?,
      reportedQty: fields[11] as double?,
      remainingQty: fields[12] as double?,
      uom: fields[13] as String?,
      errorMessage: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportTransportTaskDB obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.barcodeId)
      ..writeByte(2)
      ..write(obj.transportTaskId)
      ..writeByte(3)
      ..write(obj.transportTaskLineNo)
      ..writeByte(4)
      ..write(obj.shopOrderNo)
      ..writeByte(5)
      ..write(obj.expListNo)
      ..writeByte(6)
      ..write(obj.partNo)
      ..writeByte(7)
      ..write(obj.partDesc)
      ..writeByte(8)
      ..write(obj.lotNo)
      ..writeByte(9)
      ..write(obj.wdrNo)
      ..writeByte(10)
      ..write(obj.qty)
      ..writeByte(11)
      ..write(obj.reportedQty)
      ..writeByte(12)
      ..write(obj.remainingQty)
      ..writeByte(13)
      ..write(obj.uom)
      ..writeByte(14)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportTransportTaskDBAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportMaterialRequisitionBarcodeAdapter
    extends TypeAdapter<ReportMaterialRequisitionBarcode> {
  @override
  final int typeId = 6;

  @override
  ReportMaterialRequisitionBarcode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportMaterialRequisitionBarcode(
      id: fields[0] as String?,
      type: fields[1] as String?,
      barcodeId: fields[2] as int?,
      materialReqNo: fields[3] as String?,
      lineNo: fields[4] as String?,
      relNo: fields[5] as String?,
      internalCustomerNo: fields[6] as String?,
      internalCustomerName: fields[7] as String?,
      internalDestinationNo: fields[8] as String?,
      internalDestinationName: fields[9] as String?,
      dueDate: fields[10] as String?,
      noOfLine: fields[11] as double?,
      partNo: fields[12] as String?,
      partDesc: fields[13] as String?,
      locationNo: fields[14] as String?,
      locationDesc: fields[15] as String?,
      lotNo: fields[16] as String?,
      wdrNo: fields[17] as String?,
      reservedQty: fields[18] as double?,
      reportedQty: fields[19] as double?,
      errorMessage: fields[20] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportMaterialRequisitionBarcode obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.barcodeId)
      ..writeByte(3)
      ..write(obj.materialReqNo)
      ..writeByte(4)
      ..write(obj.lineNo)
      ..writeByte(5)
      ..write(obj.relNo)
      ..writeByte(6)
      ..write(obj.internalCustomerNo)
      ..writeByte(7)
      ..write(obj.internalCustomerName)
      ..writeByte(8)
      ..write(obj.internalDestinationNo)
      ..writeByte(9)
      ..write(obj.internalDestinationName)
      ..writeByte(10)
      ..write(obj.dueDate)
      ..writeByte(11)
      ..write(obj.noOfLine)
      ..writeByte(12)
      ..write(obj.partNo)
      ..writeByte(13)
      ..write(obj.partDesc)
      ..writeByte(14)
      ..write(obj.locationNo)
      ..writeByte(15)
      ..write(obj.locationDesc)
      ..writeByte(16)
      ..write(obj.lotNo)
      ..writeByte(17)
      ..write(obj.wdrNo)
      ..writeByte(18)
      ..write(obj.reservedQty)
      ..writeByte(19)
      ..write(obj.reportedQty)
      ..writeByte(20)
      ..write(obj.errorMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportMaterialRequisitionBarcodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PurchaseOrderReceiveBarcodeAdapter
    extends TypeAdapter<PurchaseOrderReceiveBarcode> {
  @override
  final int typeId = 7;

  @override
  PurchaseOrderReceiveBarcode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseOrderReceiveBarcode(
      id: fields[0] as String?,
      barcodeId: fields[1] as int?,
      purchaseOrderNo: fields[2] as String?,
      lineNo: fields[3] as String?,
      relNo: fields[4] as String?,
      supplierNo: fields[5] as String?,
      supplierName: fields[6] as String?,
      shopOrderNo: fields[7] as String?,
      partNo: fields[8] as String?,
      partDesc: fields[9] as String?,
      lotNo: fields[10] as String?,
      wdrNo: fields[11] as String?,
      purchOrderQty: fields[12] as double?,
      purchReceivedQty: fields[13] as double?,
      purchUom: fields[14] as String?,
      invOrderQty: fields[15] as double?,
      invReceivedQty: fields[16] as double?,
      invUom: fields[17] as String?,
      conversionFactor: fields[18] as double?,
      invoiceNo: fields[19] as String?,
      actualArrivalDate: fields[20] as String?,
      errorMessage: fields[21] as String?,
      sequenceId: fields[22] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseOrderReceiveBarcode obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.barcodeId)
      ..writeByte(2)
      ..write(obj.purchaseOrderNo)
      ..writeByte(3)
      ..write(obj.lineNo)
      ..writeByte(4)
      ..write(obj.relNo)
      ..writeByte(5)
      ..write(obj.supplierNo)
      ..writeByte(6)
      ..write(obj.supplierName)
      ..writeByte(7)
      ..write(obj.shopOrderNo)
      ..writeByte(8)
      ..write(obj.partNo)
      ..writeByte(9)
      ..write(obj.partDesc)
      ..writeByte(10)
      ..write(obj.lotNo)
      ..writeByte(11)
      ..write(obj.wdrNo)
      ..writeByte(12)
      ..write(obj.purchOrderQty)
      ..writeByte(13)
      ..write(obj.purchReceivedQty)
      ..writeByte(14)
      ..write(obj.purchUom)
      ..writeByte(15)
      ..write(obj.invOrderQty)
      ..writeByte(16)
      ..write(obj.invReceivedQty)
      ..writeByte(17)
      ..write(obj.invUom)
      ..writeByte(18)
      ..write(obj.conversionFactor)
      ..writeByte(19)
      ..write(obj.invoiceNo)
      ..writeByte(20)
      ..write(obj.actualArrivalDate)
      ..writeByte(21)
      ..write(obj.errorMessage)
      ..writeByte(22)
      ..write(obj.sequenceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrderReceiveBarcodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MoveToNewLocationRepAdapter extends TypeAdapter<MoveToNewLocationRep> {
  @override
  final int typeId = 8;

  @override
  MoveToNewLocationRep read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoveToNewLocationRep(
      barcodeId: fields[0] as int?,
      partNo: fields[1] as String?,
      partDesc: fields[2] as String?,
      fromLocation: fields[3] as String?,
      toLocation: fields[4] as String?,
      lotNo: fields[5] as String?,
      wdrNo: fields[6] as String?,
      movedQty: fields[7] as double?,
      errorMessage: fields[8] as String?,
      userLogin: fields[9] as String?,
      classBox: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MoveToNewLocationRep obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.barcodeId)
      ..writeByte(1)
      ..write(obj.partNo)
      ..writeByte(2)
      ..write(obj.partDesc)
      ..writeByte(3)
      ..write(obj.fromLocation)
      ..writeByte(4)
      ..write(obj.toLocation)
      ..writeByte(5)
      ..write(obj.lotNo)
      ..writeByte(6)
      ..write(obj.wdrNo)
      ..writeByte(7)
      ..write(obj.movedQty)
      ..writeByte(8)
      ..write(obj.errorMessage)
      ..writeByte(9)
      ..write(obj.userLogin)
      ..writeByte(10)
      ..write(obj.classBox);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoveToNewLocationRepAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationJFromAndToAdapter extends TypeAdapter<LocationJFromAndTo> {
  @override
  final int typeId = 9;

  @override
  LocationJFromAndTo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationJFromAndTo(
      id: fields[0] as int?,
      locationFrom: fields[1] as String?,
      classBox: fields[2] as String?,
      userLogin: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocationJFromAndTo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.locationFrom)
      ..writeByte(2)
      ..write(obj.classBox)
      ..writeByte(3)
      ..write(obj.userLogin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationJFromAndToAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
