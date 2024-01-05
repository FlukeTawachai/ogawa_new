class shopOrderReceiveWIPReq {
  int? barcodeId;
  String? shopOrderNo;
  String? partNo;
  String? partDesc;
  String? fgNo;
  String? locationNo;
  String? locationDesc;
  String? lotNo;
  String? wdrNo;
  double? remainingQty;
  double? reportedQty;
  double? stdPackSize;
  String? uom;
  bool? isOverRemaining;
  bool? isLastBarcode;
  String? errorMessage;

  shopOrderReceiveWIPReq(
      {this.barcodeId,
      this.shopOrderNo,
      this.partNo,
      this.partDesc,
      this.fgNo,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.remainingQty,
      this.reportedQty,
      this.stdPackSize,
      this.uom,
      this.isOverRemaining,
      this.isLastBarcode,
      this.errorMessage});

  shopOrderReceiveWIPReq.fromJson(Map<String, dynamic> json) {
    barcodeId = json['BarcodeId'];
    shopOrderNo = json['ShopOrderNo'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    fgNo = json['FgNo'];
    locationNo = json['LocationNo'];
    locationDesc = json['LocationDesc'];
    lotNo = json['LotNo'];
    wdrNo = json['WdrNo'];
    remainingQty = json['RemainingQty'];
    reportedQty = json['ReportedQty'];
    stdPackSize = json['StdPackSize'];
    uom = json['Uom'];
    isOverRemaining = json['IsOverRemaining'];
    isLastBarcode = json['IsLastBarcode'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BarcodeId'] = this.barcodeId;
    data['ShopOrderNo'] = this.shopOrderNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['FgNo'] = this.fgNo;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['RemainingQty'] = this.remainingQty;
    data['ReportedQty'] = this.reportedQty;
    data['StdPackSize'] = this.stdPackSize;
    data['Uom'] = this.uom;
    data['IsOverRemaining'] = this.isOverRemaining;
    data['IsLastBarcode'] = this.isLastBarcode;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}