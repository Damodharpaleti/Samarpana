import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/widgets.dart';

enum LoadMoreStatus { INITIAL, LOADING, STABLE }

class ProductProvider with ChangeNotifier {
  late APIService _apiService;
  late List<Product> _productList;
  late SortBy _sortBy;
  int pageSize = 10;

  List<UserdatafromDB> list = <UserdatafromDB>[];
  late UserdatafromDB model;
  final dbHelper = DBProvider.instance;

  List<Product> get allProducts => _productList;
  double get totalRecords => _productList.length.toDouble();

  LoadMoreStatus _loadMoreStatus = LoadMoreStatus.STABLE;

  getLoadMoreStatus() => _loadMoreStatus;

  ProductProvider() {
    resetStreams();
    _sortBy = SortBy("modified", "Latest", "asc");
  }

  void resetStreams() {
    _apiService = APIService();
    _productList = <Product>[];
  }

  setLoadingStatus(LoadMoreStatus loadMoreStatus) {
    _loadMoreStatus = loadMoreStatus;
    notifyListeners();
  }

  setSortOrder(SortBy sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  fetchProduct(pageNumber,
      {String? strSearch,
      String? tagName,
      int categoryId = 0,
      String? sortBy,
      String sortOrder = "asc"}) async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
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

    String token = model.token ?? '';
    String mobileNumber = model.mobileNumber ?? '';
    List<Product> itemModel = await _apiService.getProduct(
        cId: categoryId,
        strSearch: strSearch ?? '',
        sortBy: this._sortBy.value,
        pageNumber: pageNumber,
        pageSize: this.pageSize,
        token: token,
        sortOrder: this._sortBy.sortOrder);

    if (itemModel.length > 0) {
      _productList.addAll(itemModel);
    }
    setLoadingStatus(LoadMoreStatus.STABLE);
  }
}

class SortBy {
  String value;
  String text;
  String sortOrder;

  SortBy(this.value, this.text, this.sortOrder);
}
