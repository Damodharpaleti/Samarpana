class StatusUpdate {
  StatusUpdate({
    required this.orderNumber,
    required this.orderStatus,
    required this.mobileNumber,
    required this.accessCode,
  });

  String orderNumber;
  String orderStatus;
  String accessCode;
  String mobileNumber;

  factory StatusUpdate.fromJson(Map<String, dynamic> json) => StatusUpdate(
        orderNumber: json["orderNumber"],
        orderStatus: json["orderStatus"],
        mobileNumber: json["mobileNumber"],
        accessCode: json["accessCode"],
      );

  Map<String, dynamic> toJson() => {
        "orderNumber": orderNumber,
        "orderStatus": orderStatus,
        "accessCode": accessCode,
        "mobileNumber": mobileNumber,
      };
}
