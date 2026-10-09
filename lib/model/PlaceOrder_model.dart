
class CreateOrder {
  String? customerId;
  String? paymentMethod;
  String? paymentMethodTitle;
  bool? setPaid;
  String? transactionId;
  String? timeSlot;
  List<ProductList>? productList;
  double? totalAmount;
  String? status;
  Shipping? shipping;
  int? deliveryCharges;
  double? walletamt;
  double? razorpayamt;

  CreateOrder({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.productList,
    this.status,
    this.shipping,
    this.totalAmount,
    this.timeSlot,
    this.deliveryCharges,
    this.walletamt,
    this.razorpayamt,
  });

  CreateOrder.fromJson(Map<String, dynamic> json) {
    customerId = json["customerId"]?.toString();
    paymentMethod = json["paymentMethod"]?.toString();
    paymentMethodTitle = json["paymentMethodTitle"]?.toString();
    // handle bools that may come as bool or string/number
    final sp = json["setPaid"];
    if (sp is bool) {
      setPaid = sp;
    } else if (sp != null) {
      setPaid = sp.toString().toLowerCase() == 'true' || sp.toString() == '1';
    } else {
      setPaid = null;
    }
    transactionId = json["transactionId"]?.toString();
    timeSlot = json["timeSlot"]?.toString();
    status = json["status"]?.toString();
    if (json["shipping"] != null) {
      shipping = Shipping.fromJson(json["shipping"]);
    }
    if (json["productList"] != null) {
      productList = (json["productList"] as List)
          .map((e) => ProductList.fromJson(e))
          .toList();
    }
    if (json["totalAmount"] != null) {
      totalAmount = (json["totalAmount"] as num).toDouble();
    }
    if (json["deliveryCharges"] != null) {
      deliveryCharges = (json["deliveryCharges"] as num).toInt();
    }
    if (json["walletamt"] != null) {
      walletamt = (json["walletamt"] as num).toDouble();
    }
    if (json["razorpayamt"] != null) {
      razorpayamt = (json["razorpayamt"] as num).toDouble();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customerId != null) data["customerId"] = customerId;
    if (paymentMethod != null) data["paymentMethod"] = paymentMethod;
    if (paymentMethodTitle != null) data["paymentMethodTitle"] = paymentMethodTitle;
    if (setPaid != null) data["setPaid"] = setPaid;
    if (timeSlot != null) data["timeSlot"] = timeSlot;
    if (transactionId != null) data["transactionId"] = transactionId;
    if (status != null) data["status"] = status;
    if (shipping != null) data["shipping"] = shipping!.toJson();
    if (totalAmount != null) data["totalAmount"] = totalAmount;
    if (deliveryCharges != null) data["deliveryCharges"] = deliveryCharges;
    if (productList != null) data["productList"] = productList!.map((e) => e.toJson()).toList();
    if (razorpayamt != null) data["razorpayamt"] = razorpayamt;
    if (walletamt != null) data["walletamt"] = walletamt;
    return data;
  }
}

class Shipping {
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? postcode;
  String? country;
  String? email;
  String? phone;

  Shipping({
    this.firstName,
    this.lastName,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.email,
    this.phone,
  });

  Shipping.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName']?.toString();
    lastName = json['lastName']?.toString();
    address1 = json['address1']?.toString();
    address2 = json['address2']?.toString();
    city = json['city']?.toString();
    state = json['state']?.toString();
    // Handle both API field names: postalCode (API) and postcode (legacy)
    postcode = (json['postalCode'] ?? json['postcode'])?.toString();
    country = json['country']?.toString();
    email = json['email']?.toString();
    // Handle both API field names: mobile (API) and phone (legacy)
    phone = (json['mobile'] ?? json['phone'])?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'postalCode': postcode,  // API expects postalCode, not postcode
      'country': country,
      'email': email,
      'mobile': phone,  // API expects mobile, not phone
    };
  }
}

class ProductList {
  ProductList({
    this.productId,
    this.productCode,
    this.productName,
    this.priceId,
    this.price,
    this.marketPrice,
    this.priceMinQuantity,
    this.cityId,
    this.brandname,
    this.numOfItems,
    this.totalPrice,
  });

  int? productId;
  String? productCode;
  String? productName;
  String? price;
  String? marketPrice;
  int? priceMinQuantity;
  String? brandname;
  int? priceId;
  int? cityId;
  String? numOfItems;
  String? totalPrice;

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] != null ? (json['productId'] as num).toInt() : null;
    productCode = json['productCode']?.toString();
    productName = json['productName']?.toString();
    price = json['price']?.toString();
    marketPrice = json['marketPrice']?.toString();
    priceMinQuantity = json['priceMinQuantity'] != null ? (json['priceMinQuantity'] as num).toInt() : null;
    brandname = json['brandname']?.toString();
    priceId = json['priceId'] != null ? (json['priceId'] as num).toInt() : null;
    cityId = json['cityId'] != null ? (json['cityId'] as num).toInt() : null;
    numOfItems = json['numOfItems']?.toString();
    totalPrice = json['totalPrice']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productCode': productCode,
      'productName': productName,
      'price': price,
      'marketPrice': marketPrice,
      'priceMinQuantity': priceMinQuantity,
      'brandname': brandname,
      'priceId': priceId,
      'cityId': cityId,
      'numOfItems': numOfItems,
      'totalPrice': totalPrice
    };
  }
}
