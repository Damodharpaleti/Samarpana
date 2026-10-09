class LoginResponse {
  LoginResponse({
    this.name,
    this.mobileNumber,
    this.id,
    this.roleDetails,
    this.address,
    this.walletamt,
    this.token,
    this.statusCode,
  });

  String? name;
  String? mobileNumber;
  int? id;
  List<RoleDetails>? roleDetails;
  Address? address;
  dynamic walletamt;
  String? token;
  int? statusCode;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNumber = json['mobileNumber'];
    id = json['id'];
    if (json['roleDetails'] != null) {
      roleDetails = [];
      json['roleDetails'].forEach((v) {
        roleDetails!.add(RoleDetails.fromJson(v));
      });
    }

    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    walletamt = json['walletamt'];
    token = json['token'];
    statusCode = json["statusCode"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = this.name;
    data['mobileNumber'] = this.mobileNumber;
    data['id'] = this.id;
    data['roleDetails'] = this.roleDetails?.map((v) => v.toJson()).toList();
  
    data['address'] = this.address?.toJson();
      data['walletamt'] = this.walletamt;
    data['token'] = this.token;
    return data;
  }
}

class Address {
  Address({
    this.address1,
    this.address2,
    this.city,
    this.pinCode,
    this.state,
  });

  String? address1;
  String? address2;
  String? city;
  String? pinCode;
  String? state;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        pinCode: json["pinCode"].toString(),
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "address1": address1,
        "address2": address2,
        "city": city,
        "pinCode": pinCode,
        "state": state,
      };
}

class RoleDetails {
  String? name;
  int? id;
  Null roleDescription;

  RoleDetails({this.name, this.id, this.roleDescription});

  RoleDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    roleDescription = json['roleDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['roleDescription'] = this.roleDescription;
    return data;
  }
}

// class UserdatafromDB {
//   String firstName, lastName, mobileNumber, address1, address2, city, state;
//   String token;
//   String pinCode;
//   String emailId;
//   dynamic id;
//   dynamic walletamt;

//   UserdatafromDB(
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.address1,
//     this.address2,
//     this.state,
//     this.city,
//     this.pinCode,
//     this.mobileNumber,
//     this.token,
//     this.emailId,
//     this.walletamt,
//   );

//   UserdatafromDB.fromMap(Map<String, dynamic> map) {
//     id = map["id"];
//     firstName = map["firstName"];
//     lastName = map["lastName"];
//     address1 = map["address1"];
//     address2 = map["address2"];
//     state = map["state"];
//     city = map["city"];
//     pinCode = map["pinCode"];
//     mobileNumber = map["mobileNumber"];
//     token = map["token"];
//     emailId = map["emailId"];
//     walletamt = map["walletamt"];
//   }
// }

class UserdatafromDB {
  String? name, mobileNumber, address1, address2, city, state;
  String? token;
  String? pinCode;
  dynamic id;
  dynamic walletamt;

  UserdatafromDB(
    this.id,
    this.name,
    // this.lastName,
    this.address1,
    this.address2,
    this.state,
    this.city,
    this.pinCode,
    this.mobileNumber,
    this.token,
    // this.emailId,
    this.walletamt,
  );

  UserdatafromDB.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    //  lastName = map["lastName"];
    address1 = map["address1"];
    address2 = map["address2"];
    state = map["state"];
    city = map["city"];
    pinCode = map["pinCode"];
    mobileNumber = map["mobileNumber"];
    token = map["token"];
    //  emailId = map["emailId"];
    walletamt = map["walletamt"];
  }
}
