class reportTransportTaskResp {
  String? id;
  int? barcodeId;
  String? transportTaskId;
  String? transportTaskLineNo;
  String? shopOrderNo;
  String? expListNo;
  String? partNo;
  String? partDesc;
  String? lotNo;
  String? wdrNo;
  double? qty;
  double? reportedQty;
  double? remainingQty;
  String? uom;
  String? errorMessage;

  reportTransportTaskResp(
      {this.id,
      this.barcodeId,
      this.transportTaskId,
      this.transportTaskLineNo,
      this.shopOrderNo,
      this.expListNo,
      this.partNo,
      this.partDesc,
      this.lotNo,
      this.wdrNo,
      this.qty,
      this.reportedQty,
      this.remainingQty,
      this.uom,
      this.errorMessage});

  reportTransportTaskResp.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    barcodeId = json['BarcodeId'];
    transportTaskId = json['TransportTaskId'] ?? "";
    transportTaskLineNo = json['TransportTaskLineNo'] ?? "";
    shopOrderNo = json['ShopOrderNo'] ?? "";
    expListNo = json['ExpListNo'] ?? "";
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    lotNo = json['LotNo'] ?? "";
    wdrNo = json['WdrNo'] ?? "";
    qty = json['Qty'];
    reportedQty = json['ReportedQty'];
    remainingQty = json['RemainingQty'];
    uom = json['Uom'] ?? "";
    errorMessage = json['ErrorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['BarcodeId'] = this.barcodeId;
    data['TransportTaskId'] = this.transportTaskId;
    data['TransportTaskLineNo'] = this.transportTaskLineNo;
    data['ShopOrderNo'] = this.shopOrderNo;
    data['ExpListNo'] = this.expListNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['Qty'] = this.qty;
    data['ReportedQty'] = this.reportedQty;
    data['RemainingQty'] = this.remainingQty;
    data['Uom'] = this.uom;
    data['ErrorMessage'] = this.errorMessage;
    return data;
  }
}
