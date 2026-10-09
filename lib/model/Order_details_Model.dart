class OrderModel {
  OrderModel({
    required this.orderId,
    required this.invoiceNumber,
    required this.totalprice,
    required this.invoiceStatus,
    required this.deliveryTime,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.orderdate,
    required this.mobile,
    required this.productList,
    required this.paymentMethod,
    required this.deliveryCharges,
  });

  int orderId;
  String invoiceNumber;
  double totalprice;
  String invoiceStatus;
  String deliveryTime;
  String address;
  String city;
  String state;
  String pincode;
  String orderdate;
  String mobile;
  String paymentMethod;
  List<ProductLists> productList;
  int deliveryCharges;

  OrderModel.fromJson(Map<String, dynamic> json)
      : orderId = json["orderId"] ?? 0,
        invoiceNumber = json["invoiceNumber"]?.toString() ?? '',
        totalprice = double.tryParse(json["totalprice"]?.toString() ?? '0') ?? 0.0,
        invoiceStatus = json["invoiceStatus"]?.toString() ?? '',
        deliveryTime = json["deliveryTime"]?.toString() ?? '',
        address = json["address"]?.toString() ?? '',
        city = json["city"]?.toString() ?? '',
        state = json["state"]?.toString() ?? '',
        pincode = json["pincode"]?.toString() ?? '',
        orderdate = json["orderdate"]?.toString() ?? '',
        mobile = json["mobile"]?.toString() ?? '',
        paymentMethod = json["paymentMethod"]?.toString() ?? '',
        deliveryCharges = json["deliveryCharges"] ?? 0,
        productList = json["productList"] != null ? List<ProductLists>.from(
            json["productList"].map((x) => ProductLists.fromJson(x))) : [];

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "invoiceNumber": invoiceNumber,
        "totalprice": totalprice,
        "invoiceStatus": invoiceStatus,
        "deliveryTime": deliveryTime,
        "address": address,
        "city": city,
        "state": state,
        "pincode": pincode,
        "orderdate": orderdate,
        "mobile": mobile,
        "paymentMethod": paymentMethod,
        "deliveryCharges": deliveryCharges,
        "productList": List<dynamic>.from(productList.map((x) => x.toJson())),
      };
}

class ProductLists {
  ProductLists({
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.price,
    required this.marketPrice,
    required this.priceMinQuantity,
    required this.brandname,
    required this.priceId,
    required this.cityId,
    required this.numOfItems,
    required this.totalPrice,
  });

  int productId;
  String productCode;
  String productName;
  String price;
  String marketPrice;
  int priceMinQuantity;
  String brandname;
  int priceId;
  int cityId;
  String numOfItems;
  String totalPrice;

  ProductLists.fromJson(Map<String, dynamic> json)
      : productId = json["productId"] ?? 0,
        productCode = json["productCode"]?.toString() ?? '',
        productName = json["productName"]?.toString() ?? '',
        price = json["price"]?.toString() ?? '0',
        marketPrice = json["marketPrice"]?.toString() ?? '0',
        priceMinQuantity = json["priceMinQuantity"] ?? 0,
        brandname = json["brandname"]?.toString() ?? '',
        priceId = json["priceId"] ?? 0,
        cityId = json["cityId"] ?? 0,
        numOfItems = json["numOfItems"]?.toString() ?? '0',
        totalPrice = json["totalPrice"]?.toString() ?? '0';

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productCode": productCode,
        "productName": productName,
        "price": price,
        "marketPrice": marketPrice,
        "priceMinQuantity": priceMinQuantity,
        "brandname": brandname,
        "priceId": priceId,
        "cityId": cityId,
        "numOfItems": numOfItems,
        "totalPrice": totalPrice,
      };
}
