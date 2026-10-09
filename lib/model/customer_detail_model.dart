class CustomerDetails {
  int id;
  String firstName;
  String lastName;
  Billing? billing;
  Shipping? shipping;
  CustomerDetails(
      {required this.id, required this.firstName, required this.lastName, required this.billing, required this.shipping});
  CustomerDetails.fromjson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        firstName = json['firstName'] ?? '',
        lastName = json['lastName'] ?? '',
        billing = json['billing'] != null ? Billing.fromjson(json['billing']) : null,
        shipping = json['shipping'] != null ? Shipping.fromjson(json['shipping']) : null;
}

class Billing {
  String firstName;
  String lastName;
  String address1;
  String address2;
  String city;
  String postalCode;
  String country;
  String state;
  String email;
  String phone;
  Billing(
      {required this.firstName,
      required this.lastName,
      required this.address1,
      required this.address2,
      required this.city,
      required this.postalCode,
      required this.country,
      required this.state,
      required this.email,
      required this.phone});
  Billing.fromjson(Map<String, dynamic> json)
      : firstName = json['firstName'] ?? '',
        lastName = json['lastName'] ?? '',
        address1 = json['address1'] ?? '',
        address2 = json['address2'] ?? '',
        city = json['city'] ?? '',
        postalCode = json['postalCode'] ?? '',
        country = json['country'] ?? '',
        state = json['state'] ?? '',
        email = json['email'] ?? '',
        phone = json['phone'] ?? '';
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['postalCode'] = this.postalCode;
    data['country'] = this.country;
    data['state'] = this.state;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Shipping {
  String firstName;
  String lastName;
  String address1;
  String address2;
  String city;
  String postalCode;
  String country;
  String state;
  String mobile;
  String email;
  Shipping(
      {required this.firstName,
      required this.lastName,
      required this.address1,
      required this.address2,
      required this.city,
      required this.country,
      required this.postalCode,
      required this.mobile,
      required this.email,
      required this.state});
  Shipping.fromjson(Map<String, dynamic> json)
      : firstName = json['firstName'] ?? '',
        lastName = json['lastName'] ?? '',
        address1 = json['address1'] ?? '',
        address2 = json['address2'] ?? '',
        city = json['city'] ?? '',
        postalCode = json['postalCode'] ?? '',
        country = json['country'] ?? '',
        state = json['state'] ?? '',
        mobile = json['mobile'] ?? '',
        email = json['email'] ?? '';
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['postalCode'] = this.postalCode;
    data['country'] = this.country;
    data['state'] = this.state;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    return data;
  }
}
