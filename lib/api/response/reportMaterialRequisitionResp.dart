class ReportMaterialRequisitionResp {
  String? type;
  int? barcodeId;
  String? materialReqNo;
  String? lineNo;
  String? relNo;
  String? internalCustomerNo;
  String? internalCustomerName;
  String? internalDestinationNo;
  String? internalDestinationName;
  String? dueDate;
  double? noOfLine;
  String? partNo;
  String? partDesc;
  String? locationNo;
  String? locationDesc;
  String? lotNo;
  String? wdrNo;
  double? reservedQty;
  double? reportedQty;
  String? errorMessage;

  ReportMaterialRequisitionResp(
      {this.type,
      this.barcodeId,
      this.materialReqNo,
      this.lineNo,
      this.relNo,
      this.internalCustomerNo,
      this.internalCustomerName,
      this.internalDestinationNo,
      this.internalDestinationName,
      this.dueDate,
      this.noOfLine,
      this.partNo,
      this.partDesc,
      this.locationNo,
      this.locationDesc,
      this.lotNo,
      this.wdrNo,
      this.reservedQty,
      this.reportedQty,
      this.errorMessage});

  ReportMaterialRequisitionResp.fromJson(Map<String, dynamic> json) {
    type = json['$type'] ?? "";
    barcodeId = json['BarcodeId'];
    materialReqNo = json['MaterialReqNo'] ?? "";
    lineNo = json['LineNo'] ?? "";
    relNo = json['RelNo'] ?? "";
    internalCustomerNo = json['InternalCustomerNo'] ?? "";
    internalCustomerName = json['InternalCustomerName'] ?? "";
    internalDestinationNo = json['InternalDestinationNo'] ?? "";
    internalDestinationName = json['InternalDestinationName'] ?? "";
    dueDate = json['DueDate'] ?? "";
    noOfLine = json['NoOfLine'];
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    locationNo = json['LocationNo'] ?? "";
    locationDesc = json['LocationDesc'] ?? "";
    lotNo = json['LotNo'] ?? "";
    wdrNo = json['WdrNo'] ?? "";
    reservedQty = json['ReservedQty'];
    reportedQty = json['ReportedQty'];
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['BarcodeId'] = this.barcodeId;
    data['MaterialReqNo'] = this.materialReqNo;
    data['LineNo'] = this.lineNo;
    data['RelNo'] = this.relNo;
    data['InternalCustomerNo'] = this.internalCustomerNo;
    data['InternalCustomerName'] = this.internalCustomerName;
    data['InternalDestinationNo'] = this.internalDestinationNo;
    data['InternalDestinationName'] = this.internalDestinationName;
    data['DueDate'] = this.dueDate;
    data['NoOfLine'] = this.noOfLine;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LocationNo'] = this.locationNo;
    data['LocationDesc'] = this.locationDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['ReservedQty'] = this.reservedQty;
    data['ReportedQty'] = this.reportedQty;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
