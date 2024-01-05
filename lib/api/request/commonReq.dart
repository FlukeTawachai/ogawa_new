class CommonReq {
  String? type;
  String? partNo;
  String? partDesc;
  String? locationNo;
  String? locationDesc;
  double? noOfLot;
  String? lotNo;
  double? noOfWdr ;
  String? wdrNo;
  double? qtyOnHand ;
  double? qtyReserved ;
  double? qtyAvailable ;
  String? uom;
  String? errorMessage;

  CommonReq(
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

  CommonReq.fromJson(Map<String, dynamic> json) {
    type = json['$type'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    locationNo = json['LocationNo'];
    locationDesc = json['LocationDesc'];
    noOfLot = json['NoOfLot'];
    lotNo = json['LotNo'];
    noOfWdr = json['NoOfWdr'];
    wdrNo = json['WdrNo'];
    qtyOnHand = json['QtyOnHand'];
    qtyReserved = json['QtyReserved'];
    qtyAvailable = json['QtyAvailable'];
    uom = json['Uom'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['NoOfLot'] = this.noOfLot == null ? 0.0 : this.noOfLot;
    data['LotNo'] = this.lotNo;
    data['NoOfWdr'] = this.noOfWdr == null ? 0.0 : this.noOfWdr;
    data['WdrNo'] = this.wdrNo;
    data['QtyOnHand'] = this.qtyOnHand == null ? 0.0 : this.qtyOnHand;
    data['QtyReserved'] = this.qtyReserved == null ? 0.0 : this.qtyReserved;
    data['QtyAvailable'] = this.qtyAvailable == null ? 0.0 : this.qtyAvailable;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
