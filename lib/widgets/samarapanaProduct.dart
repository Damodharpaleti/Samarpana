
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/pages/base_page.dart';
import 'package:Samarpana/pages/cart_page.dart';
import 'package:Samarpana/pages/categorylist.dart';
import 'package:Samarpana/provider/product_provider.dart';

import 'package:Samarpana/widgets/widget_product_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';



class samarapanaProduct extends BasePage {
  samarapanaProduct({required Key key, required this.categoryId}) : super(key: key);

  int categoryId;

  @override
  _samarapanaProductState createState() => _samarapanaProductState();
}

class _samarapanaProductState extends BasePageState<samarapanaProduct> {
  int _pageNumber = 1;
  ScrollController _scrollController = new ScrollController();

  final _searchQuery = new TextEditingController();
  late Timer _debounds;

  final _sortByOptions = [
    SortBy('papularity', 'papularity', 'asc'),
    SortBy('modified', 'Latest', 'asc'),
    SortBy('price', 'Price: High to Low', 'desc'),
    SortBy('price', 'Price: Low to High', 'asc')
  ];
  @override
  void initState() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingStatus(LoadMoreStatus.INITIAL);
    productList.fetchProduct(_pageNumber, categoryId: this.widget.categoryId);
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     productList.setLoadingStatus(LoadMoreStatus.LOADING);
    //     productList.fetchSearchProduct(_searchQuery.text);
    //   }
    // });

    _searchQuery.addListener(_onSearchChange);
    super.initState();
  }

  _onSearchChange() {
    var productList = Provider.of<ProductProvider>(context, listen: false);
    if (_debounds.isActive ?? false) _debounds.cancel();
    _debounds = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery.text.isNotEmpty) {
        //productList.setLoadingStatus(LoadMoreStatus.INITIAL);
        productList.resetStreams();
        //  productList.fetchSearchProduct(_searchQuery.text);
      } else {
        productList.resetStreams();
        productList.setLoadingStatus(LoadMoreStatus.INITIAL);
        productList.fetchProduct(_pageNumber,
            categoryId: this.widget.categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      return new WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => categorylist(),
              ),
            );
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Color.fromRGBO(123, 212, 165, 1),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  //Navigator.pop(context);
                  print("Add Navigation Here");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => categorylist(
                          //  status: pending,
                          ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Text(
                'Products',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                new IconButton(
                    icon: new Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    }),
                list.length == 0
                    ? new Container()
                    : new Positioned(
                        child: new Stack(
                          children: <Widget>[
                            new Icon(
                              Icons.brightness_1,
                              size: 20,
                              color: Colors.red[600],
                            ),
                            new Positioned(
                              top: 4.0,
                              right: 4.0,
                              child: new Center(
                                child: new Text(
                                  '10',
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ], systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              child: pageUI(),
            ),
          ));
    });
  }

  @override
  Widget pageUI() {
    return _productList();
  }

  Widget _productList() {
    return new Consumer<ProductProvider>(builder: (
      BuildContext context,
      productsModel,
      child,
    ) {
      if (productsModel.allProducts.length > 0 &&
          productsModel.getLoadMoreStatus() != LoadMoreStatus.INITIAL) {
        return _buildProductList(productsModel.allProducts,
            productsModel.getLoadMoreStatus() == LoadMoreStatus.LOADING);
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _buildProductList(List<Product> items, bool isLoadMore) {
    return Column(
      children: [
        _productFilter(),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            controller: _scrollController,
            //crossAxisCount: 2,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: items.map((Product item) {
              return ProductCard(data: item);
            }).toList(),
          ),
        ),
        Visibility(
          child: Container(
            padding: EdgeInsets.all(5),
            height: 35.0,
            width: 35.0,
            child: CircularProgressIndicator(),
          ),
          visible: isLoadMore,
        ),
      ],
    );
  }

  Widget _productFilter() {
    return Container(
      height: 51,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _searchQuery,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: "Search...",
                hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.blueGrey[100],
                filled: true,
              ),
            ),
          ),
          // SizedBox(
          //   width: 15,
          // ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: Color(0xffe6e6ec),
          //     borderRadius: BorderRadius.circular(9.0),
          //   ),
          //   child: PopupMenuButton(
          //     onSelected: (sortBy) {
          //       var productList =
          //           Provider.of<ProductProvider>(context, listen: false);
          //       productList.resetStreams();
          //       productList.setSortOrder(sortBy);
          //       productList.fetchProduct(_pageNumber,
          //           categoryId: this.widget.categoryId);
          //     },
          //     itemBuilder: (BuildContext context) {
          //       return _sortByOptions.map((item) {
          //         return PopupMenuItem(
          //             value: item,
          //             child: Container(
          //               child: Text(item.text),
          //             ));
          //       }).toList();
          //     },
          //     icon: Icon(Icons.tune),
          //   ),
          // )
        ],
      ),
    );
  }
}


// class samarapanaProduct extends StatefulWidget {
//   samarapanaProduct({Key key, this.categoryId}) : super(key: key);

//   int categoryId;
//   //int x = categoryId;
//   //String status;
//   // Myorders orderModel;
//   SamarpanaProductDetails samarpanaProductModel;
//   @override
//   _samarapanaProductState createState() => _samarapanaProductState();
// }

// class _samarapanaProductState extends State<samarapanaProduct> {
//   List<UserdatafromDB> list = new List();
//   final dbHelper = DBProvider.instance;
//   UserdatafromDB model;

//   @override
//   void initState() {
//     super.initState();
//     // fetch();
//     var orderProvider = Provider.of<CartProvider>(context, listen: false);
//     orderProvider.fetchMySamarpanaProduct(categoryId: this.widget.categoryId);
//   }

//   // fetch() async {
//   //   final allRows = await dbHelper.queryuserRows();
//   //   allRows.forEach((row) => {
//   //         print(allRows),
//   //         model = UserdatafromDB(
//   //           row["id"].toString(),
//   //           row["firstName"],
//   //           row["lastName"],
//   //           row["address1"],
//   //           row["address2"],
//   //           row["state"],
//   //           row["city"],
//   //           row["pinCode"],
//   //           row["mobileNumber"],
//   //           row["token"],
//   //         ),
//   //         list.add(model)
//   //       });
//   //   setState(() {});
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return new Consumer<CartProvider>(
//         builder: (context, samarpanaProductModel, child) {
//       if (samarpanaProductModel.deliverylist != null &&
//           samarpanaProductModel.deliverylist.length > 0) {
//         _single();
//         //  _listview(context, samarpanaProductModel.samarpanaproductdetailList);
//       }
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           title: Text(
//             'samarpana Orders',
//             style: TextStyle(color: Colors.white),
//           ),
//           actions: [
//             SizedBox(
//               width: 10,
//             ),
//           ],
//         ),
//         // drawer: DrawerWidget(),
//         body: Container(
//           margin: EdgeInsets.all(10),
//           // child:_single(),
//           child: _listview(
//               context, samarpanaProductModel.samarpanaproductdetailList),
//         ),
//       );
//     });
//   }

//   Widget _single() {
//     return SingleChildScrollView(
//       child: Row(
//         children: <Widget>[
//           Text('data'),
//           Divider(
//             color: Colors.grey,
//           ),
//           // _listview(context, ordermodel.paymentslist);
//         ],
//       ),
//     );
//   }

//   Widget _listview(BuildContext context, List<SamarpanaProductDetails> orders) {
//     return orders.length == 0
//         ? Center(
//             child: Text('Samarpana',
//                 style: TextStyle(fontSize: 20, color: Colors.black)))
//         : new ListView.builder(
//             itemCount: orders.length,
//             physics: ScrollPhysics(),
//             padding: EdgeInsets.all(8),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               return Row(children: [
//                 SizedBox(
//                   width: 316,
//                   child: GestureDetector(
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => ProductDetailsWidget(
//                       //             data: orders[index],
//                       //           ),
//                       //       settings: RouteSettings(
//                       //         arguments: orders[index],
//                       //       )),
//                       // );
//                       print("inside samarpana product >>>>>>>>>>>>>>>>>>>");
//                       print(this.widget.categoryId);
//                       //ProductDetailsWidget
//                       print("inside samarpana product >>>>>>>>>>>>>>>>>>>");
//                     },
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           height: 165,
//                           margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//                           decoration: BoxDecoration(
//                               color: Colors.transparent,
//                               border: Border.all(),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(16))),
//                           child: Row(
//                             children: <Widget>[
//                               SizedBox(height: 10),
//                               Column(
//                                 children: [
//                                   Container(
//                                       margin: EdgeInsets.only(
//                                           right: 0,
//                                           left: 0,
//                                           top: 20,
//                                           bottom: 8),
//                                       width: 100,
//                                       height: 130,
//                                       padding:
//                                           const EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(20)),
//                                           color: Colors.transparent,
//                                           image: DecorationImage(
//                                               fit: BoxFit.fill,
//                                               image: NetworkImage(
//                                                 Config.imageurl +
//                                                     orders[index].productCode +
//                                                     '.png',
//                                               ))))
//                                 ],
//                               ),
//                               Expanded(
//                                 child: Container(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.max,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Align(
//                                         alignment: Alignment.center,
//                                       ),
//                                       Container(
//                                         padding:
//                                             EdgeInsets.only(right: 8, top: 4),
//                                         child: Text(
//                                           '${orders[index].productName}',
//                                           maxLines: 2,
//                                           softWrap: true,
//                                           style: CustomTextStyle
//                                               .textFormFieldSemiBold
//                                               .copyWith(fontSize: 18),
//                                         ),
//                                       ),
//                                       Expanded(
//                                           child: Text(
//                                               'Market Price' +
//                                                   ' ${orders[index].marketPrice}',
//                                               style: TextStyle(
//                                                 height: 1.5,
//                                                 decoration:
//                                                     TextDecoration.lineThrough,
//                                                 fontSize: 18,
//                                                 color: Colors.red,
//                                                 fontWeight: FontWeight.bold,
//                                               ))),
//                                       Expanded(
//                                           child: Text(
//                                               'Min Quantity' +
//                                                   ' ${orders[index].productQuantity}',
//                                               style: TextStyle(
//                                                 height: 1,
//                                                 // decoration: TextDecoration.lineThrough,
//                                                 fontSize: 16,
//                                                 color: Colors.black,
//                                                 fontWeight: FontWeight.bold,
//                                               ))),
//                                       Container(
//                                         padding: EdgeInsets.only(bottom: 7),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: <Widget>[
//                                             Text(
//                                               '\u20B9' +
//                                                   ' ' +
//                                                   '${orders[index].priceValue}',
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.black),
//                                             ),
//                                             Padding(
//                                                 // padding:
//                                                 //     const EdgeInsets.all(8.0),
//                                                 padding:
//                                                     EdgeInsets.only(bottom: 7),
//                                                 child: CartCounter(
//                                                   data: orders[index],
//                                                   numOfItems: 0,
//                                                 )
//                                                 // child: Text("Add"),
//                                                 )
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 flex: 1,
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//               ]);
//             });
//   }
// }
