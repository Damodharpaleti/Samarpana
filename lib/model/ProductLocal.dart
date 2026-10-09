class ProductLocal {
  late int productId;
  late String productCode;
  late String productName;
  late String price;
  late String marketPrice;
  late int priceMinQuantity;
  late String brandname;
  late int priceId;
  late int? cityId;
  late int numOfItems;
  late double totalPrice;
  late String? productDescription;

  ProductLocal(
    this.productId,
    this.productCode,
    this.productName,
    this.price,
    this.marketPrice,
    this.priceMinQuantity,
    this.brandname,
    this.priceId,
    this.cityId,
    this.numOfItems,
    this.totalPrice,
    this.productDescription,
  );

  ProductLocal.fromJson(Map<String, dynamic> json) {
    productId = json['productId'] as int? ?? 0;
    productCode = json['productCode'] as String? ?? '';
    productName = json['productName'] as String? ?? '';
    price = (json['price'] ?? 0).toString();
    marketPrice = (json['marketPrice'] ?? 0).toString();
    priceMinQuantity = json['priceMinQuantity'] as int? ?? 0;
    brandname = json['brandname'] as String? ?? '';
    priceId = json['priceId'] as int? ?? 0;
    cityId = json['cityId'] as int?;
    numOfItems = json['numOfItems'] as int? ?? 1;
    totalPrice = (json['totalPrice'] as num?)?.toDouble() ?? 0.0;
    productDescription = json['productDescription'] as String?;
  }
  Map<String, dynamic> toMap() {
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
      'totalprice': totalPrice,
      'productDescription': productDescription,
    };
  }

  Map<String, dynamic> toJson() => {
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
        'totalprice': totalPrice,
        'productDescription': productDescription,
      };
}
