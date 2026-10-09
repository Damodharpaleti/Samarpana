class WithdrawRequest {
  WithdrawRequest({
    required this.userId,
    required this.contRefId,
    required this.bankRefId,
    required this.rzpTransacid,
    required this.status,
    required this.amount,
    required this.statusCode,
    required this.message,
  });

  String userId;
  String contRefId;
  String bankRefId;
  String rzpTransacid;
  String status;
  double amount;
  int statusCode;
  String message;

  factory WithdrawRequest.fromJson(Map<String, dynamic> json) =>
      WithdrawRequest(
        userId: json["userId"],
        contRefId: json["contRefId"],
        bankRefId: json["bankRefId"],
        rzpTransacid: json["rzpTransacid"],
        status: json["status"],
        amount: json["amount"],
        statusCode: json["statusCode"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "contRefId": contRefId,
        "bankRefId": bankRefId,
        "rzpTransacid": rzpTransacid,
        "status": status,
        "amount": amount,
        "statusCode": statusCode,
        "message": message,
      };
}
