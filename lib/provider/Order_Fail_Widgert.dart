import 'package:Samarpana/pages/categorylist.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderFailWidget extends StatefulWidget {
  @override
  OrderFailWidgetState createState() => OrderFailWidgetState();
}

class OrderFailWidgetState extends State<OrderFailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Text(
            'Payment Failed',
            style: TextStyle(color: Colors.white),
          ), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          // child: _listview(context, ordermodel.allOrders),

          child: Center(
            //  margin: EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.max,
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
                                Colors.orangeAccent.withOpacity(0.4),
                                Colors.orangeAccent.withOpacity(0.4),
                              ])),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 60,
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
                      "Your Order Has Been Falied",
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
                        // builder: (context) => HomePage(),
                        builder: (context) => categorylist(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "Failed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
