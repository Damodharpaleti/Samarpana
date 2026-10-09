
class SamarpanaProductDetails {
  SamarpanaProductDetails({
    // this.active,
    this.brandName,
    this.categoryId,
    this.cityCode,
    this.city_Name,
    this.marketPrice,
    this.priceId,
    this.priceMinQuantity,
    this.priceValue,
    this.productCode,
    this.productDescription,
    this.productId,
    this.productName,
    this.productQuantity,
    this.productTitle,
    this.productWeightUnit,
    this.subCity,
    this.subcategoryId,
  });

  //ByteData active;
  String? brandName;
  int? categoryId;
  int? cityCode;
  String? city_Name;
  double? marketPrice;
  int? priceId;
  int? priceMinQuantity;
  double? priceValue;
  String? productCode;
  String? productDescription;
  int? productId;
  String? productName;
  int? productQuantity;
  String? productTitle;
  String? productWeightUnit;
  String? subCity;
  int? subcategoryId;

  factory SamarpanaProductDetails.fromJson(Map<String, dynamic> json) =>
      SamarpanaProductDetails(
        //  active: json["active"],
        brandName: json["brandName"],
        categoryId: json["categoryId"],
        cityCode: json["cityCode"],
        city_Name: json["city_Name"],
        marketPrice: json["marketPrice"],
        priceId: json["priceId"],
        priceMinQuantity: json["priceMinQuantity"],
        priceValue: json["priceValue"],
        productCode: json["productCode"],
        productDescription: json["productDescription"],
        productId: json["productId"],
        productName: json["productName"],
        productQuantity: json["productQuantity"],
        productTitle: json["productTitle"],
        productWeightUnit: json["productWeightUnit"],
        subCity: json["subCity"],
        subcategoryId: json["subcategoryId"],
      );
  calculateDiscount() {
    double regularprice = this.marketPrice ?? 0.0;
    double salePrice = this.priceValue ?? regularprice;
    double discount = regularprice - salePrice;
    double disPersent = (discount / regularprice) * 100;
    return disPersent.round();
  }

  Map<String, dynamic> toJson() => {
        // "active": active,
        "brandName": brandName,
        "categoryId": categoryId,
        "cityCode": "cityCode",
        "city_Name": city_Name,
        "marketPrice": marketPrice,
        "priceId": priceId,
        "priceMinQuantity": priceMinQuantity,
        "priceValue": priceValue,
        "productCode": productCode,
        "productDescription": productDescription,
        "productId": productId,
        "productName": productName,
        "productQuantity": productQuantity,
        "productTitle": productTitle,
        "productWeightUnit": productWeightUnit,
        "subCity": subCity,
        "subcategoryId": subcategoryId,
      };
}
