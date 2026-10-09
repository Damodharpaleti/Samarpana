import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/AddmoneyToWallet.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/provider/Order_Fail_Widgert.dart';
import 'package:Samarpana/widgets/Order_Sucess_Widget.dart';
import 'package:Samarpana/widgets/Wallet_payment_sucess.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPaymentService {
  late Razorpay _razorpay;
  late BuildContext _buildContext;

  initPaymentGateway(BuildContext buildContext) {
    this._buildContext = buildContext;
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWallet);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
  }

  walletPaymentGateway(BuildContext buildContext) {
    this._buildContext = buildContext;
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentError);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccesswallet);
  }

  void externalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }

  void paymentSuccess(PaymentSuccessResponse response) {
    print('Success' + response.paymentId.toString());
    var orderProvider = Provider.of<CartProvider>(_buildContext, listen: false);
    CreateOrder placeOrder = new CreateOrder();

    placeOrder.paymentMethod = "razorpay";
    placeOrder.paymentMethodTitle = "RazorPay";
    placeOrder.setPaid = true;
    // placeOrder.status = "Order Placed Successfully";
    placeOrder.transactionId = response.paymentId.toString();

    orderProvider.placeOrderProcess(placeOrder);

    Navigator.pushAndRemoveUntil(
        _buildContext,
        MaterialPageRoute(builder: (context) => OrderSucessWidget()),
        ModalRoute.withName('/OrderSucess'));
  }

  void paymentSuccesswallet(PaymentSuccessResponse response) {
    print('Success' + response.paymentId.toString());
    var orderProvider = Provider.of<CartProvider>(_buildContext, listen: false);
    var cartItems = Provider.of<CartProvider>(_buildContext, listen: false);
    AddMoneyToWallet addMoneyToWallet = new AddMoneyToWallet(
      userId: cartItems.userId,
      amount: cartItems.finalamount.toString(),
      transactionid: response.paymentId.toString(),
    );

    orderProvider.addmoneyProcess(addMoneyToWallet);

    Navigator.pushAndRemoveUntil(
        _buildContext,
        MaterialPageRoute(builder: (context) => WalletpaySucessWidget()),
        ModalRoute.withName('/OrderSucess'));
  }

  void paymentError(PaymentFailureResponse response) {
    print('Fail' + (response.message ?? ''));
    print('Fail' + response.code.toString());
    if (response.code == 2) {
      Navigator.pushAndRemoveUntil(
          _buildContext,
          MaterialPageRoute(builder: (context) => OrderFailWidget()),
          ModalRoute.withName('/OrderFail'));
    }
  }

  getPayment(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.finalamount;
    var option = {
      'key': Config.razorpaykey,
      'amount': cartItems.finalamount * 100,
      'description': 'Payment for our Product',
      'prefill': {
        'contact': cartItems.moblieNumber,
        'email': cartItems.email,
        'method': cartItems.payment,
      },
      'name': 'SUYOGA SOFTWARE SOLUTIONS PRIVATE LIMITED'
    };
    try {
      _razorpay.open(option);
    } catch (e) {
      print(e);
    }
  }

  walletgetPayment(BuildContext context) {
    var cartItems = Provider.of<CartProvider>(context, listen: false);
    cartItems.finalamount;
    var option = {
      'key': Config.razorpaykey,
      'amount': cartItems.finalamount * 100,
      'description': 'Payment for our Product',
      'prefill': {
        'contact': cartItems.mobNum,
        'email': "dpaleti@suyoga.co.in",
        'method': cartItems.payment,
      },
      'name': 'SUYOGA SOFTWARE SOLUTIONS PRIVATE LIMITED'
    };
    try {
      _razorpay.open(option);
    } catch (e) {
      print(e);
    }
  }
}
