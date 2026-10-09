class User {
  User({
    this.emailId,
    this.firstName,
    this.lastName,
    this.location,
    this.address1,
    this.city,
    this.state,
    this.pinCode,
    this.password,
    this.accessCode,
    this.mobileNumber,
    this.roleDetails,
  });

  String? emailId;
  String? firstName;
  String? lastName;
  String? location;
  String? address1;
  String? city;
  String? state;
  String? pinCode;
  String? password;
  String? accessCode;
  String? mobileNumber;
  RoleDetail? roleDetails;

  factory User.fromJson(Map<String, dynamic> json) => User(
      emailId: json["emailId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      location: json["location"],
      address1: json["address1"],
      city: json["city"],
      state: json["state"],
      pinCode: json["pinCode"],
      accessCode: json["accessCode"],
      password: json["password"],
      mobileNumber: json["mobileNumber"],
      roleDetails: json["roleDetails"] != null
          ? new RoleDetail(
              id: 1, name: "ROLE_SABJI", roleDescription: "Subjee User")
          : null);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> userjson = {};
    userjson.addAll({
      "emailId": emailId,
      "firstName": firstName,
      "lastName": lastName,
      "location": location,
      "address1": address1,
      "city": city,
      "accessCode": accessCode,
      "state": state,
      "pinCode": pinCode,
      "password": password,
      "mobileNumber": mobileNumber,
    });
    return userjson;
  }
}

class RoleDetail {
  RoleDetail({
    this.name,
    this.id,
    this.roleDescription,
  });

  String? name;
  int? id;
  String? roleDescription;

  factory RoleDetail.fromJson(Map<String, dynamic> json) => RoleDetail(
        name: json["name"],
        id: json["id"],
        roleDescription: json["roleDescription"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "roleDescription": roleDescription,
      };
}
