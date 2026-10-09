import 'package:Samarpana/components/loader_provider.dart';
import 'package:Samarpana/pages/cart_page.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/widgets/widget_checkpoint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class CheckoutBase extends StatefulWidget {
  @override
  CheckoutBaseState createState() => CheckoutBaseState();
}

class CheckoutBaseState<T extends CheckoutBase> extends State<T> {
  int currentPage = 0;
  bool showBackButton = true;
  @override
  void initState() {
    super.initState();
    print('CheckOutBasePage: initState()');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loaderModel, child) {
      return Scaffold(
        appBar: _buildAppBar(),
        backgroundColor: Colors.white,
        body: ProgressHUD(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: ["Shipping", "Payment", "Place Order"],
                    checkPointFilledColor: Colors.green,
                  ),
                  Divider(color: Colors.grey),
                  pageUI(),
                ],
              ),
            ),
          ),
          inAsyncCall: loaderModel.isApiCallPocess,
          opacity: 3.0,
        ),
      );
    });
  }

  Widget pageUI() {
    return Container();
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(),
          ),
        ),
      ),
      title: Text(
        'Checkout',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
