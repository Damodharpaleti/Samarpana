import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/components/CategoryProvider.dart';
import 'package:Samarpana/components/cart_provider.dart';

import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/category.dart';
import 'package:Samarpana/pages/Delivery_status.dart';

import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/drawer.dart';
import 'package:Samarpana/widgets/samarapanaProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class categorylist extends StatefulWidget {
  //category({Key key, this.status}) : super(key: key);

  late String status;
  late Category categoryModel;

  @override
  categorylistState createState() => categorylistState();
}

class categorylistState extends State<categorylist> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late APIService apiService;

  @override
  void initState() {
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.gettotalamout();
    super.initState();
    //fetch();
    var categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    categoryProvider.fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    return new Consumer<CategoryProvider>(
        builder: (context, categoryModel, child) {
      if (categoryModel.categoryList.length > 0) {
        //_single();
        // _categoryList(context, categoryModel.categoryList);
      }
      return new WillPopScope(
          onWillPop: () async {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderStatus(status: "P")),
                );
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(123, 212, 165, 1),
              centerTitle: true,
              title: Text(
                'Categories',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            //drawer: DrawerWidget(),
            drawer: DrawerWidget(),
            body: Container(
              margin: EdgeInsets.all(10),
              // child:_single(),
              child: _categoryList(context, categoryModel.categoryList),
            ),
          ));
    });
  }

  Widget _categoryList(BuildContext context, List<Category> categories) {
    return GridView.builder(
      itemCount: categories.length,
      //var data = categories,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, int index) {
        var data = categories[index];
        return new GestureDetector(
            onTap: () {
              print(">>>>>>>>>>>>>>>>>img on tap");
              print(categories[index].categoryId);
              print(categories[index].categoryName);
              print(">>>>>>>>>>>>>>>>>img on tap");
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => samarapanaProduct(
                    key: ValueKey(data.categoryId),
                    categoryId: data.categoryId ?? 0,
                  ),
                ),
              );
            },
            child: Center(
              child: Container(
                child: new Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Image.network(Config.imageurl + (data.categoryCode ?? '') + '.png',
                        width: 120.0,
                        height: 120.0,
                        
                        
                        alignment: Alignment.center,
                        fit: BoxFit.cover),
                        
                    SizedBox(
                      height: 5,
                    ),
                Text(
                  data.categoryName ?? '',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
        // onTap:
        // () => gridClicked(index);
      },
    );

    // return Container(
    //   height: 150,
    //   alignment: Alignment.centerLeft,
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     physics: ClampingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     itemCount: categories.length,
    //     itemBuilder: (context, index) {
    //       var data = categories[index];
    //       return GestureDetector(
    //           onTap: () {
    //             // Navigator.push(
    //             //     context,
    //             //     MaterialPageRoute(
    //             //         builder: (context) => ProductPage(
    //             //               categoryId: data.categoryId,
    //             //             )));

    //             print("on tap category imgs>>>>>>>>>>>>>>>>>>>>>>");
    //           },
    //           child: Column(
    //             children: [
    //               Container(
    //                 margin: EdgeInsets.all(10),
    //                 width: 80,
    //                 height: 80,
    //                 alignment: Alignment.center,
    //                 child: Image.network(
    //                   Config.imageurl + data.categoryCode + '.png',
    //                   height: 80,
    //                 ),
    //                 decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: Colors.white,
    //                     boxShadow: [
    //                       BoxShadow(
    //                           color: Colors.black12,
    //                           offset: Offset(0, 5),
    //                           blurRadius: 15),
    //                     ]),
    //               ),
    //               Row(
    //                 children: [
    //                   Text(data.categoryName.toString(),
    //                       style: TextStyle(
    //                           fontSize: 18, fontWeight: FontWeight.bold)),
    //                   Icon(
    //                     Icons.keyboard_arrow_right,
    //                     size: 14,
    //                   )
    //                 ],
    //               ),
    //             ],
    //           ));
    //     },
    //   ),
    // );
  }
}
