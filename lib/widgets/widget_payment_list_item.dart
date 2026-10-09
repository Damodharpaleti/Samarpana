import 'package:Samarpana/components/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:Samarpana/model/payment_method.dart';
import 'package:provider/provider.dart';

class PaymentListItem extends StatelessWidget {
  Payment payment;
  PaymentListItem({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

            //height: 30,
            child: Row(
              children: [
                Text(
                  "UPI",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/Bhimupi.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "BHIM UPI",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "upi";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }

  // return GestureDetector(
  //   splashColor: Theme.of(context).accentColor,
  //   focusColor: Theme.of(context).accentColor,
  //   highlightColor: Theme.of(context).primaryColor,
  //   onTap: () {
  //     if (this.payment.isRouteRedirect) {
  //       Navigator.of(context).pushNamed(this.payment.route);
  //     } else {
  //       this.payment.onTap();
  //     }
  //   },
  //   child: Container(
  //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
  //     decoration: BoxDecoration(
  //         color: Theme.of(context).focusColor.withOpacity(0.1),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.greenAccent,
  //             // color: Theme.of(context).focusColor.withOpacity(0.1),
  //             blurRadius: 10,
  //             offset: Offset(0, 2),
  //           ),
  //         ]),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Container(
  //           height: 60,
  //           width: 60,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.all(Radius.circular(5)),
  //               image: DecorationImage(
  //                   image: AssetImage(payment.logo), fit: BoxFit.fill)),
  //         ),
  //         SizedBox(
  //           width: 15,
  //         ),
  //         Flexible(
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                   child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     payment.name,
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 2,
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 18,
  //                     ),
  //                     //style: Theme.of(context).textTheme.subtitle1,
  //                   ),
  //                   SizedBox(
  //                     height: 2,
  //                   ),
  //                   Text(
  //                     payment.description,
  //                     overflow: TextOverflow.fade,
  //                     softWrap: false,
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12,
  //                     ),
  //                     // style: Theme.of(context).textTheme.caption,
  //                   ),
  //                   SizedBox(
  //                     width: 8,
  //                   ),
  //                 ],
  //               ))
  //             ],
  //           ),
  //         ),
  //         Icon(
  //           Icons.keyboard_arrow_right,
  //           color: Colors.black, size: 30,
  //           // color: Theme.of(context).focusColor,
  //         )
  //       ],
  //     ),
  //   ),
  // );
}

class CardPayment extends StatelessWidget {
  Payment payment;
  CardPayment({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "Cards",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/Cards.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Debit Card",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "card";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class CreditCardPayment extends StatelessWidget {
  Payment payment;
  CreditCardPayment({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/Cards.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Credit Card",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "card";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class NetBanking extends StatelessWidget {
  Payment payment;
  NetBanking({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "Net Banking",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/NetBanking.png',
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Net Banking",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "netbanking";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class Wallets extends StatelessWidget {
  Payment payment;
  Wallets({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "Wallets",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/wallet.png',
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Other Wallets",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "wallet";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class CashonDelivery extends StatelessWidget {
  Payment payment;
  CashonDelivery({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "COD",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/COD.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Cash on Delivery",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
          SizedBox(
            height: 40,
          ),
        ]));
  }
}

class WalletPaymentListItem extends StatelessWidget {
  WalletPayment payment;
  WalletPaymentListItem({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

            //height: 30,
            child: Row(
              children: [
                Text(
                  "UPI",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/Bhimupi.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "BHIM UPI",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "upi";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class WalletCardPayment extends StatelessWidget {
  WalletPayment payment;
  WalletCardPayment({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "Cards",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/Cards.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Debit Card",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "card";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class WalletCreditCardPayment extends StatelessWidget {
  WalletPayment payment;
  WalletCreditCardPayment({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/Cards.png',
                        height: 30.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Credit Card",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "card";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class WalletNetBanking extends StatelessWidget {
  WalletPayment payment;
  WalletNetBanking({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "Net Banking",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/NetBanking.png',
                        height: 50.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Net Banking",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "netbanking";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}

class WalletWallets extends StatelessWidget {
  WalletPayment payment;
  WalletWallets({required Key key, required this.payment}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //height: 30,
            child: Row(
              children: [
                Text(
                  "Wallets",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                )
              ],
            ),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
          GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    new Container(
                      child: new Image.asset(
                        'assets/images/wallet.png',
                        height: 40.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Other Wallets",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )
                  ],
                ),
                color: Colors.transparent,
              ),
              onTap: () {
                var cartItems =
                    Provider.of<CartProvider>(context, listen: false);
                cartItems.payment = "wallet";
                if (this.payment.isRouteRedirect) {
                  Navigator.of(context).pushNamed(this.payment.route);
                } else {
                  this.payment.onTap();
                }
              }),
        ]));
  }
}
