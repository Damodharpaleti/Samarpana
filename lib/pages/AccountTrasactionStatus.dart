//import 'package:Samarpana/QR/ScanQR.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/BankTransactionDetails.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/pages/Delivery_status.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transactiondetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Suyoga',
      home: Transactiondetailslist(),
    );
  }
}

class Transactiondetailslist extends StatefulWidget {
  const Transactiondetailslist({Key? key}) : super(key: key);

  @override
  _TransactiondetailslistState createState() => _TransactiondetailslistState();
}

class _TransactiondetailslistState extends State<Transactiondetailslist> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  TextEditingController _controler = new TextEditingController();
  double amt = 0;
  double walbalance = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int flag = 0;
  @override
  void initState() {
    super.initState();
    getotalamt();
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.gettotalamout();
    //  caritemList.getBankTransdata();
    flag = caritemList.bankflagnum;
  }

  Future<double> getotalamt() async {
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.gettotalamout();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double walletbal = prefs.getDouble("Totalamt") ?? 0.0;
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    return walletbal;
  }

  Widget getwalletdetails() {
    return FutureBuilder(
        future: getotalamt(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            this.walbalance = snapshot.data;
            return getwalletUI();
          }
          return getwalletUI();
        });
  }

  @override
  Widget build(BuildContext context) {
    return getwalletdetails();
  }

  Widget getwalletUI() {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.green[900],
      // color: Colors.blue,
      // height: MediaQuery.of(context).size.height,
      //width: double.infinity,
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        backgroundColor: Color.fromRGBO(123, 212, 165, 1),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderStatus(
                  status: "P",
                ),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Text(
          'My Transactions',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Padding(
                    //   padding: EdgeInsets.only(top: 0),
                    //   child: Container(
                    //       child: IconButton(
                    //           icon: Icon(
                    //             Icons.arrow_back_ios,
                    //             size: 30,
                    //             color: Colors.white,
                    //           ),
                    //           onPressed: () {
                    //             Navigator.of(context).pop();
                    //           })),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Container(
                          color: Colors.transparent,
                          child: Text(
                            "Total  Transaction Amount",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    '\u20B9' + ' ' + '${this.walbalance}',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),

          //draggable sheet
          DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 245, 248, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Bank Transaction Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 32),
                      ),
                      SizedBox(
                        height: 24,
                      ),

                      //   Container for buttons
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 32,
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.grey[900]),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200] ?? Colors.grey,
                                        blurRadius: 10.0,
                                        spreadRadius: 4.5)
                                  ]),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Processing",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: Colors.grey[900]),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                          color: Colors.grey[200] ?? Colors.grey,
                                          blurRadius: 10.0,
                                          spreadRadius: 4.5)
                                  ]),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      if (flag == 0)
                        Center(
                          child: Container(
                            child: Text(
                              "Transactions Records Not Available",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (flag == 1) listviewdata(),
                      SizedBox(
                        height: 16,
                      ),

                      //now expense
                    ],
                  ),
                  controller: scrollController,
                ),
              );
            },
            initialChildSize: 0.85,
            minChildSize: 0.65,
            maxChildSize: 1,
          )
        ],
      ),
    );
  }

  listviewdata() {
    return new Consumer<CartProvider>(builder: (context, ordermodel, child) {
      return ordermodel.banktrascation.length == 0 ||
              ordermodel.bankflagnum == 0
          ? MaterialApp(
              home: Container(child: Center(child: Text("NO data"))),
            )
          : transaclist(context, ordermodel.banktrascation);
    });
  }

  transaclist(
    BuildContext context,
    List<BankTrascationModel> trasdata,
  ) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 32),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: <Widget>[
              // Container(
              //   decoration: BoxDecoration(
              //       color: Colors.grey[200],
              //       borderRadius: BorderRadius.all(Radius.circular(10))),
              //   child: Icon(
              //     Icons.calendar_today_outlined,
              //     color: Colors.lightBlue[900],
              //   ),
              //   padding: EdgeInsets.all(12),
              // ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: "Status : ",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                          TextSpan(
                              text: '${trasdata[index].status}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ])),
                    SizedBox(
                      height: 4,
                    ),
                    // Text(
                    //   trasdata[index].description != null
                    //       ? trasdata[index].description
                    //       : "description",
                    //   style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w700,
                    //       color: Colors.grey[500]),
                    // ),

                    RichText(
                        text: TextSpan(
                            text: "Trans Date : ",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                          TextSpan(
                              text: '${trasdata[index].transDate}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ])),
                    SizedBox(
                      height: 4,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Trans ID : ",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                          TextSpan(
                              text: '${trasdata[index].rzpTransId}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ])),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (trasdata[index].status == "processed")
                    Text(
                      '\u20B9' + ' ' + '${trasdata[index].amount}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.green),
                    ),
                  if (trasdata[index].status == "processing" ||
                      trasdata[index].status == "queue" ||
                      trasdata[index].status == "pending")
                    Text(
                      '\u20B9' + ' ' + '${trasdata[index].amount}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.red),
                    ),
                ],
              ),
            ],
          ),
        );
      },
      shrinkWrap: true,
      itemCount: trasdata.length,
      padding: EdgeInsets.all(0),
      controller: ScrollController(keepScrollOffset: false),
    );
  }
}
