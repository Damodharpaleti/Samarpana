import 'package:Samarpana/model/category.dart';

import 'package:flutter/widgets.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/model/User_Signup_Model.dart';
import 'package:Samarpana/utils/dataBase.dart';

class CategoryProvider with ChangeNotifier {
// ignore: non_constant_identifier_names
  bool _isorderCreated = false;
  late APIService apiService;

  //List<SamarpanaProductDetails> _samarpanaproductdetails;
  late List<Category> _categoryList;
  List<Myorders> _myStatus = [];
  late String moblieNumber;
  final dbHelper = DBProvider.instance;

  // List<SamarpanaProductDetails> get samarpanaproductdetailList =>
  //     _samarpanaproductdetails;

  List<Category> get categoryList => _categoryList;

  List<UserdatafromDB> list = <UserdatafromDB>[];
  late UserdatafromDB model;
  late User user;

  // List<SamarpanaProductDetails> get samarpanaproductdetailList =>
  //     _samarpanaproductdetails;
  // List<CategoryModel> get categoryList => _categoryList;
//CategoryModel

  CategoryProvider() {
    list = <UserdatafromDB>[];
    apiService = APIService();
  }

  fetchCategory() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(allRows);

    String token = model.token ?? '';
    String mobileNumber = model.mobileNumber ?? '';
    String cityname = model.city ?? '';
    print("printing token on categories>>>>>>>>>>>>>>>>");
    print(cityname);
    //print(mobileNumber);
    print("printing token on categories>>>>>>>>>>>>>>>>");
    List<Category> catList = await apiService.getCategory(token, cityname);
    if (catList.length > 0) {
      _categoryList = [];
      _categoryList.addAll(catList);
    }
    notifyListeners();
  }
}
