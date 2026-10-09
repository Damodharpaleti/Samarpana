import 'package:Samarpana/provider/cashonDelivery_service.dart';
import 'package:Samarpana/provider/razor_payment_service.dart';
import 'package:flutter/cupertino.dart';

class Payment {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;
  Payment(this.id, this.name, this.description, this.logo, this.route,
      this.onTap, this.isRouteRedirect);
}

class WalletPayment {
  String id;
  String name;
  String description;
  String logo;
  String route;
  Function onTap;
  bool isRouteRedirect;
  WalletPayment(this.id, this.name, this.description, this.logo, this.route,
      this.onTap, this.isRouteRedirect);
}

class PaymentList {
  late List<Payment> _paymentList;
  late List<Payment> _cashList;

  PaymentList(BuildContext context) {
    this._paymentList = [
      new Payment(
          'razorpay',
          'Card/Wallet/UPI Payment',
          'Click to pay with Payment Method',
          'assets/images/Cards.png',
          '/RazorPay', () {
        RazorPaymentService razorPaymentService = new RazorPaymentService();
        razorPaymentService.initPaymentGateway(context);
        razorPaymentService.getPayment(context);
      }, false),
      // new Payment('paypal', 'paypal', 'Click to pay with paypal Method',
      //     'assets/images/paypal.png', '/PayPal', () {}, true)
    ];
    this._cashList = [
      new Payment('cod', 'Cash on Delivery', 'Click to pay Cash on Delivery',
          'assets/images/COD.png', '/OrderSuccess', () {
        CODPaymentService codPaymentService = new CODPaymentService();
        codPaymentService.initPaymentGateway(context);
        codPaymentService.getPayments(context);
      }, false)
    ];
  }
  List<Payment> get paymentList => _paymentList;
  List<Payment> get cashlist => _cashList;
}

class WalletPaymentList {
  late List<WalletPayment> _walletpaymentList;

  WalletPaymentList(BuildContext context) {
    this._walletpaymentList = [
      new WalletPayment(
          'razorpay',
          'Card/Wallet/UPI Payment',
          'Click to pay with Payment Method',
          'assets/images/Cards.png',
          '/RazorPay', () {
        RazorPaymentService razorPaymentService = new RazorPaymentService();
        razorPaymentService.walletPaymentGateway(context);
        razorPaymentService.walletgetPayment(context);
      }, false),
      // new Payment('paypal', 'paypal', 'Click to pay with paypal Method',
      //     'assets/images/paypal.png', '/PayPal', () {}, true)
    ];
  }

  List<WalletPayment> get walletpaymentlist => _walletpaymentList;
}
