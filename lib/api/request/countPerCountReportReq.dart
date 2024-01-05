class CountPerCountReportReq {
  String? countReportNo;
  String? countReportSeq;
  int? barcodeId;
  String? partNo;
  String? partDesc;
  String? locationNo;
  String? locationDesc;
  String? lotNo;
  String? wdrNo;
  double? countQty;
  String? errorMessage;

  CountPerCountReportReq(
      {this.countReportNo,
      this.countReportSeq,
      this.barcodeId,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.countQty,
      this.errorMessage});

  CountPerCountReportReq.fromJson(Map<String, dynamic> json) {
    countReportNo = json['CountReportNo'];
    countReportSeq = json['CountReportSeq'];
    barcodeId = json['BarcodeId'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    locationNo = json['LocationNo'];
    locationDesc = json['LocationDesc'];
    lotNo = json['LotNo'];
    wdrNo = json['WdrNo'];
    countQty = json['CountQty'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CountReportNo'] = this.countReportNo;
    data['CountReportSeq'] = this.countReportSeq;
    data['BarcodeId'] = this.barcodeId;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['CountQty'] = this.countQty;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
