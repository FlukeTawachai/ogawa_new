class GetDataByShopBarcodeReq {
  String? shopBarcode;
  String? shopOrderNo;
  String? relNo;
  String? seqNo;
  String? operationNo;
  String? operationDesc;
  String? productionLine;
  String? partNo;
  String? partDesc;
  double? lotSize;
  double? planMan;
  double? planSetupMan;
  double? remainingQty;
  double? reportedQty;
  String? uom;
  String? errorMessage;

  GetDataByShopBarcodeReq(
      {this.shopBarcode,
      this.shopOrderNo,
      this.relNo,
      this.seqNo,
      this.operationNo,
      this.operationDesc,
      this.productionLine,
      this.partNo,
      this.partDesc,
      this.lotSize,
      this.planMan,
      this.planSetupMan,
      this.remainingQty,
      this.reportedQty,
      this.uom,
      this.errorMessage});

  GetDataByShopBarcodeReq.fromJson(Map<String, dynamic> json) {
    shopBarcode = json['ShopBarcode'];
    shopOrderNo = json['ShopOrderNo'];
    relNo = json['RelNo'];
    seqNo = json['SeqNo'];
    operationNo = json['OperationNo'];
    operationDesc = json['OperationDesc'];
    productionLine = json['ProductionLine'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    lotSize = json['LotSize'];
    planMan = json['PlanMan'];
    planSetupMan = json['PlanSetupMan'];
    remainingQty = json['RemainingQty'];
    reportedQty = json['ReportedQty'];
    uom = json['Uom'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShopBarcode'] = this.shopBarcode;
    data['ShopOrderNo'] = this.shopOrderNo;
    data['RelNo'] = this.relNo;
    data['SeqNo'] = this.seqNo;
    data['OperationNo'] = this.operationNo;
    data['OperationDesc'] = this.operationDesc;
    data['ProductionLine'] = this.productionLine;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LotSize'] = this.lotSize ?? 0;
    data['PlanMan'] = this.planMan ?? 0;
    data['PlanSetupMan'] = this.planSetupMan ?? 0;
    data['RemainingQty'] = this.remainingQty ?? 0;
    data['ReportedQty'] = this.reportedQty ?? 0;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
