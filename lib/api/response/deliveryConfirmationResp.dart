class DeliveryConfirmationResp {
  String? type;
  String? customerBarcode;
  String? shipmentNo;
  String? lineNo;
  String? customerNo;
  String? customerName;
  String? etdDate;
  String? invoiceNo;
  String? partNo;
  String? partDesc;
  String? itemNo;
  String? containerNo;
  double? noOfCarton;
  double? reservedQty;
  double? reportedQty;
  String? errorMessage;
  String? key;

  DeliveryConfirmationResp(
      {this.type,
      this.customerBarcode,
      this.shipmentNo,
      this.lineNo,
      this.customerNo,
      this.customerName,
      this.etdDate,
      this.invoiceNo,
      this.partNo,
      this.partDesc,
      this.itemNo,
      this.containerNo,
      this.noOfCarton,
      this.reservedQty,
      this.reportedQty,
      this.errorMessage,
      this.key});

  DeliveryConfirmationResp.fromJson(Map<String, dynamic> json) {
    type = json['$type'] ?? "";
    customerBarcode = json['CustomerBarcode'] ?? "";
    shipmentNo = json['ShipmentNo'] ?? "";
    lineNo = json['LineNo'] ?? "";
    customerNo = json['CustomerNo'] ?? "";
    customerName = json['CustomerName'] ?? "";
    etdDate = json['EtdDate'] ?? "";
    invoiceNo = json['InvoiceNo'] ?? "";
    partNo = json['PartNo'] ?? "";
    partDesc = json['PartDesc'] ?? "";
    itemNo = json['ItemNo'] ?? "";
    containerNo = json['ContainerNo'] ?? "";
    noOfCarton = json['NoOfCarton'];
    reservedQty = json['ReservedQty'];
    reportedQty = json['ReportedQty'];
    errorMessage = json['ErrorMessage'];
    key = json['Key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$type'] = this.type;
    data['CustomerBarcode'] = this.customerBarcode;
    data['ShipmentNo'] = this.shipmentNo;
    data['LineNo'] = this.lineNo;
    data['CustomerNo'] = this.customerNo;
    data['CustomerName'] = this.customerName;
    data['EtdDate'] = this.etdDate;
    data['InvoiceNo'] = this.invoiceNo;
    data['PartNo'] = this.partNo;
    data['PartDesc'] = this.partDesc;
    data['ItemNo'] = this.itemNo;
    data['ContainerNo'] = this.containerNo;
    data['NoOfCarton'] = this.noOfCarton;
    data['ReservedQty'] = this.reservedQty;
    data['ReportedQty'] = this.reportedQty;
    data['ErrorMessage'] = this.errorMessage;
    data['Key'] = this.key;
    return data;
  }
}
