class countPerInventoryPartReq {
  int? barcodeId;
  String? partNo;
  String? partDesc;
  String? locationNo;
  String? locationDesc;
  String? lotNo;
  String? wdrNo;
  double? countQty;
  String? uom;
  String? errorMessage;

  countPerInventoryPartReq(
      {this.barcodeId,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.countQty,
      this.uom,
      this.errorMessage});

  countPerInventoryPartReq.fromJson(Map<String, dynamic> json) {
    barcodeId = json['BarcodeId'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    locationNo = json['LocationNo'];
    locationDesc = json['LocationDesc'];
    lotNo = json['LotNo'];
    wdrNo = json['WdrNo'];
    countQty = json['CountQty'];
    uom = json['Uom'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BarcodeId'] = this.barcodeId;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['CountQty'] = this.countQty;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
