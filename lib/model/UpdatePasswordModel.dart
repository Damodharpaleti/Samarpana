class UpdatePasswordModel {
  UpdatePasswordModel({
    required this.mobileNumber,
    required this.accessCode,
    required this.oldPassword,
    required this.newPassword,
    required this.message,
    required this.statusCode,
  });

  String mobileNumber;
  String accessCode;
  String oldPassword;
  String newPassword;
  int statusCode;
  String message;

  factory UpdatePasswordModel.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordModel(
        mobileNumber: json["mobileNumber"],
        accessCode: json["accessCode"],
        oldPassword: json["oldPassword"],
        newPassword: json["newPassword"],
        message: json["message"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "mobileNumber": mobileNumber,
        "accessCode": accessCode,
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "message": message,
        "statusCode": statusCode,
      };
}
