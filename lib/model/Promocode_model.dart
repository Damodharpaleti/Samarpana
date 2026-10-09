class PromocodeModel {
  PromocodeModel({
    required this.userName,
    required this.promoCode,
    required this.totalAmount,
    required this.statusCode,
    required this.discountAmount,
    required this.message,
  });

  String userName;
  String promoCode;
  double totalAmount;
  int statusCode;
  String message;
  double discountAmount;

  factory PromocodeModel.fromJson(Map<String, dynamic> json) => PromocodeModel(
        userName: json["userName"] ?? "",
        promoCode: json["promoCode"] ?? "",
        totalAmount: double.parse(json["totalAmount"].toString()),
        statusCode: json["statusCode"],
        discountAmount: double.parse(json["discountAmount"].toString()),
        message: json["message"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "promoCode": promoCode,
        "totalAmount": totalAmount,
      };
}
