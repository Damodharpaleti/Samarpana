
// class Category {
//   int categoryId;
//   String categoryName;
//   String categoryDescription;
//   int subId;
//   String image;

//   Category(this.categoryId, this.categoryName, this.categoryDescription,
//       this.subId, this.image);
//   Category.fromJson(Map<String, dynamic> json) {
//     categoryId = json['id'];
//     categoryName = json['categoryName'];
//     categoryDescription = json['categoryDescription'];
//     subId = json['subId'];
//     image = json['image'];
//   }
// }
class Category {
  int? id;
  String? categoryName;
  String? categoryDescription;
  int? subId;
  int? categoryId;
  String? categoryCode;
  String? image;

  Category(
      {this.id,
      this.categoryName,
      this.categoryDescription,
      this.subId,
      this.categoryId,
      this.categoryCode,
      this.image});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
    categoryDescription = json['categoryDescription'];
    subId = json['subId'];
    categoryId = json['categoryId'];
    categoryCode = json['categoryCode'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['categoryDescription'] = this.categoryDescription;
    data['subId'] = this.subId;
    data['categoryId'] = this.categoryId;
    data['categoryCode'] = this.categoryCode;
    data['image'] = this.image;
    return data;
  }
}
