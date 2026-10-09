import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/widgets/Order_Sucess_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CODPaymentService {
  // Razorpay _razorpay;
  late BuildContext _buildContext;

  initPaymentGateway(BuildContext buildContext) {
    this._buildContext = buildContext;
    codpaymentSuccess();
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void codpaymentSuccess() {
    //  print('Success' + response.paymentId.toString());
    var orderProvider = Provider.of<CartProvider>(_buildContext, listen: false);
    CreateOrder placeOrder = new CreateOrder();
    placeOrder.paymentMethod = "COD";
    placeOrder.paymentMethodTitle = "COD";
    placeOrder.razorpayamt = 0.0;
    placeOrder.setPaid = true;
    // placeOrder.status = "Order Placed Successfully";
    placeOrder.transactionId = "COD";

    orderProvider.placeOrderProcess(placeOrder);
    delay();
    // Navigator.pushAndRemoveUntil(
    //     _buildContext,
    //     MaterialPageRoute(builder: (context) => OrderSucessWidget()),
    //     ModalRoute.withName('/OrderSucess'));
  }

  Future delay() async {
    await new Future.delayed(new Duration(milliseconds: 1500), () {
      Navigator.pushAndRemoveUntil(
          _buildContext,
          MaterialPageRoute(builder: (context) => OrderSucessWidget()),
          ModalRoute.withName('/OrderSucess'));
    });
  }

  void paymentError(PaymentFailureResponse response) {
    print('ERROR' +
        response.message.toString() +
        "----" +
        response.code.toString());
  }

  getPayments(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.updaterecord();
    var option = {
      // 'key': Config.razorpaykey,
      'amount': cartItems.totalAmount * 100,
      'description': 'Payment for our Product',
      'prifill': {'contact': '9963XXXXXXXXX', 'email': 'support@suyoga.co.in'},
      'name': 'SUYOGA SOFTWARE SOLUTIONS PRIVATE LIMITED'
    };
    try {
      // ignore: unnecessary_statements
      option;
    } catch (e) {
      print(e);
    }
  }
}
