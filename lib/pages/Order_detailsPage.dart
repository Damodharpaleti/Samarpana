import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/pages/orderdetails.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  final String status;
  final Myorders orderModel;

  /// [orderModel] is rarely used by this page; the caller may omit it and
  /// a placeholder object will be supplied automatically.
  OrderDetails({
    Key? key,
    required this.status,
    Myorders? orderModel,
  })  : orderModel = orderModel ?? Myorders.fromJson({}),
        super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}


class _OrderDetailsState extends State<OrderDetails> {
List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
late UserdatafromDB model;
late String userRole;

  @override
  void initState() {
    super.initState();

    fetch();
    _checkUserRole();
    _fetchAllPincodeOrders();
  }

  /// Fetch pending orders using PROVEN WORKING endpoint
  void _fetchAllPincodeOrders() async {
    print('\n🔍 Order_detailsPage: Starting to fetch PENDING ORDERS');
    
    final orderProvider = Provider.of<CartProvider>(context, listen: false);
    
    print('🔍 Order_detailsPage: Calling fetchPendingOrders()...');
    
    // Use new working method that calls proven endpoint
    await orderProvider.fetchPendingOrders();
    
    print('✅ Order_detailsPage: Pending orders fetched and ready to display');
  }

  Future<void> _checkUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString("ROLE") ?? "Role not assigned";  
    print('🔍 _checkUserRole() - Role loaded: $userRole');
    setState(() {});
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
    setState(() {
      build(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      if (ordermodel.filteredOrdersByStatus.length > 0) {
        // _single();
        //  _listview(context, ordermodel.filteredOrdersByStatus);
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Pending Orders',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            SizedBox(
              width: 10,
            ),
          ],
        ),
        drawer: DrawerWidget(),
        body: Container(
          margin: EdgeInsets.all(10),
          child: _buildContent(ordermodel),
        ),
      );
    });
  }

//    Widget _single(){
//     return SingleChildScrollView(
//       child: Row(
//        children: <Widget>[
//          Text('data'),
//          Divider(
//            color: Colors.grey,
//          ),
//          // _listview(context, ordermodel.paymentslist);
//        ],
//       ),
//
//     );
//
// }

  Widget _buildContent(CartProvider ordermodel) {
    // Check if user has a role assigned
    if (userRole == "Role not assigned" || userRole.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Role Not Assigned',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Your account does not have a role assigned yet.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Please contact admin or update your profile to get a role assigned.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _checkUserRole();
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      );
    }

    // Show orders if available
    if (ordermodel.filteredOrdersByStatus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Pending Orders'),
            SizedBox(height: 8),
            Text(
              'You have no pending orders at the moment.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return _listview(context, ordermodel.filteredOrdersByStatus);
  }

  Widget _listview(BuildContext context, List<Myorders> orders) {
    // Filter to show only pending orders (status 'P')
    List<Myorders> pendingOrders = orders.where((order) => order.orderStatus?.toUpperCase() == 'P').toList();
    
    return pendingOrders.length == 0
        ? Center(
            child: Text('No Pending Orders are available',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : new ListView(
            children: [
              ListView.builder(
                  itemCount: pendingOrders.length,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final order = pendingOrders[index];
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
                                          backgroundColor: Colors.green[900],
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
