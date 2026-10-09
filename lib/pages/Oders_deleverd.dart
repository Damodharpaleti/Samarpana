import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/pages/Delivery_status.dart';
import 'package:Samarpana/pages/orderdetails.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Samarpana/components/cart_provider.dart';

// class OrderDetailsDeleverd extends StatefulWidget {
//  const OrderDetailsDeleverd({Key? key, required this.status}) : super(key: key);

//   String status;
//   Myorders orderModel;
//   @override
//   _OrderDetailsDeleverdState createState() => _OrderDetailsDeleverdState();
// }
class OrderDetailsDeleverd extends StatefulWidget {
  final String status;

  const OrderDetailsDeleverd({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<OrderDetailsDeleverd> createState() =>
      _OrderDetailsDeleverdState();
}

class _OrderDetailsDeleverdState extends State<OrderDetailsDeleverd> {
List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
late UserdatafromDB model;
  bool listselection = false;

  @override
  void initState() {
    super.initState();
    fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchMyDelivery(status: this.widget.status);
  }

  fetch() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"].toString(),
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          // ),
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      if (ordermodel.deliverylist.length > 0) {
        _listview(context, ordermodel.deliverylist);
        listselection = true;
      } else {
        listselection = false;
      }

      return WillPopScope(
       onWillPop: () async {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => OrderStatus(
        status: "P",
      ),
    ),
  );

  return false;
},

          child: Column(
            children: [
              if (listselection == true)
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      title: Text(
                        'Delivery Orders',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    drawer: DrawerWidget(),
                    body: _listview(context, ordermodel.deliverylist),
                    // body: Container(
                    //     // margin: EdgeInsets.all(10),
                    //     // child:_single(),
                    //     child: _listview(
                    //         context, ordermodel.pendingList, ordermodel.count)),
                  ),
                ),
              if (listselection == false)
                Container(
                  height: MediaQuery.of(context).size.height * 0.99,
                  width: double.infinity,
                  child: Scaffold(
                      backgroundColor: Colors.white,
                      drawer: DrawerWidget(),
                      appBar: AppBar(
                        backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                        centerTitle: true,
                        title: Text(
                          'Delivery orders',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      body: Center(
                          child: Text("No orders available",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              )))),
                ),
            ],
          ));
    });
  }
  // @override
  // Widget build(BuildContext context) {
  //   return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
  //     if (ordermodel.deliverylist != null &&
  //         ordermodel.deliverylist.length > 0) {
  //       _single();
  //       _listview(context, ordermodel.deliverylist);
  //     }
  //     return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.green,
  //         title: Text(
  //           'Delivery Orders',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //         actions: [
  //           SizedBox(
  //             width: 10,
  //           ),
  //         ],
  //       ),
  //       drawer: DrawerWidget(),
  //       body: Container(
  //         margin: EdgeInsets.all(10),
  //         // child:_single(),
  //         child: _listview(context, ordermodel.deliverylist),
  //       ),
  //     );
  //   });
  // }

  // Widget _single() {
  //   return SingleChildScrollView(
  //     child: Row(
  //       children: <Widget>[
  //         Text('data'),
  //         Divider(
  //           color: Colors.grey,
  //         ),
  //         // _listview(context, ordermodel.paymentslist);
  //       ],
  //     ),
  //   );
  // }

  Widget _listview(BuildContext context, List<Myorders> orders) {
    return orders.length == 0
        ? Center(
            child: Text('No Delivery Orders are avaliable',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : new ListView.builder(
            itemCount: orders.length,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Mypayments(
                                    token: model,
                                    orders: [orders[index]],
                                  ),
                              settings: RouteSettings(
                                arguments: orders[index],
                              )),
                        );
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                iconData(
                                    Icon(
                                      Icons.edit,
                                      color: Color.fromRGBO(255, 95, 167, 1),
                                      size: 14,
                                    ),
                                    Text(
                                      "Order Number :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Text("${orders[index].orderInvoiceNumber}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
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
                                      color: Color.fromRGBO(255, 95, 167, 1),
                                      size: 12,
                                    ),
                                    Text(
                                      "Order Date :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Text("${orders[index].orderDate}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
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
                                      Icons.phone,
                                      color: Color.fromRGBO(255, 95, 167, 1),
                                      size: 12,
                                    ),
                                    Text(
                                      "Customer Mobile No. :",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Text("${orders[index].orderUserId}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
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
                                      color: Color.fromRGBO(255, 95, 167, 1),
                                      size: 12,
                                    ),
                                    Text(
                                      "Time Slot:",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Text("${orders[index].timeslot}",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
                              ],
                            ),
                            Divider(color: Colors.red),
                            SizedBox(
                              height: 5,
                            ),
                          ])));
            });
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
  VoidCallback? onPressed,
) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(5),
      backgroundColor: color,
      shape: const StadiumBorder(),
      elevation: 0, // makes it look flat
    ),
    child: iconText,
  );
}


  Widget orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "P" || status == "Processing" || status == "On-Hold") {
      icon = Icon(
        Icons.timer,
        color: Colors.orange,
      );
      color = Colors.orange;
    } else if (status == "D" || status == "Deliverd") {
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
}
