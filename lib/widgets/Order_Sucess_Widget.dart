import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/pages/categorylist.dart';
import 'package:Samarpana/pages/checkout_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//class OrderSucessWidget {}

class OrderSucessWidget extends CheckoutBase {
  @override
  _OrderSucessWidgetState createState() => _OrderSucessWidgetState();
}

class _OrderSucessWidgetState extends CheckoutBaseState<OrderSucessWidget> {
  @override
  void initState() {
    this.showBackButton = false;
    this.currentPage = 2;
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.ordercreate();
    super.initState();
    // Preload the delivery image to ensure it always displays
    precacheImage(AssetImage('assets/images/Delivery_image.png'), context);
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(builder: (context, ordercreate, child) {
      if (ordercreate.isorderCreated) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Success Checkmark Icon with Circle Background
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(123, 212, 165, 1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(123, 212, 165, 0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  // Try to show the delivery image if available
                  Container(
                    width: 280,
                    height: 180,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/Delivery_image.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('⚠️ Delivery image failed to load: $error');
                          return Container(
                            color: Color.fromRGBO(245, 250, 248, 1),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_shipping,
                                    color: Color.fromRGBO(123, 212, 165, 1),
                                    size: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'On the Way',
                                    style: TextStyle(
                                      color: Color.fromRGBO(123, 212, 165, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Success Message
                  Text(
                    "Order Placed Successfully!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(123, 212, 165, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  // Thank you message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Thank you for placing order with Suyoga!\n\nYour order has been confirmed and will be delivered soon. Check 'My Orders' to track your delivery.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  
                  // Continue Shopping Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => categorylist(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "Continue Shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromRGBO(123, 212, 165, 1),
            ),
            SizedBox(height: 20),
            Text(
              "Creating your order...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            )
          ],
        ),
      );
    });
  }
}

class OrderSucessWidgetbyWallet extends CheckoutBase {
  @override
  _OrderSucessWidgetbyWalletState createState() =>
      _OrderSucessWidgetbyWalletState();
}

class _OrderSucessWidgetbyWalletState
    extends CheckoutBaseState<OrderSucessWidgetbyWallet> {
  @override
  void initState() {
    this.showBackButton = false;
    this.currentPage = 2;
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    orderProvider.walletpayment();
    super.initState();
    // Preload the delivery image to ensure it always displays
    precacheImage(AssetImage('assets/images/Delivery_image.png'), context);
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(builder: (context, ordercreate, child) {
      if (ordercreate.isorderCreated) {
        return Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Success Checkmark Icon with Circle Background
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(123, 212, 165, 1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(123, 212, 165, 0.3),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  // Try to show the delivery image if available
                  Container(
                    width: 280,
                    height: 180,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        'assets/images/Delivery_image.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('⚠️ Delivery image failed to load: $error');
                          return Container(
                            color: Color.fromRGBO(245, 250, 248, 1),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_shipping,
                                    color: Color.fromRGBO(123, 212, 165, 1),
                                    size: 60,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'On the Way',
                                    style: TextStyle(
                                      color: Color.fromRGBO(123, 212, 165, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  
                  // Success Message
                  Text(
                    "Order Placed Successfully!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(123, 212, 165, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 15),
                  
                  // Thank you message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Thank you for placing order with Suyoga!\n\nYour order has been confirmed and will be delivered soon. Check 'My Orders' to track your delivery.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  
                  // Continue Shopping Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => categorylist(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "Continue Shopping",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color.fromRGBO(123, 212, 165, 1),
            ),
            SizedBox(height: 20),
            Text(
              "Creating your order...",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            )
          ],
        ),
      );
    });
  }
}

