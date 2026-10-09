import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/pages/checkout_base.dart';
import 'package:Samarpana/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//class OrderSucessWidget {}

class WalletpaySucessWidget extends CheckoutBase {
  @override
  _WalletpaySucessWidgetState createState() => _WalletpaySucessWidgetState();
}

class _WalletpaySucessWidgetState
    extends CheckoutBaseState<WalletpaySucessWidget> {
  @override
  void initState() {
    this.showBackButton = false;
    this.currentPage = 2;
    super.initState();
  }

  @override
  Widget pageUI() {
    return Consumer<CartProvider>(builder: (context, ordercreate, child) {
      if (ordercreate.ispaymentsucess) {
        return Center(
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.green.withOpacity(0.9),
                                Colors.green.withOpacity(0.9),
                              ])),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 90,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Opacity(
                    opacity: 0.6,
                    child: Text(
                      "Your Payment Has Been Sucessfully done",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    backgroundColor: Colors.green,
                  ),
                  child: Text("Done"),
                )
              ],
            ),
          ),
        );
      }
      ;
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
