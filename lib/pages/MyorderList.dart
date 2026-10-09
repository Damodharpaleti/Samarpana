import 'dart:io';

import 'package:flutter/services.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/pages/Order_details.dart';
import 'package:Samarpana/pages/categorylist.dart';
import 'package:Samarpana/pages/home.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/utils/form_helper.dart';
import 'package:Samarpana/widgets/widget_cart_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:Samarpana/model/Order_details_Model.dart';
import 'package:provider/provider.dart';
import 'package:Samarpana/components/cart_provider.dart';

class MyOrderDetails extends StatefulWidget {
  const MyOrderDetails({Key? key}) : super(key: key);

  @override
  _MyOrderDetailsState createState() => _MyOrderDetailsState();
}

class _MyOrderDetailsState extends State<MyOrderDetails> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  @override
  void initState() {
    super.initState();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchOrders();
    fetch();
  }

  fetch() async {
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
    print(model.token);
    setState(() {
      build(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      return ordermodel.allOrders.length != 0
          ? _listview(context, ordermodel.allOrders)
          : Scaffold(
              appBar: AppBar(
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                elevation: 0,
                backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'My Orders',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Center(
                child: Text("NO orders",
                    style: TextStyle(color: Colors.black, fontSize: 26)),
              ),
            );
    });
  }

  Widget _listview(BuildContext context, List<OrderModel> orders) {
    return orders.length == 0
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              elevation: 0,
              backgroundColor: Color.fromRGBO(123, 212, 165, 1),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Text(
                'My Orders',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  // Icons.shopping_cart,
                  color: Colors.black,
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => cartpage(),
                      ),
                    );
                  },
                )
              ],
            ),
            body: Center(
                // margin: EdgeInsets.all(10),
                child: Text("NO orders",
                    style: TextStyle(color: Colors.black, fontSize: 26))),
          )
        : new Scaffold(
            appBar: AppBar(
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              elevation: 0,
              backgroundColor: Color.fromRGBO(123, 212, 165, 1),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Text(
                'My Orders',
                style: TextStyle(color: Colors.black),
              ),
              actions: [
                Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  // Icons.shopping_cart,
                  color: Colors.black,
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => cartpage(),
                      ),
                    );
                  },
                )
              ],
            ),
            body: SafeArea(
              // margin: EdgeInsets.all(10),
              child: orderslist(context, orders),
            ),
          );
  }

  Widget orderslist(BuildContext context, List<OrderModel> orders) {
    return ListView(
      children: [
        ListView.builder(
            itemCount: orders.length,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(16.0)),
                child: Column(
                  children: <Widget>[
                    orderStatus("${orders[index].invoiceStatus}"),
                    Divider(color: Colors.red),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconData(
                            Icon(
                              Icons.edit,
                              color: Colors.red,
                              size: 14,
                            ),
                            Text(
                              "Order Number :",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Text("${orders[index].invoiceNumber}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconData(
                            Icon(
                              Icons.date_range,
                              color: Colors.red,
                              size: 12,
                            ),
                            Text(
                              "Order Date :",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )),
                        Text("${orders[index].orderdate}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        flatButton(
                          Row(
                            children: [
                              Text(
                                "Order Details",
                                style: TextStyle(
                                  color: Colors.black,
                                  //letterSpacing: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.chevron_right),
                            ],
                          ),
                          Color.fromRGBO(123, 212, 165, 1),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyordersProductList(
                                        mobileNumber: model.mobileNumber ?? "",
                                        orderModels: orders[index],
                                      ),
                                  settings: RouteSettings(
                                    arguments: orders[index],
                                  )),
                            );
                          },
                        ),
                        if (orders[index].invoiceStatus == "Pending")
                          flatButton(
                            Row(
                              children: [
                                Text(
                                  "Cancel Order",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            Color.fromRGBO(255, 95, 167, 1),
                            () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return object of type Dialog
                                  return AlertDialog(
                                    title: new Text("Suyoga"),
                                    content: new Text(
                                        "Are you sure you want to Cancel"),
                                    actions: <Widget>[
                                      // usually buttons at the bottom of the dialog
                                      TextButton(
                                        child: new Text("No"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: new Text("YES"),
                                        onPressed: () {
                                          orderCancel(
                                            orders[index].invoiceNumber,
                                            model.token ?? "",
                                          ).then((ret) {
                                            if (ret) {
                                              FormHelper.showMessage(
                                                  context,
                                                  "SUYOGA",
                                                  "Your Order Cancelled Succesfully",
                                                  "OK", () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        categorylist(),
                                                  ),
                                                );
                                              });
                                            } else {
                                              FormHelper.showMessage(
                                                  context,
                                                  "SUYOGA",
                                                  "Order Cancel Failed",
                                                  "OK", () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                );
                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

  Future<bool> orderCancel(
    String ordernumber,
    String token,
  ) async {
    bool ret = false;
    String url = Config.url + Config.cancelorder;
    print(url);
    try {
      final response = await Dio().put(
        url,
        data: {
          "orderNumber": ordernumber,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        ret = true;
        print(url);
        print(response.data);

        //  print(model.token);
      }
    } on DioException catch (e) {
      print(e.message);
      ret = false;
    }
    return ret;
  }

  Widget iconData(Icon iconData, Text textdata) {
    return Row(
      children: <Widget>[
        iconData,
        SizedBox(
          width: 10,
        ),
        textdata,
      ],
    );
  }

  Widget flatButton(
    Widget iconText,
    Color color,
    Function onPressed,
  ) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(5),
        shape: StadiumBorder(),
      ),
      child: iconText,
    );
  }

  Widget orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "P" || status == "Pending" || status == "On-Hold") {
      icon = Icon(
        Icons.timer,
        color: Colors.orange,
      );
      color = Colors.orange;
    } else if (status == "D" || status == "Delivered") {
      icon = Icon(
        Icons.check,
        color: Colors.green,
      );
      color = Colors.green;
    } else if (status == "C" || status == "Cancelled") {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    } else {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    }
    return iconData(
        icon,
        Text(
          "Order Status :$status",
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Suyoga"),
          content: new Text("Are you sure you want to Cancel"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: new Text("YES"),
              onPressed: () {
                // dbHelper.userdelete();
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => HomePage(),
                // ));
              },
            ),
          ],
        );
      },
    );
  }
}
