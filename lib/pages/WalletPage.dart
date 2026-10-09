import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/pages/AccountPage.dart';
//import 'package:Samarpana/pages/WalletPayment.dart';
import 'package:Samarpana/pages/loggin.dart';
import 'package:Samarpana/utils/VerifyPage_FormHelper.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/widget_cart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
  late UserdatafromDB model;
  TextEditingController _controler = new TextEditingController();
  double amt = 0.0;
  double walbalance = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getwalletamt();
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.getuseraddress();
    caritemList.getwalletbalance();
    fetch();
  }

  Future<double> getwalletamt() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double walletbal = prefs.getDouble("Walletamt") ?? 0.0;
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

  fetch() async {
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
  }

  Widget getwalletdetails() {
    return FutureBuilder(
        future: getwalletamt(),
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
    return list.isEmpty
        ? Center(
            child: LoginPage(),
          )
        : new Stack(
            //  resizeToAvoidBottomInset: false,
            // height: MediaQuery.of(context).size.height * 0.8,
            // margin: EdgeInsets.all(20),
            //  color: Colors.orange,
            key: scaffoldKey,
            children: [
                Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.green,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        'My Wallet',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          // Icons.shopping_cart,
                          color: Colors.white,
                          icon: Icon(
                            Icons.shopping_cart,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => cartpage(),
                              ),
                            );
                          },
                        )
                      ], systemOverlayStyle: SystemUiOverlayStyle.light,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Wallet Balance",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 3),
                            child: Text('\u20B9' + ' ' + '${this.walbalance}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Divider(
                                  color: Colors.blue,
                                  thickness: 5.0,
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Text("Add Amount to withdraw from wallet",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 50,
                                ),
                                TextFormField(
                                  controller: _controler,
                                  cursorColor: Colors.black,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.account_balance_wallet,
                                        color: Colors.green[900],
                                        size: 40,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                      ),
                                      hintText: 'Add Money To Withdraw'),
                                  onSaved: (String? value) {
                                    if (value != null && value.isNotEmpty) {
                                      this.amt = double.parse(value);
                                    }
                                  },
                                  onChanged: (val) =>
                                      this.amt = double.parse(val),
                                ),
                                // FormHelper.textInput(
                                //   context,
                                //   _controler.text = this.amt.toString(),
                                //   (value) => {
                                //     double.parse(value = this.amt.toString()),
                                //   },
                                //   controller: _controler,
                                //   hintText: "Add Money to your Wallet",
                                //   hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                //   prefixIcon: Icon(
                                //     Icons.account_balance_wallet,
                                //     color: Colors.green[900],
                                //     size: 40,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, top: 10),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    this.amt = 100;
                                    _controler.value =
                                        TextEditingValue(text: "100");
                                    print(this.amt);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green[100]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        "\u20B9" + " " + "100",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    this.amt = 200;
                                    _controler.value =
                                        TextEditingValue(text: "200");
                                    print(this.amt);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green[100]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        "\u20B9" + " " + "200",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    this.amt = 300;
                                    _controler.value =
                                        TextEditingValue(text: "300");
                                    print(this.amt);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green[100]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        "\u20B9" + " " + "300",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ))),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, top: 10),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    this.amt = 400;
                                    _controler.value =
                                        TextEditingValue(text: "400");
                                    print(this.amt);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green[100]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        "\u20B9" + " " + "400",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    this.amt = 500;
                                    _controler.value =
                                        TextEditingValue(text: "500");
                                    print(this.amt);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green[100]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        "\u20B9" + " " + "500",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ))),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    this.amt = 1000;
                                    _controler.value =
                                        TextEditingValue(text: "1000");
                                    print(this.amt);
                                  },
                                  child: Container( 
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: Colors.green[100]),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        "\u20B9" + " " + "1000",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal),
                                      ))),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    print(this.amt);
                                    if (this.amt != 0 &&
                                        this.amt <= this.walbalance) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WalletUIscreen()));
                                    } else {
                                      FormHelper.showMessage(
                                          context,
                                          "SUYOGA",
                                          " Withdraw amount is more than wallet Money",
                                          "OK", () {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                    child: Text("Withdraw Money",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  )))
                        ],
                      ),
                    ))
              ]);
  }

  // Widget addmoney() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Divider(
  //           color: Colors.blue,
  //           thickness: 5.0,
  //         ),
  //         SizedBox(
  //           height: 50,
  //         ),
  //         Text("Amount to be Added to the wallet",
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold)),
  //         SizedBox(
  //           height: 50,
  //         ),
  //         TextFormField(
  //           controller: _controler,
  //           cursorColor: Colors.black,
  //           maxLines: 1,
  //           decoration: InputDecoration(
  //               prefixIcon: Icon(
  //                 Icons.account_balance_wallet,
  //                 color: Colors.green[900],
  //                 size: 40,
  //               ),
  //               hintStyle: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.black),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(16.0)),
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(16.0),
  //                 borderSide: BorderSide(
  //                   color: Colors.black,
  //                   width: 1,
  //                 ),
  //               ),
  //               hintText: 'Add Money To Your Wallet'),
  //           onSaved: (String value) {
  //             _controler.value = TextEditingValue(text: "1000");
  //           },
  //           onChanged: (val) => this.amt = double.parse(val),
  //         ),
  //         // FormHelper.textInput(
  //         //   context,
  //         //   _controler.text = this.amt.toString(),
  //         //   (value) => {
  //         //     double.parse(value = this.amt.toString()),
  //         //   },
  //         //   controller: _controler,
  //         //   hintText: "Add Money to your Wallet",
  //         //   hintStyle: TextStyle(color: Colors.black, fontSize: 20),
  //         //   prefixIcon: Icon(
  //         //     Icons.account_balance_wallet,
  //         //     color: Colors.green[900],
  //         //     size: 40,
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }
}
