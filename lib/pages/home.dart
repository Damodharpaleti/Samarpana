import 'package:Samarpana/pages/Order_detailsPage.dart';
import 'package:Samarpana/model/MyPayments_Model.dart';
import 'package:Samarpana/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cancel = "C";
  String delivery = "D";
  String pending = "P";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: DrawerWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 90,
            width: 410,
            margin: const EdgeInsets.only(top: 0.0),
            child: Column(
              children: [
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetails(
                            status: pending,
                            orderModel: Myorders.fromJson({}),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: Text(
                        'Pending Ord',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Container(
                    height: 30,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                    ))
              ],
            ),
          ),
          Divider(
            color: Colors.green,
          ),
          Column(
            children: [
              Container(
                width: 410,
                margin: const EdgeInsets.only(top: 50.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetails(
                          status: delivery,
                          orderModel: Myorders.fromJson({}),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Text(
                      'Delivered Orders',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Container(
                  height: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ))
            ],
          ),
          Divider(
            color: Colors.green,
          ),
          Column(
            children: [
              Container(
                width: 410,
                margin: const EdgeInsets.only(top: 50.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetails(
                          status: cancel,
                          orderModel: Myorders.fromJson({}),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Text(
                      'Cancel Orders',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              Container(
                  height: 30,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ))
            ],
          ),
          Divider(
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      backgroundColor: Colors.green,
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) => GestureDetector(
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 30,
          ),
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        'SUYOGA',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
