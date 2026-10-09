class ForgotPasswordOTP {
  ForgotPasswordOTP({
    required this.mobile,
    required this.accessCode,
  });

  String mobile;
  String accessCode;

  factory ForgotPasswordOTP.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordOTP(
        mobile: json["mobile"],
        accessCode: json["accessCode"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "accessCode": accessCode,
      };
}
