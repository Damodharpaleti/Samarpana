class WalletBalancemodel {
  WalletBalancemodel({
    required this.walletBalance,
  });

  double walletBalance;

  factory WalletBalancemodel.fromJson(Map<String, dynamic> json) {
    var balance = json["walletBalance"];
    double walletBalanceValue = 0.0;
    
    if (balance != null) {
      if (balance is double) {
        walletBalanceValue = balance;
      } else if (balance is int) {
        walletBalanceValue = balance.toDouble();
      } else if (balance is String) {
        walletBalanceValue = double.tryParse(balance) ?? 0.0;
      }
    }
    
    return WalletBalancemodel(
      walletBalance: walletBalanceValue,
    );
  }

  Map<String, dynamic> toJson() => {
        "walletBalance": walletBalance,
      };
}
