class ShopOrderReceiveReq {
  String? shopBarcode;
  String? customerBarcode;
  String? shopOrderNo;
  String? relNo;
  String? seqNo;
  String? partNo;
  String? partDesc;
  String? locationNo;
  String? locationDesc;
  String? lotNo;
  String? wdrNo;
  double? remainingQty;
  double? reportedQty;
  double? stdPackSize;
  String? uom;
  String? errorMessage;

  ShopOrderReceiveReq(
      {this.shopBarcode,
      this.customerBarcode,
      this.shopOrderNo,
      this.relNo,
      this.seqNo,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.remainingQty,
      this.reportedQty,
      this.stdPackSize,
      this.uom,
      this.errorMessage});

  ShopOrderReceiveReq.fromJson(Map<String, dynamic> json) {
    shopBarcode = json['ShopBarcode'];
    customerBarcode = json['CustomerBarcode'];
    shopOrderNo = json['ShopOrderNo'];
    relNo = json['RelNo'];
    seqNo = json['SeqNo'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    locationNo = json['LocationNo'];
    locationDesc = json['LocationDesc'];
    lotNo = json['LotNo'];
    wdrNo = json['WdrNo'];
    remainingQty = json['RemainingQty'];
    reportedQty = json['ReportedQty'];
    stdPackSize = json['StdPackSize'];
    uom = json['Uom'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShopBarcode'] = this.shopBarcode;
    data['CustomerBarcode'] = this.customerBarcode;
    data['ShopOrderNo'] = this.shopOrderNo;
    data['RelNo'] = this.relNo;
    data['SeqNo'] = this.seqNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['RemainingQty'] = this.remainingQty;
    data['ReportedQty'] = this.reportedQty;
    data['StdPackSize'] = this.stdPackSize;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}