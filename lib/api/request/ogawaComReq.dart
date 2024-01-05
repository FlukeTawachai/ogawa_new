class OgawaComReq {
  String? schedOptionList;
  String? partNo;
  String? partDesc;
  String? productionLine;
  String? locationNo;
  String? lotNo;
  String? reportDate;
  String? schedOption;
  double? reportedQty;
  String? uom;
  String? isLotTracking;
  String? isAllowReviseQty;
  String? username;
  String? password;
  double? stdPackSize;
  double? numberOfLabels;
  String? barcodeIdList;
  String? errorMessage;

  OgawaComReq(
      {this.schedOptionList,
      this.partNo,
      this.partDesc,
      this.productionLine,
      this.locationNo,
      this.lotNo,
      this.reportDate,
      this.schedOption,
      this.reportedQty,
      this.uom,
      this.isLotTracking,
      this.isAllowReviseQty,
      this.username,
      this.password,
      this.stdPackSize,
      this.numberOfLabels,
      this.barcodeIdList,
      this.errorMessage});

  OgawaComReq.fromJson(Map<String, dynamic> json) {
    schedOptionList = json['SchedOptionList'];
    partNo = json['PartNo'];
    partDesc = json['PartDesc'];
    productionLine = json['ProductionLine'];
    locationNo = json['LocationNo'];
    lotNo = json['LotNo'];
    reportDate = json['ReportDate'];
    schedOption = json['SchedOption'];
    reportedQty = json['ReportedQty'];
    uom = json['Uom'];
    isLotTracking = json['IsLotTracking'];
    isAllowReviseQty = json['IsAllowReviseQty'];
    username = json['Username'];
    password = json['Password'];
    stdPackSize = json['StdPackSize'];
    numberOfLabels = json['NumberOfLabels'];
    barcodeIdList = json['BarcodeIdList'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SchedOptionList'] = this.schedOptionList;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['ProductionLine'] = this.productionLine;
    data['LocationNo'] = this.locationNo;
    data['LotNo'] = this.lotNo;
    data['ReportDate'] = this.reportDate;
    data['SchedOption'] = this.schedOption;
    data['ReportedQty'] = this.reportedQty;
    data['Uom'] = this.uom;
    data['IsLotTracking'] = this.isLotTracking;
    data['IsAllowReviseQty'] = this.isAllowReviseQty;
    data['Username'] = this.username;
    data['Password'] = this.password;
    data['StdPackSize'] = this.stdPackSize;
    data['NumberOfLabels'] = this.numberOfLabels;
    data['BarcodeIdList'] = this.barcodeIdList;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}