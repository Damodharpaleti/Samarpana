import 'package:Samarpana/pages/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BasePage extends StatefulWidget {
  BasePage({Key? key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;
  List list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ModalProgressHUD(
        inAsyncCall: isApiCallProcess,
        child: pageUI(),
        opacity: 0.3,
      ),
    );
  }

  Widget pageUI() {
    return Container();
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
      backgroundColor: Color.fromRGBO(123, 212, 165, 1),
      automaticallyImplyLeading: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: Text(
        'SAMARPANA',
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        Icon(
          Icons.notifications_none,
          color: Colors.black,
        ),
        SizedBox(
          width: 20,
        ),
        new IconButton(
            icon: new Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            }),
        list.length == 0
            ? new Container()
            : new Positioned(
                child: new Stack(
                  children: <Widget>[
                    new Icon(
                      Icons.brightness_1,
                      size: 20,
                      color: Colors.red[600],
                    ),
                    new Positioned(
                      top: 4.0,
                      right: 4.0,
                      child: new Center(
                        child: new Text(
                          '10',
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
