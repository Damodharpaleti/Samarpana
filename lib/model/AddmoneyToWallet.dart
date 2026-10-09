class AddMoneyToWallet {
  AddMoneyToWallet({
    required this.userId,
    required this.amount,
    required this.transactionid,
  });

  String userId;
  String amount;
  String transactionid;

  factory AddMoneyToWallet.fromJson(Map<String, dynamic> json) =>
      AddMoneyToWallet(
        userId: json["userId"],
        amount: json["amount"],
        transactionid: json["transactionid"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "amount": amount,
        "transactionid": transactionid,
      };
}
