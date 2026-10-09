class AddUserAddress {
  AddUserAddress({
    this.id,
    this.userId,
    this.address1,
    this.address2,
    this.city,
    this.pinCode,
    this.state,
  });

  int? id;
  int? userId;
  String? address1;
  String? address2;
  String? city;
  int? pinCode;
  String? state;

  factory AddUserAddress.fromJson(Map<String, dynamic> json) => AddUserAddress(
        id: json["id"],
        userId: json["userId"],
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        pinCode: json["pinCode"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "address1": address1,
        "address2": address2,
        "city": city,
        "pinCode": pinCode,
        "state": state,
      };
}
