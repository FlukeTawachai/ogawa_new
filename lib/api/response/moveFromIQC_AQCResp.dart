class MoveFromIQC_AQCResp {
  String? type;
  String? purchaseOrderNo;
  String? lineNo;
  String? relNo;
  String? vendorNo;
  String? partNo;
  String? partDesc;
  String? lotNo;
  String? wdrNo;
  double? invQtyToMove;
  String? invUom;
  String? toLocation;
  String? errorMessage;
  bool? check;

  MoveFromIQC_AQCResp(
      {this.type,
      this.purchaseOrderNo,
      this.lineNo,
      this.relNo,
      this.vendorNo,
      this.partNo,
      this.partDesc,
      this.lotNo,
      this.wdrNo,
      this.invQtyToMove,
      this.invUom,
      this.toLocation,
      this.errorMessage,
      this.check});

  MoveFromIQC_AQCResp.fromJson(Map<String, dynamic> json) {
    type = json['$type'] ?? "";
    purchaseOrderNo = json['PurchaseOrderNo'] ?? "";
    lineNo = json['LineNo'] ?? "";
    relNo = json['RelNo'] ?? "";
    vendorNo = json['VendorNo'] ?? "";
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    lotNo = json['LotNo'] ?? "";
    wdrNo = json['WdrNo'] ?? "";
    invQtyToMove = json['InvQtyToMove'];
    invUom = json['InvUom'] ?? "";
    toLocation = json['ToLocation'] ?? "";
    errorMessage = json['ErrorMessage'];
    check = json['Check'] == null ? false : true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['PurchaseOrderNo'] = this.purchaseOrderNo;
    data['LineNo'] = this.lineNo;
    data['RelNo'] = this.relNo;
    data['VendorNo'] = this.vendorNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['InvQtyToMove'] = this.invQtyToMove;
    data['InvUom'] = this.invUom;
    data['ToLocation'] = this.toLocation;
    data['ErrorMessage'] = this.errorMessage;
    data['Check'] = this.check == null ? false : this.check;
    return data;
  }
}
