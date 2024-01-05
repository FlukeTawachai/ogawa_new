class moveToNewLocationResp {
  int? barcodeId;
  String? partNo;
  String? partDesc;
  String? fromLocation;
  String? toLocation;
  String? lotNo;
  String? wdrNo;
  double? movedQty;
  String? listBarcodeId;
  String? errorMessage;
  String? userLogin;
  String? classBox;

  moveToNewLocationResp(
      {this.barcodeId,
      this.partNo,
      this.partDesc,
      this.fromLocation,
      this.toLocation,
      this.lotNo,
      this.wdrNo,
      this.movedQty,
      this.listBarcodeId,
      this.errorMessage,
      this.userLogin,
      this.classBox});

  moveToNewLocationResp.fromJson(Map<String, dynamic> json) {
    barcodeId = json['BarcodeId'];
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    fromLocation = json['FromLocation'] ?? "";
    toLocation = json['ToLocation'] ?? "";
    lotNo = json['LotNo'] ?? "";
    wdrNo = json['WdrNo'] ?? "";
    movedQty = json['MovedQty'];
    listBarcodeId = json['ListBarcodeId'] ?? "";
    errorMessage = json['ErrorMessage'];
    userLogin = json['userLogin'];
    classBox = json['classBox'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BarcodeId'] = this.barcodeId;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['FromLocation'] = this.fromLocation;
    data['ToLocation'] = this.toLocation;
    data['LotNo'] = this.lotNo;
    data['WdrNo'] = this.wdrNo;
    data['MovedQty'] = this.movedQty;
    data['ListBarcodeId'] = this.listBarcodeId;
    data['ErrorMessage'] = this.errorMessage;
    data['userLogin'] = this.userLogin;
    data['classBox'] = this.classBox;
    return data;
  }
}
