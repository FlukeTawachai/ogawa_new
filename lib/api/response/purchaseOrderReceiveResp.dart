class PurchaseOrderReceiveResp {
  String? type;
  int? barcodeId;
  double? sequenceId;
  String? purchaseOrderNo;
  String? lineNo;
  String? relNo;
  String? supplierNo;
  String? supplierName;
  String? shopOrderNo;
  String? partNo;
  String? partDesc;
  String? lotNo;
  String? wdrNo;
  double? purchOrderQty;
  double? purchReceivedQty;
  String? purchUom;
  double? invOrderQty;
  double? invReceivedQty;
  String? invUom;
  double? conversionFactor;
  String? invoiceNo;
  String? actualArrivalDate;
  String? errorMessage;

  PurchaseOrderReceiveResp(
      {this.type,
      this.barcodeId,
      this.sequenceId,
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
      this.errorMessage});

  PurchaseOrderReceiveResp.fromJson(Map<String, dynamic> json) {
    type = json['$type'] ?? "";
    barcodeId = json['BarcodeId'];
    sequenceId = json['SequenceId'];
    purchaseOrderNo = json['PurchaseOrderNo'] ?? "";
    lineNo = json['LineNo'] ?? "";
    relNo = json['RelNo'] ?? "";
    supplierNo = json['SupplierNo'] ?? "";
    supplierName = json['SupplierName'] ?? "";
    shopOrderNo = json['ShopOrderNo'] ?? "";
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    lotNo = json['LotNo'] ?? "";
    wdrNo = json['WdrNo'] ?? "";
    purchOrderQty = json['PurchOrderQty'];
    purchReceivedQty = json['PurchReceivedQty'];
    purchUom = json['PurchUom'] ?? "";
    invOrderQty = json['InvOrderQty'];
    invReceivedQty = json['InvReceivedQty'];
    invUom = json['InvUom'] ?? "";
    conversionFactor = json['ConversionFactor'];
    invoiceNo = json['InvoiceNo'] ?? "";
    actualArrivalDate = json['ActualArrivalDate'] ?? "";
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['BarcodeId'] = this.barcodeId;
    data['SequenceId'] = this.sequenceId;
    data['PurchaseOrderNo'] = this.purchaseOrderNo;
    data['LineNo'] = this.lineNo;
    data['RelNo'] = this.relNo;
    data['SupplierNo'] = this.supplierNo;
    data['SupplierName'] = this.supplierName;
    data['ShopOrderNo'] = this.shopOrderNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['PurchOrderQty'] = this.purchOrderQty;
    data['PurchReceivedQty'] = this.purchReceivedQty;
    data['PurchUom'] = this.purchUom;
    data['InvOrderQty'] = this.invOrderQty;
    data['InvReceivedQty'] = this.invReceivedQty;
    data['InvUom'] = this.invUom;
    data['ConversionFactor'] = this.conversionFactor;
    data['InvoiceNo'] = this.invoiceNo;
    data['ActualArrivalDate'] = this.actualArrivalDate;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
