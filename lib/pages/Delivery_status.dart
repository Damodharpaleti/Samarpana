import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/pages/orderdetails.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:Samarpana/components/cart_provider.dart';

class OrderStatus extends StatefulWidget {
  OrderStatus({Key? key, required this.status}) : super(key: key);

  String status;
  late Myorders orderModel;
  @override
  void dispose() {
    // super.dispose();
  }
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  List<UserdatafromDB> list = [];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  late bool listselection;
  Set<int> expandedOrders = {}; // Track which orders are expanded

  @override
  void initState() {
    super.initState();

    fetch();
    _fetchAllPincodeOrders();
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.getuseraddress();
  }

  /// Fetch pending orders using PROVEN WORKING endpoint
  void _fetchAllPincodeOrders() async {
    print('\n🔍 OrderStatus: Starting to fetch PENDING ORDERS');
    
    final orderProvider = Provider.of<CartProvider>(context, listen: false);
    
    print('🔍 OrderStatus: Calling fetchPendingOrders()...');
    
    // Use new working method that calls proven endpoint
    await orderProvider.fetchPendingOrders();
    
    print('✅ OrderStatus: Pending orders fetched and ready to display');
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

  Future<bool> _onbackpress() {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Do you want to close app",
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () {
                      SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop');
                      // Navigator.pop(context, true);
                    },
                    child: Text("Yes"))
              ],
            )).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      if (ordermodel.filteredOrdersByStatus.length > 0) {
        _listview(context, ordermodel.filteredOrdersByStatus, ordermodel.count);
        listselection = true;
      } else {
        listselection = false;
      }

      return Column(
        children: [
          if (listselection == true)
            WillPopScope(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      title: Text(
                        'Pending Orders',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    drawer: DrawerWidget(),

                    body: _listview(
                        context, ordermodel.filteredOrdersByStatus, ordermodel.count),
                    // body: Container(
                    //     // margin: EdgeInsets.all(10),
                    //     // child:_single(),
                    //     child: _listview(
                    //         context, ordermodel.filteredOrdersByStatus, ordermodel.count)),
                  ),
                ),
                onWillPop: _onbackpress),
          if (listselection == false)
            WillPopScope(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.99,
                width: double.infinity,
                child: Scaffold(
                    drawer: DrawerWidget(),
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      centerTitle: true,
                      title: Text(
                        'Pending Orders',
                        style: TextStyle(color: Colors.black),
                      ),
                      actions: [
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    body: Center(
                      child: Text(
                        "No orders available.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    )),
              ),
              onWillPop: _onbackpress,
            )
        ],
      );
    });
  }

  Widget _listview(BuildContext context, List<Myorders> orders, int count) {
    // Filter only pending orders
    List<Myorders> pendingOrdersOnly = orders.where((order) => 
      order.orderStatus?.toUpperCase() == 'P' || order.orderStatus?.toUpperCase() == 'PENDING'
    ).toList();

    return pendingOrdersOnly.length == 0
        ? Center(
            child: Text('No Pending Orders are available',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : ListView.builder(
            itemCount: pendingOrdersOnly.length,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              bool isExpanded = expandedOrders.contains(index);
              final order = pendingOrdersOnly[index];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Order Number
                        _buildOrderRow(
                            Icons.edit,
                            "Order Number",
                            "${order.orderNumber ?? 'N/A'}"),
                        Divider(height: 1),
                        // Order Status
                        // _buildOrderRow(
                        //     Icons.info,
                        //     "Status",
                        //     _getStatusName(order.orderStatus) ?? 'N/A',
                        //     statusColor: _getStatusColor(order.orderStatus)),
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
                        // Divider(height: 1),
                        // Expandable Products Section
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (expandedOrders.contains(index)) {
                                expandedOrders.remove(index);
                              } else {
                                expandedOrders.add(index);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            // child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                                // Row(
                                //   children: [
                                //     Icon(
                                //       isExpanded ? Icons.expand_less : Icons.expand_more,
                                //       color: Color.fromRGBO(123, 212, 165, 1),
                                //       size: 20,
                                //     ),
                                //     SizedBox(width: 8),
                                //     // Text(
                                //     //   'Products (${order.productList?.length ?? 0})',
                                //     //   style: TextStyle(
                                //     //     fontSize: 14,
                                //     //     fontWeight: FontWeight.bold,
                                //     //     color: Color.fromRGBO(123, 212, 165, 1),
                                //     //   ),
                                //     // ),
                                //   ],
                                // ),
                                // Icon(
                                //   isExpanded ? Icons.visibility : Icons.visibility_off,
                                //   color: Color.fromRGBO(123, 212, 165, 1),
                                //   size: 18,
                                // ),
                            //   ],
                            // ),
                          ),
                        ),
                        if (isExpanded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(color: Colors.grey, height: 1),
                              _buildProductsList(order.productList),
                            ],
                          ),
                        Divider(height: 1),
                        // Action Button
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
                                backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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

  Widget _buildProductsList(List<ProductList>? productList) {
    if (productList == null || productList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'No products in this order',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          productList.length,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) Divider(color: Colors.grey[300], height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${productList[index].productName ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Code: ${productList[index].productCode ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Brand: ${productList[index].brandname ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Qty: ${productList[index].numOfItems ?? '0'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Price: ₹${productList[index].price ?? '0'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 95, 167, 1),
                          ),
                        ),
                        Text(
                          'Total: ₹${productList[index].totalPrice ?? '0'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconData(Icon iconData, Text textdata) {
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
      onPressed: onPressed as void Function()?,
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

class pendingStatus extends StatefulWidget {
  pendingStatus({Key? key, required this.status}) : super(key: key);

  String status;
  late Myorders orderModel;
  @override
  void dispose() {
    // super.dispose();
  }
  @override
  _pendingStatusState createState() => _pendingStatusState();
}

class _pendingStatusState extends State<pendingStatus> {
  List<UserdatafromDB> list = [];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  Set<int> expandedOrders = {}; // Track which orders are expanded

  @override
  void initState() {
    super.initState();

    fetch();
    _fetchAllPincodeOrders();
  }

  /// Fetch pending orders using PROVEN WORKING endpoint
  void _fetchAllPincodeOrders() async {
    print('\n🔍 pendingStatus: Starting to fetch PENDING ORDERS');
    
    final orderProvider = Provider.of<CartProvider>(context, listen: false);
    
    print('🔍 pendingStatus: Calling fetchPendingOrders()...');
    
    // Use new working method that calls proven endpoint
    await orderProvider.fetchPendingOrders();
    
    print('✅ pendingStatus: Pending orders fetched and ready to display');
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
        _listview(context, ordermodel.filteredOrdersByStatus, ordermodel.count);
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
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
        body: Container(
          margin: EdgeInsets.all(10),
          // child:_single(),
          child: _listview(context, ordermodel.filteredOrdersByStatus, ordermodel.count),
        ),
      );
    });
  }

  Widget _listview(BuildContext context, List<Myorders> orders, int count) {
    return orders.length == 0
        ? Center(
            child: Text('No Pending Orders are avaliable',
                style: TextStyle(fontSize: 20, color: Colors.black)))
        : ListView.builder(
            itemCount: orders.length,
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              bool isExpanded = expandedOrders.contains(index);
              final order = orders[index];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Order ID
                        _buildOrderRow(
                            Icons.confirmation_number,
                            "Order ID",
                            "${order.orderId ?? 'N/A'}"),
                        Divider(height: 1),
                        // Order Number
                        _buildOrderRow(
                            Icons.edit,
                            "Order Number",
                            "${order.orderNumber ?? 'N/A'}"),
                        Divider(height: 1),
                        // Invoice Number
                        _buildOrderRow(
                            Icons.receipt,
                            "Invoice Number",
                            "${order.orderInvoiceNumber ?? 'N/A'}"),
                        Divider(height: 1),
                        // Order Status
                        _buildOrderRow(
                            Icons.info,
                            "Status",
                            _getStatusName(order.orderStatus) ?? 'N/A',
                            statusColor: _getStatusColor(order.orderStatus)),
                        Divider(height: 1),
                        // Order Type
                        _buildOrderRow(
                            Icons.shopping_bag,
                            "Order Type",
                            "${order.orderType ?? 'N/A'}"),
                        Divider(height: 1),
                        // Customer Mobile
                        _buildOrderRow(
                            Icons.phone,
                            "Customer Mobile",
                            "${order.orderUserId ?? 'N/A'}"),
                        Divider(height: 1),
                        // Order Amount
                        _buildOrderRow(
                            Icons.attach_money,
                            "Order Amount",
                            "₹${order.orderFullPrice ?? '0.00'}"),
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
                        // Expandable Products Section
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (expandedOrders.contains(index)) {
                                expandedOrders.remove(index);
                              } else {
                                expandedOrders.add(index);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      isExpanded ? Icons.expand_less : Icons.expand_more,
                                      color: Color.fromRGBO(123, 212, 165, 1),
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Products (${order.productList?.length ?? 0})',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(123, 212, 165, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  isExpanded ? Icons.visibility : Icons.visibility_off,
                                  color: Color.fromRGBO(123, 212, 165, 1),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isExpanded)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Divider(color: Colors.grey, height: 1),
                              _buildProductsList(order.productList),
                            ],
                          ),
                        Divider(height: 1),
                        // Action Button
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
                      ],
                    ),
                  ),
                ),
              );
            },
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

  Widget _buildProductsList(List<ProductList>? productList) {
    if (productList == null || productList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'No products in this order',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          productList.length,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) Divider(color: Colors.grey[300], height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${productList[index].productName ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Code: ${productList[index].productCode ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Brand: ${productList[index].brandname ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Qty: ${productList[index].numOfItems ?? '0'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Price: ₹${productList[index].price ?? '0'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(255, 95, 167, 1),
                          ),
                        ),
                        Text(
                          'Total: ₹${productList[index].totalPrice ?? '0'}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      onPressed: onPressed as void Function()?,
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
