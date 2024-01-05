class CommonResp {
  String? type;
  String? partNo;
  String? partDesc;
  String? locationNo;
  String? locationDesc;
  double? noOfLot;
  String? lotNo;
  double? noOfWdr;
  String? wdrNo;
  double? qtyOnHand;
  double? qtyReserved;
  double? qtyAvailable;
  String? uom;
  String? errorMessage;

  CommonResp(
      {this.type,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.noOfLot,
      this.lotNo,
      this.noOfWdr,
      this.wdrNo,
      this.qtyOnHand,
      this.qtyReserved,
      this.qtyAvailable,
      this.uom,
      this.errorMessage});

  CommonResp.fromJson(Map<String, dynamic> json) {
    type = json['$type'];
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    locationNo = json['LocationNo'] ?? "";
    locationDesc = json['LocationDesc'] ?? "";
    noOfLot = json['NoOfLot'] ?? 0;
    lotNo = json['LotNo'] ?? "";
    noOfWdr = json['NoOfWdr'] ?? 0;
    wdrNo = json['WdrNo'] ?? "";
    qtyOnHand = json['QtyOnHand'] ?? 0;
    qtyReserved = json['QtyReserved'] ?? 0;
    qtyAvailable = json['QtyAvailable'] ?? 0;
    uom = json['Uom'] ?? "";
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['NoOfLot'] = this.noOfLot;
    data['LotNo'] = this.lotNo;
    data['NoOfWdr'] = this.noOfWdr;
    data['WdrNo'] = this.wdrNo;
    data['QtyOnHand'] = this.qtyOnHand;
    data['QtyReserved'] = this.qtyReserved;
    data['QtyAvailable'] = this.qtyAvailable;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
