class GetDataByShopBarcodeResp {
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
  bool? check;

  GetDataByShopBarcodeResp(
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
      this.errorMessage,
      this.check});

  GetDataByShopBarcodeResp.fromJson(Map<String, dynamic> json) {
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
    check = json['Check'] ?? false;
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
    data['LotSize'] = this.lotSize;
    data['PlanMan'] = this.planMan;
    data['PlanSetupMan'] = this.planSetupMan;
    data['RemainingQty'] = this.remainingQty;
    data['ReportedQty'] = this.reportedQty;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    data['Check'] = this.check;
    return data;
  }
}