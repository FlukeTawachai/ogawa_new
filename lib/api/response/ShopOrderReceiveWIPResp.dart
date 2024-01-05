class shopOrderReceiveWIPResp {
  String? type;
  int? barcodeId;
  String? shopOrderNo;
  String? partNo;
  String? partDesc;
  String? fgNo;
  String? locationNo;
  String? locationDesc;
  String? lotNo;
  String? wdrNo;
  String? parentOrder;
  double? remainingQty;
  double? reportedQty;
  double? stdPackSize;
  String? uom;
  String? lastBarcode;
  bool? isLastBarcode;
  bool? isOverRemaining;
  String? errorMessage;

  shopOrderReceiveWIPResp(
      {this.type,
      this.barcodeId,
      this.shopOrderNo,
      this.partNo,
      this.partDesc,
      this.fgNo,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.parentOrder,
      this.remainingQty,
      this.reportedQty,
      this.stdPackSize,
      this.uom,
      this.lastBarcode,
      this.isLastBarcode,
      this.isOverRemaining,
      this.errorMessage});

  shopOrderReceiveWIPResp.fromJson(Map<String, dynamic> json) {
    type = json['$type'] ?? "";
    barcodeId = json['BarcodeId'];
    shopOrderNo = json['ShopOrderNo'] ?? "";
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    fgNo = json['FgNo'] ?? "";
    locationNo = json['LocationNo'] ?? "";
    locationDesc = json['LocationDesc'] ?? "";
    lotNo = json['LotNo'] ?? "";
    wdrNo = json['WdrNo'] ?? "";
    parentOrder = json['ParentOrder'] ?? "";
    remainingQty = json['RemainingQty'];
    reportedQty = json['ReportedQty'];
    stdPackSize = json['StdPackSize'];
    uom = json['Uom'] ?? "";
    lastBarcode = json['LastBarcode'] ?? "";
    isLastBarcode = json['IsLastBarcode'];
    isOverRemaining = json['IsOverRemaining'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['BarcodeId'] = this.barcodeId;
    data['ShopOrderNo'] = this.shopOrderNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['FgNo'] = this.fgNo;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['ParentOrder'] = this.parentOrder;
    data['RemainingQty'] = this.remainingQty;
    data['ReportedQty'] = this.reportedQty;
    data['StdPackSize'] = this.stdPackSize;
    data['Uom'] = this.uom;
    data['LastBarcode'] = this.lastBarcode;
    data['IsLastBarcode'] = this.isLastBarcode;
    data['IsOverRemaining'] = this.isOverRemaining;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
