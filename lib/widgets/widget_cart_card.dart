import 'package:Samarpana/model/ProductLocal.dart';
import 'package:Samarpana/pages/cart_place_order.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import '../config.dart';

class cartpage extends StatefulWidget {
  int boxCarts = 0;
  @override
  _cartpageState createState() => _cartpageState();
}

class _cartpageState extends State<cartpage> {
  //
  @override
  void initState() {
    _query();
  }

  final dbHelper = DBProvider.instance;

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: true,
        title: Column(
          children: [
            Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${this.widget.boxCarts} items",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<List<ProductLocal>>(
        //future: _fetchOrderDetails(),
        future: _query(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductLocal> dataset = snapshot.data!;
            this.widget.boxCarts = dataset.length;
            return _orderDetailsListView(dataset);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<ProductLocal>> _query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    allRows.forEach((row) => print(row));
    List darta = allRows;
    return darta
        .map((productLocal) => new ProductLocal.fromJson(productLocal))
        .toList();
  }

  ListView _orderDetailsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 3.0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(Config.imageurl +
                                  data[index].productCode +
                                  '.png')))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 9, top: 3, bottom: 3),
                      child: Expanded(
                          child: Text(data[index].productName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 9, top: 3, bottom: 3, right: 12),
                      child: Expanded(
                          child: Text(
                              'Totol Price' + ' ${data[index].totalPrice}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  left: 9, top: 3, bottom: 3, right: 12),
                              child: Expanded(
                                  child: Text(
                                      '\u20B9' + ' ' + data[index].price,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PlaceOder(
                                  data: data[index],
                                  numOfItems: data[index].numOfItems,
                                ))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
