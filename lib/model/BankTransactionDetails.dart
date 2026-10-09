class BankTrascationModel {
  BankTrascationModel({
    required this.amount,
    required this.transDate,
    required this.description,
    required this.status,
    required this.rzpTransId,
  });

  double amount;
  String transDate;
  String description;
  String status;
  String rzpTransId;

  factory BankTrascationModel.fromJson(Map<String, dynamic> json) =>
      BankTrascationModel(
        amount: json["amount"],
        transDate: json["transDate"],
        description: json["description"],
        status: json["status"],
        rzpTransId: json["rzpTransId"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "transDate": transDate,
        "description": description,
        "status": status,
        "rzpTransId": rzpTransId,
      };
}
