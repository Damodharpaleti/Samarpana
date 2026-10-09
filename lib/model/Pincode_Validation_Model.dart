class Pincodevalidation {
  Pincodevalidation({
    this.postalCode,
    this.accountId,
    this.agetName,
    this.branch,
    this.message,
    this.code,
  });

  String? postalCode;
  String? accountId;
  String? agetName;
  String? branch;
  String? message;
  String? code;

  factory Pincodevalidation.fromJson(Map<String, dynamic> json) =>
      Pincodevalidation(
        postalCode: json["postalCode"],
        accountId: json["accountId"],
        agetName: json["agetName"],
        branch: json["branch"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "postalCode": postalCode,
        "accountId": accountId,
        "agetName": agetName,
        "branch": branch,
        "message": message,
        "code": code,
      };
}
