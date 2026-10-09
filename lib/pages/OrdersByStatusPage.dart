import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/pages/Order_detailsPage.dart';

class OrdersByStatusPage extends StatefulWidget {
  const OrdersByStatusPage({Key? key}) : super(key: key);

  @override
  State<OrdersByStatusPage> createState() => _OrdersByStatusPageState();
}

class _OrdersByStatusPageState extends State<OrdersByStatusPage> {
  final TextEditingController _pincodeController = TextEditingController();
  bool _isLoading = false;
  String _selectedStatus = 'pending'; // pending, delivery, cancel

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  void _fetchOrdersByPincode() async {
    if (_pincodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a pincode')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final orderProvider = Provider.of<CartProvider>(context, listen: false);
      
      // Use new working method - fetches from proven working endpoint
      await orderProvider.fetchAllOrdersAllStatuses();
      
      // Get counts
      final pendingCount = orderProvider.ordersByPincode
          .where((o) => o.orderStatus == 'P')
          .length;
      final deliveryCount = orderProvider.ordersByPincode
          .where((o) => o.orderStatus == 'D')
          .length;
      final cancelCount = orderProvider.ordersByPincode
          .where((o) => o.orderStatus == 'C')
          .length;
      final totalOrders = orderProvider.ordersByPincode.length;
      
      // Filter by the selected status after fetching
      orderProvider.filterOrdersByStatus(status: _selectedStatus);
      
      setState(() => _isLoading = false);

      if (totalOrders > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Found $totalOrders orders: $pendingCount Pending, $deliveryCount Delivery, $cancelCount Cancelled',
              style: TextStyle(fontSize: 12),
            ),
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No orders found')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onStatusFilterChanged(String status) {
    setState(() => _selectedStatus = status);
    
    final orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.filterOrdersByStatus(status: status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Color.fromRGBO(123, 212, 165, 1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            final orderProvider = Provider.of<CartProvider>(context, listen: false);
            orderProvider.clearOrdersData();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Orders by Status',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Pincode Input Section
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Pincode',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pincodeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          hintText: 'e.g., 560035',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    _isLoading
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: _fetchOrdersByPincode,
                            icon: Icon(Icons.search),
                            label: Text('Search'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Legend
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  color: Colors.white,
                  label: 'Your Orders',
                ),
                _buildLegendItem(
                  color: Colors.blue.shade50,
                  label: 'Other Users',
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Status Filter Buttons with Counts
          Consumer<CartProvider>(
            builder: (context, orderProvider, child) {
              final currentUserMobile = orderProvider.mobNum;
              
              // Pending: current user + other users' pending
              final pendingCount = orderProvider.ordersByPincode
                  .where((o) => o.orderStatus == 'P')
                  .length;
              
              // Delivery: current user + other users' delivery
              final deliveryCount = orderProvider.ordersByPincode
                  .where((o) => o.orderStatus == 'D')
                  .length;
              
              // Cancel: only current user's cancelled
              final cancelCount = orderProvider.ordersByPincode
                  .where((o) => o.orderStatus == 'C' && o.orderUserId == currentUserMobile)
                  .length;
              
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatusButton(
                      label: 'Pending',
                      status: 'pending',
                      icon: Icons.schedule,
                      count: pendingCount,
                    ),
                    _buildStatusButton(
                      label: 'Delivery',
                      status: 'delivery',
                      icon: Icons.local_shipping,
                      count: deliveryCount,
                    ),
                    _buildStatusButton(
                      label: 'Cancelled',
                      status: 'cancel',
                      icon: Icons.cancel,
                      count: cancelCount,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 12),
          // Orders List
          Expanded(
            child: Consumer<CartProvider>(
              builder: (context, orderProvider, child) {
                final orders = orderProvider.filteredOrdersByStatus;
                final totalOrders = orderProvider.ordersByPincode.length;
                final selectedStatusDisplay = _getDisplayStatus(_selectedStatus);
                
                if (totalOrders == 0) {
                  return Center(
                    child: Text(
                      'Enter a pincode and search to see orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  );
                }

                if (orders.isEmpty) {
                  final currentUserMobile = orderProvider.mobNum;
                  final pendingCount = orderProvider.ordersByPincode
                      .where((o) => o.orderStatus == 'P')
                      .length;
                  final deliveryCount = orderProvider.ordersByPincode
                      .where((o) => o.orderStatus == 'D')
                      .length;
                  final cancelCount = orderProvider.ordersByPincode
                      .where((o) => o.orderStatus == 'C' && o.orderUserId == currentUserMobile)
                      .length;
                  
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No $selectedStatusDisplay Orders',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'You have $totalOrders total orders:\n'
                            '• Pending: $pendingCount\n'
                            '• Delivery: $deliveryCount\n'
                            '• Cancelled: $cancelCount',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(context, orders[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required String status,
    required IconData icon,
    required int count,
  }) {
    final isSelected = _selectedStatus == status;
    
    return GestureDetector(
      onTap: () => _onStatusFilterChanged(status),
      child: Column(
        children: [
          Container(
            width: 100,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color.fromRGBO(123, 212, 165, 1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Color.fromRGBO(123, 212, 165, 1)
                    : Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  size: 24,
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Color.fromRGBO(123, 212, 165, 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Color.fromRGBO(123, 212, 165, 1) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, Myorders order) {
    final orderProvider = Provider.of<CartProvider>(context, listen: false);
    final currentUserMobile = orderProvider.mobNum;
    final isCurrentUserOrder = order.orderUserId == currentUserMobile;
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: isCurrentUserOrder ? Colors.white : Colors.blue.shade50,
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color.fromRGBO(123, 212, 165, 1).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Icon(
              _getStatusIcon(order.orderStatus),
              color: Color.fromRGBO(123, 212, 165, 1),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNumber ?? 'N/A'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (!isCurrentUserOrder)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(123, 212, 165, 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      order.orderUserId ?? 'N/A',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              order.orderDate ?? 'Date N/A',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            Text(
              'Status: ${_getDisplayStatus(order.orderStatus)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(order.orderStatus),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${order.orderFullPrice?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromRGBO(123, 212, 165, 1),
              ),
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetails(
                      status: _getDisplayStatus(order.orderStatus),
                      orderModel: order,
                    ),
                  ),
                );
              },
              child: Text(
                'View Details',
                style: TextStyle(
                  fontSize: 11,
                  color: Color.fromRGBO(123, 212, 165, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toUpperCase()) {
      case 'P':
        return Icons.schedule;
      case 'D':
        return Icons.local_shipping;
      case 'C':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

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

  String _getDisplayStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'P':
        return 'Pending';
      case 'D':
        return 'In Delivery';
      case 'C':
        return 'Cancelled';
      case 'PENDING':
        return 'Pending';
      case 'DELIVERY':
        return 'In Delivery';
      case 'CANCEL':
        return 'Cancelled';
      default:
        return status ?? 'Unknown';
    }
  }
}
