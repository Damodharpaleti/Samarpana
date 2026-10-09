import 'package:Samarpana/model/PlaceOrder_model.dart';

class Myorders {
  Myorders({
    this.orderId,
    this.orderUserId,
    this.orderNumber,
    this.orderInvoiceNumber,
    this.orderStatus,
    this.orderFullPrice,
    this.orderDate,
    this.orderType,
    this.productList,
    this.address,
    this.timeslot,
  });

  int? orderId;
  String? orderUserId;
  String? orderNumber;
  String? orderInvoiceNumber;
  String? orderStatus;
  double? orderFullPrice;
  String? orderDate;
  String? orderType;
  String? address;
  String? timeslot;
  List<ProductList>? productList;

  factory Myorders.fromJson(Map<String, dynamic> json) => Myorders(
        orderId: json["orderId"],
        orderUserId: json["orderUserId"],
        orderNumber: json["orderNumber"],
        orderInvoiceNumber: json["orderInvoiceNumber"],
        orderStatus: json["orderStatus"],
        orderFullPrice: json["orderFullPrice"],
        orderDate: json["orderDate"],
        orderType: json["orderType"],
        address: json["address"],
        timeslot: json["timeslot"],
        productList: json["productList"] != null ? List<ProductList>.from(
            json["productList"].map((x) => ProductList.fromJson(x))) : null,
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderUserId": orderUserId,
        "orderNumber": orderNumber,
        "orderInvoiceNumber": orderInvoiceNumber,
        "orderStatus": orderStatus,
        "orderFullPrice": orderFullPrice,
        "orderDate": orderDate,
        "orderType": orderType,
        "address": address,
        "timeslot": timeslot,
        "productList": productList != null ? List<dynamic>.from(productList!.map((x) => x.toJson())) : [],
      };
}

// class ProductList {
//   ProductList({
//     this.productId,
//     this.productCode,
//     this.productName,
//     this.price,
//     this.marketPrice,
//     this.priceMinQuantity,
//     this.brandname,
//     this.priceId,
//     this.cityId,
//     this.numOfItems,
//     this.totalPrice,
//   });

//   int productId;
//   String productCode;
//   String productName;
//   String price;
//   dynamic marketPrice;
//   int priceMinQuantity;
//   dynamic brandname;
//   int priceId;
//   int cityId;
//   int numOfItems;
//   dynamic totalPrice;

//   factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
//         productId: json["productId"],
//         productCode: json["productCode"],
//         productName: json["productName"],
//         price: json["price"],
//         marketPrice: json["marketPrice"],
//         priceMinQuantity: json["priceMinQuantity"],
//         brandname: json["brandname"],
//         priceId: json["priceId"],
//         cityId: json["cityId"],
//         numOfItems: json["numOfItems"],
//         totalPrice: json["totalPrice"],
//       );

//   Map<String, dynamic> toJson() => {
//         "productId": productId,
//         "productCode": productCode,
//         "productName": productName,
//         "price": price,
//         "marketPrice": marketPrice,
//         "priceMinQuantity": priceMinQuantity,
//         "brandname": brandname,
//         "priceId": priceId,
//         "cityId": cityId,
//         "numOfItems": numOfItems,
//         "totalPrice": totalPrice,
//       };
// }
