class Product {
  int? productId;
  String? productCode;
  String? productName;
  String? priceValue;
  String? marketPrice;
  int? priceMinQuantity;
  String? brandName;
  int? priceId;
  int? cityId;
  String? productQuantity;
  int? cId;
  String? quantity;
  String? productDescription;

  Product(
    this.productId,
    this.productCode,
    this.productName,
    this.priceValue,
    this.marketPrice,
    this.priceMinQuantity,
    this.brandName,
    this.priceId,
    this.cityId,
    this.productQuantity,
    this.cId,
    this.quantity,
    this.productDescription,
  );

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productCode = json['productCode'];
    productName = json['productName'];
    priceValue = json['priceValue'].toString();
    marketPrice = json['marketPrice'].toString();
    priceMinQuantity = json['priceMinQuantity'];
    brandName = json['brandName'];
    priceId = json['priceId'];
    cityId = json['cityId'];
    productQuantity = json['productQuantity'];
    cId = json["cId"];
    quantity = json["quantity"];
    productDescription = json['productDescription'];
  }
  calculateDiscount() {
    double regularprice = double.parse(this.marketPrice ?? "0");
    double salePrice =
        this.priceValue != "" && this.priceValue != null ? double.parse(this.priceValue!) : regularprice;
    double discount = regularprice - salePrice;
    double disPersent = (discount / regularprice) * 100;
    return disPersent.round();
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productCode': productCode,
      'productName': productName,
      'priceValue': priceValue,
      'marketPrice': marketPrice,
      'priceMinQuantity': priceMinQuantity,
      'brandName': brandName,
      'priceId': priceId,
      'cityId': cityId,
      'productQuantity': productQuantity,
      'cId': cId,
      'quantity': quantity,
      'productDescription': productDescription,
    };
  }
}
