
class VendorAccountdetails {
  VendorAccountdetails({
    this.accountNumber,
    this.mobileNumber,
    this.walletamt,
    this.message,
    this.statusCode,
    this.rzpContactId,
  });

  String? accountNumber;
  String? mobileNumber;
  double? walletamt;
  int? statusCode;
  String? message;
  String? rzpContactId;

  factory VendorAccountdetails.fromJson(Map<String, dynamic> json) =>
      VendorAccountdetails(
        accountNumber: json["accountNumber"],
        mobileNumber: json["mobileNumber"],
        walletamt: json["walletamt"],
        message: json["message"],
        statusCode: json["statusCode"],
        rzpContactId: json["rzpContactId"],
      );

  Map<String, dynamic> toJson() => {
        "accountNumber": accountNumber,
        "mobileNumber": mobileNumber,
        "walletamt": walletamt,
        "message": message,
        "statusCode": statusCode,
        "rzpContactId": rzpContactId,
      };
}

class Contactadded {
  Contactadded({
    this.rzpcontactid,
    this.mobileNumber,
  });

  String? rzpcontactid;
  String? mobileNumber;

  factory Contactadded.fromJson(Map<String, dynamic> json) => Contactadded(
        rzpcontactid: json["rzpcontactid"],
        mobileNumber: json["mobileNumber"],
      );

  Map<String, dynamic> toJson() => {
        "rzpcontactid": rzpcontactid,
        "mobileNumber": mobileNumber,
      };
}

class BankContactadded {
  BankContactadded({
    required this.rzpbankid,
    required this.mobileNumber,
    required this.message,
    required this.statusCode,
  });

  String rzpbankid;
  String mobileNumber;
  String message;
  int statusCode;

  factory BankContactadded.fromJson(Map<String, dynamic> json) =>
      BankContactadded(
        rzpbankid: json["rzpbankid"],
        mobileNumber: json["mobileNumber"],
        message: json["statuscode"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "rzpbankid": rzpbankid,
        "mobileNumber": mobileNumber,
        "message": message,
        "statusCode": statusCode,
      };
}

class Bankresponse {
  Bankresponse({
    this.message,
    this.statusCode,
  });

  String? message;
  int? statusCode;

  factory Bankresponse.fromJson(Map<String, dynamic> json) => Bankresponse(
        message: json["statuscode"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "statusCode": statusCode,
      };
}

class CreateContact {
  CreateContact({
    this.name,
    this.email,
    this.contact,
    this.type,
    this.referenceId,
  });

  String? name;
  String? email;
  String? contact;
  String? type;
  String? referenceId;

  factory CreateContact.fromJson(Map<String, dynamic> json) => CreateContact(
        name: json["name"],
        email: json["email"],
        contact: json["contact"],
        type: json["type"],
        referenceId: json["reference_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "contact": contact,
        "type": type,
        "reference_id": referenceId,
      };
}

class FundAccount {
  FundAccount({
    required this.contactId,
    required this.accountType,
    required this.bankAccount,
  });

  String contactId;
  String accountType;
  BankAccount bankAccount;

  factory FundAccount.fromJson(Map<String, dynamic> json) => FundAccount(
        contactId: json["contact_id"],
        accountType: json["account_type"],
        bankAccount: BankAccount.fromJson(json["bank_account"]),
      );

  Map<String, dynamic> toJson() => {
        "contact_id": contactId,
        "account_type": accountType,
        "bank_account": bankAccount.toJson(),
      };
}

class BankAccount {
  BankAccount({
    required this.name,
    required this.ifsc,
    required this.account_number,
  });

  String name;
  String ifsc;
  String account_number;

  factory BankAccount.fromJson(Map<String, dynamic> json) => BankAccount(
        name: json["name"],
        ifsc: json["ifsc"],
        account_number: json["account_number"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ifsc": ifsc,
        "account_number": account_number,
      };
}

class ContactResponse {
  ContactResponse({
    this.id,
    this.entity,
    this.name,
    this.contact,
    this.email,
    this.type,
    this.referenceId,
    this.batchId,
    this.active,
    this.createdAt,
  });

  String? id;
  String? entity;
  String? name;
  String? contact;
  String? email;
  String? type;
  String? referenceId;
  dynamic batchId;
  bool? active;

  int? createdAt;

  factory ContactResponse.fromJson(Map<String, dynamic> json) =>
      ContactResponse(
        id: json["id"],
        entity: json["entity"],
        name: json["name"],
        contact: json["contact"],
        email: json["email"],
        type: json["type"],
        referenceId: json["reference_id"],
        batchId: json["batch_id"],
        active: json["active"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "name": name,
        "contact": contact,
        "email": email,
        "type": type,
        "reference_id": referenceId,
        "batch_id": batchId,
        "active": active,
        "created_at": createdAt,
      };
}

class FundAccountResponse {
  FundAccountResponse({
    required this.id,
    required this.entity,
    required this.contactId,
    required this.accountType,
    required this.bankAccount,
    required this.batchId,
    required this.active,
    required this.createdAt,
  });

  String id;
  String entity;
  String contactId;
  String accountType;
  BankAccount bankAccount;
  dynamic batchId;
  bool active;
  int createdAt;

  factory FundAccountResponse.fromJson(Map<String, dynamic> json) =>
      FundAccountResponse(
        id: json["id"],
        entity: json["entity"],
        contactId: json["contact_id"],
        accountType: json["account_type"],
        bankAccount: BankAccount.fromJson(json["bank_account"]),
        batchId: json["batch_id"],
        active: json["active"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "contact_id": contactId,
        "account_type": accountType,
        "bank_account": bankAccount.toJson(),
        "batch_id": batchId,
        "active": active,
        "created_at": createdAt,
      };
}

class Error {
  Error({
    required this.code,
    required this.description,
    this.source,
    this.step,
    this.reason,
    required this.metadata,
    required this.field,
  });

  String code;
  String description;
  dynamic source;
  dynamic step;
  dynamic reason;
  Metadata metadata;
  String field;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        code: json["code"],
        description: json["description"],
        source: json["source"],
        step: json["step"],
        reason: json["reason"],
        metadata: Metadata.fromJson(json["metadata"]),
        field: json["field"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "source": source,
        "step": step,
        "reason": reason,
        "metadata": metadata.toJson(),
        "field": field,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
