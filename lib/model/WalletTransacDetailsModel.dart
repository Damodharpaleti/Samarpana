class WalletHistory {
    WalletHistory({
        required this.amount,
        required this.transDate,
        required this.suyogaTrasnId,
        required this.transType,
        required this.description,
    });

    double amount;
    String transDate;
    String suyogaTrasnId;
    String transType;
    String description;

    factory WalletHistory.fromJson(Map<String, dynamic> json) => WalletHistory(
        amount: json["amount"].toDouble(),
        transDate: json["transDate"],
        suyogaTrasnId: json["suyogaTrasnId"],
        transType: json["transType"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "amount": amount,
        "transDate": transDate,
        "suyogaTrasnId": suyogaTrasnId,
        "transType": transType,
        "description": description,
    };
}
