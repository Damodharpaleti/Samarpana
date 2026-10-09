import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/pages/Delivery_status.dart';
import 'package:Samarpana/pages/orderdetails.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Samarpana/components/cart_provider.dart';

class OrderDetailsCancel extends StatefulWidget {
  final String status;

  const OrderDetailsCancel({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  State<OrderDetailsCancel> createState() =>
      _OrderDetailsCancelState();
}


class _OrderDetailsCancelState extends State<OrderDetailsCancel> {
List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
late UserdatafromDB model;
  bool listselection = false;

  @override
  void initState() {
    super.initState();
    fetch();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.fetchMyCancel(status: this.widget.status);
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
      if (ordermodel.cancelList.length > 0) {
        _listview(context, ordermodel.cancelList);
        listselection = true;
      } else {
        listselection = false;
      }

      return WillPopScope(
     onWillPop: () async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderStatus(
        status: "P",
      ),
    ),
  );

  return false; // IMPORTANT
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
                        'Cancelled Orders',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    drawer: DrawerWidget(),
                    body: _listview(context, ordermodel.cancelList),
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
                      drawer: DrawerWidget(),
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                        centerTitle: true,
                        title: Text(
                          'Cancelled Orders',
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
                            )),
                      )),
                ),
            ],
          ));
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
  //     if (ordermodel.cancelList != null && ordermodel.cancelList.length > 0) {
  //       _single();
  //       _listview(context, ordermodel.cancelList);
  //     }
  //     return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.green,
  //         title: Text(
  //           'Cancel Orders',
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
  //         child: _listview(context, ordermodel.cancelList),
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
    // Filter to show only cancelled orders (status 'C')
    List<Myorders> cancelledOrders = orders.where((order) => order.orderStatus?.toUpperCase() == 'C').toList();
    
    return cancelledOrders.length == 0
        ? Center(
            child: Text('No Cancelled Orders are available',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : ListView(
            children: [
              ListView.builder(
                  itemCount: cancelledOrders.length,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final order = cancelledOrders[index];
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Order Number
                                  _buildOrderRow(
                                      Icons.edit,
                                      "Order Number",
                                      "${order.orderNumber ?? 'N/A'}"),
                                  Divider(height: 1),
                                  // Order Status
                                  _buildOrderRow(
                                      Icons.info,
                                      "Status",
                                      _getStatusName(order.orderStatus) ?? 'N/A',
                                      statusColor: _getStatusColor(order.orderStatus)),
                                  Divider(height: 1),
                                  // Customer Mobile
                                  _buildOrderRow(
                                      Icons.phone,
                                      "Customer Mobile",
                                      "${order.orderUserId ?? 'N/A'}"),
                                  Divider(height: 1),
                                  // Order Date
                                  _buildOrderRow(
                                      Icons.date_range,
                                      "Order Date",
                                      "${order.orderDate ?? 'N/A'}"),
                                  Divider(height: 1),
                                  // Time Slot
                                  _buildOrderRow(
                                      Icons.schedule,
                                      "Time Slot",
                                      "${order.timeslot ?? 'N/A'}"),
                                  Divider(height: 1),
                                  // View Details Button
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Mypayments(
                                                token: model,
                                                orders: [order],
                                              ),
                                              settings: RouteSettings(
                                                arguments: order,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.visibility),
                                        label: Text("View Details"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[700],
                                          padding: EdgeInsets.symmetric(vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          )),
                    );
                  }),
            ],
          );
  }
                                 
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
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      padding: const EdgeInsets.all(5),
      backgroundColor: color,
      shape: const StadiumBorder(),
    ),
    child: iconText,
  );
}


  /// Build a single order detail row with icon, label, and value
  Widget _buildOrderRow(IconData icon, String label, String value, {Color? statusColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: statusColor ?? Color.fromRGBO(255, 95, 167, 1),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Get status name from status code
  String _getStatusName(String? status) {
    switch (status?.toUpperCase()) {
      case 'P':
        return 'Pending';
      case 'D':
        return 'Delivery';
      case 'C':
        return 'Cancelled';
      default:
        return status ?? 'Unknown';
    }
  }

  /// Get status color based on status code
  Color _getStatusColor(String? status) {
    switch (status?.toUpperCase()) {
      case 'P':
        return Colors.orange;
      case 'D':
        return Colors.green;
      case 'C':
        return Colors.red;
      default:
        return Colors.grey;
    }
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

