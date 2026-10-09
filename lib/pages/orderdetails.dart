import 'dart:io';

import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/model/order_status_Model.dart';
import 'package:Samarpana/pages/DeliveryOTP_Page.dart';
import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:Samarpana/utils/form_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Mypayments extends StatelessWidget {
  Mypayments({Key? key, required this.token, required this.orders, int? orderId}) : super(key: key);
  UserdatafromDB token;
  List<Myorders> orders;
  late APIService apiService;

  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
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
            'Orders Details',
            style: TextStyle(color: Colors.black),
          ), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: orderDetailsUI(context, ordermodel.paymentslist),
        ),
      );
    });
  }

  Widget orderDetailsUI(BuildContext context, List<Myorders> model) {
    final Myorders orderModel = ModalRoute.of(context)!.settings.arguments as Myorders;
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Order Number :"
            "${orderModel.orderInvoiceNumber}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "Date :"
            "${orderModel.orderDate}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Delivery To",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            "${orderModel.address}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            "${orderModel.orderType}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Divider(
            color: Colors.green,
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey,
          ),
          listOrderItems(context, model),
          Divider(color: Colors.green),
          itemsTotal(
            context,
            "Bill Total",
            "${orderModel.orderFullPrice}",
          ),
          SizedBox(
            height: 100,
          ),
          buttons(context),
        ],
      ),
    );
  }

  Widget listOrderItems(BuildContext context, List<Myorders> orderModel) {
    final Myorders orderModel = ModalRoute.of(context)!.settings.arguments as Myorders;

    return ListView.builder(
      itemCount: orderModel.productList?.length ?? 0,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return productslitsItems(context, orderModel.productList![index]);
      },
    );
  }

  Widget productslitsItems(BuildContext context, ProductList productLists) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(2),
      onTap: () {},
      title: new Text(
        productLists.productName ?? '',
        style: Theme.of(context).textTheme.productnameText,
      ),
      subtitle: Padding(
        padding: EdgeInsets.all(1),
        child: new Text(
          "Qty :" + "${productLists.numOfItems}",
        ),
      ),
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 44,
          minHeight: 44,
          maxWidth: 44,
          maxHeight: 44,
        ),
        child: Image.network(
          Config.imageurl + (productLists.productCode ?? '') + '.png',
          fit: BoxFit.fill,
        ),
      ),
      trailing: new Text(
        "${productLists.price}",
        style: Theme.of(context).textTheme.labelText,
      ),
    );
  }

  Widget itemsTotal(BuildContext context, String label, String value,
      {TextStyle? textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(
        horizontal: 0,
        vertical: -4,
      ),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: new Text(
        label,
        style: Theme.of(context).textTheme.labelHeading,
      ),
      trailing: new Text(
        "$value",
        style: Theme.of(context).textTheme.labelText,
      ),
    );
  }

  buttons(BuildContext buildcontext) {
    final Myorders orderModel = ModalRoute.of(buildcontext)!.settings.arguments as Myorders;
    String ordernumber = "${orderModel.orderInvoiceNumber}";
    String status = "${orderModel.orderStatus}";
    String Cstatus = "C";
    String Dstatus = "D";
    String pending = "P";
    String mobile = "${orderModel.orderUserId}";
    if ("${orderModel.orderStatus}" == "P") {
      return Container(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(255, 95, 167, 1),
              shape: StadiumBorder(),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: Text(
              'Delivered',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              loginWithOTP(mobile);
              Navigator.push(
                buildcontext,
                MaterialPageRoute(
                  builder: (context) => DOTP(
                    mobile: mobile,
                    token: token,
                    ordernumber: "${orderModel.orderInvoiceNumber}",
                  ),
                ),
              );
              // statusUpdate(ordernumber, Dstatus, token.token);
              // FormHelper.showMessage(
              //     buildcontext, "Suyoga", "Order Delivered Successfull", "OK",
              //     () {
              //   Navigator.push(
              //     buildcontext,
              //     MaterialPageRoute(
              //       builder: (context) => OrderDetails(
              //         status: pending,
              //       ),
              //     ),
              //   );
              // });
            }),
        SizedBox(
          width: 40,
        ),
        // FlatButton(
        //     color: Colors.orange,
        //     shape: StadiumBorder(),
        //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        //     child: Text(
        //       "Cancel",
        //       style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 22,
        //           fontWeight: FontWeight.bold),
        //     ),
        //     onPressed: () {
        //       _showDialog(buildcontext);
        //       statusUpdate(ordernumber, Dstatus, token.token);
        //     }),
      ]));
    } else {
      return ListTile(
        dense: true,
        visualDensity: VisualDensity(
          horizontal: 0,
          vertical: -4,
        ),
        contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      );
    }
  }

  _showDialog(BuildContext buildcontext) {
    // flutter defined function
    final Myorders orderModel = ModalRoute.of(buildcontext)!.settings.arguments as Myorders;
    String ordernumber = "${orderModel.orderInvoiceNumber}";
    // String status = "${orderModel.orderStatus}";
    String cstatus = "C";
    // String token =

    showDialog(
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Suyoga"),
          content: new Text("Are you sure you want to Cancel Order"),
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
                statusUpdate(ordernumber, cstatus, token.token ?? "");
                FormHelper.showMessage(
                    buildcontext, "Suyoga", "Order Cancel Successfull", "OK",
                    () {
                  var pendingg = "P";
                  Navigator.push(
                    buildcontext,
                    MaterialPageRoute(
                      builder: (context) => OrderDetails(
                        orderModel: orderModel,
                        status: pendingg = "P",
                      ),
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
      context: buildcontext,
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
        fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold);
  }

  TextStyle get labelText {
    return TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);
  }

  TextStyle get productnameText {
    return TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  }
}

Future<StatusUpdate?> statusUpdate(
  String ordernumber,
  String status,
  String token,
) async {
  StatusUpdate? model;
  String url = Config.url + Config.ordersatus;
  print(url);
  try {
    final response = await Dio().put(
      url,
      data: {
        "orderNumber": ordernumber,
        "orderStatus": status,
      },
      options: new Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 201) {
      model = StatusUpdate.fromJson(response.data);
      print(url);
      print(response.data);

      //  print(model.token);
    }
  } on DioException catch (e) {
    print(e.message);
  }
  return model;
}

Future<bool> loginWithOTP(String mobileNumber) async {
  bool ret = false;
  String url = Config.loginUrl + Config.otp;
  try {
    final response = await Dio().post(
      url,
      data: {
        "mobileNumber": mobileNumber,
      },
      options: new Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      ),
    );

    if (response.statusCode == 201) {
      ret = true;
      //LoginResponse.fromJson(response.data);

      print(response.data);
    }
  } on DioException catch (e) {
    ret = false;
    print(e.message);
  }
  return ret;
}
