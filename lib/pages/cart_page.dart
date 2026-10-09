import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/components/loader_provider.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/pages/verify_address.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/widgets/samarapanaProduct.dart';
import 'package:Samarpana/widgets/widget_cart_card.dart';
import 'package:Samarpana/widgets/widget_cart_product.dart';
import 'package:flutter/material.dart';
// import 'package:modal_progress_hud_ng/modal_progress_hud_ng.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  //Added scroll bar as Listtile inbuild not supports scrollview
  final ScrollController _scrollController = ScrollController();
  List<UserdatafromDB> list = [];
  final dbHelper = DBProvider.instance;
  UserdatafromDB? model;
  @override
  void initState() {
    super.initState();
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.resetSreams();
    caritemList.updaterecord();
    caritemList.getuseraddress();
    fetch();
  }

  fetch() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          // model = UserdatafromDB(
          //   row["id"].toString(),
          //   row["firstName"],
          //   row["lastName"],
          //   row["address1"],
          //   row["address2"],
          //   row["state"],
          //   row["city"],
          //   row["pinCode"],
          //   row["mobileNumber"],
          //   row["token"],
          //   // row["emailId"],
          //   // row["walletamt"],
          // ),
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
          list.add(model!);
        });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(builder: (context, loadModel, chield) {
      return new WillPopScope(
          onWillPop: () async {
              await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => samarapanaProduct(
                      key: UniqueKey(),
                      categoryId: 1,
                    ),
              ),
            );
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'CART ITEMS',
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Color.fromRGBO(123, 212, 165, 1),
              leading: IconButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => samarapanaProduct(
                                key: UniqueKey(),
                                categoryId: 1,
                              )));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: ModalProgressHUD(
              inAsyncCall: loadModel.isApiCallPocess,
              opacity: 0.3,
              progressIndicator: CircularProgressIndicator(),
              child: _cartItemList(),
            ),
          ));
      // return new Scaffold(

      //   resizeToAvoidBottomInset: false,
      //   body: ModalProgressHUD(
      //       inAsyncCall: loadModel.isApiCallPocess,
      //       opacity: 0.3,
      //       child: _cartItemList()),
      // );
    });
  }

  Widget _cartItemList() {
    return new Consumer<CartProvider>(builder: (context, cartmodel, chield) {
      if (cartmodel.CartItems.length > 0) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: cartmodel.CartItems.length,
                      itemBuilder: (context, index) {
                        return CartProduct(
                          data: cartmodel.CartItems[index],
                        );
                      }),
                ),
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   // children: [
                //   //   ListView.builder(
                //   //       shrinkWrap: true,
                //   //       physics: ClampingScrollPhysics(),
                //   //       scrollDirection: Axis.vertical,
                //   //       itemCount: cartmodel.CartItems.length,
                //   //       itemBuilder: (context, index) {
                //   //         return CartProduct(
                //   //           data: cartmodel.CartItems[index],
                //   //         );
                //   //       }),

                //   // ],
                // ),
              ),
            ),
            Container(
              color: Color.fromRGBO(123, 212, 165, 1),
              width: MediaQuery.of(context).size.width,
              height: 85,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          new Text(
                            '${cartmodel.totalAmount}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Check Out',
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setDouble("totalAmount", cartmodel.totalAmount);
                          if (list.length != 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyAddress(
                                          totalamt: cartmodel.totalAmount,
                                        )));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => cartpage()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                          backgroundColor: Color.fromRGBO(255, 95, 167, 1),
                          shape: StadiumBorder(),
                        ),
                      ),
                    ]),
              ),
            )
            // Container(
            //   color: Colors.white,
            //   width: MediaQuery.of(context).size.width,
            //   height: 100,
            //   child: Padding(
            //     padding: EdgeInsets.all(10),
            //     child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               new Text(
            //                 'Total',
            //                 style: TextStyle(
            //                     fontSize: 15, fontWeight: FontWeight.bold),
            //               ),
            //               new Text(
            //                 '${cartmodel.totalAmount}',
            //                 style: TextStyle(
            //                     fontSize: 25, fontWeight: FontWeight.bold),
            //               )
            //             ],
            //           ),
            //           FlatButton(
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Check Out',
            //                   style: TextStyle(color: Colors.white),
            //                 ),
            //                 Icon(Icons.chevron_right, color: Colors.white),
            //               ],
            //             ),
            //             onPressed: () async {
            //               final SharedPreferences prefs =
            //                   await SharedPreferences.getInstance();
            //               prefs.setDouble("totalAmount", cartmodel.totalAmount);
            //               if (list.length != 0 &&
            //                   cartmodel.userAddressmodel != null) {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => VerifyAddress(
            //                               totalamt: cartmodel.totalAmount,
            //                             )));
            //               } else {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => LoginPage()));
            //               }
            //             },
            //             padding: EdgeInsets.all(15),
            //             color: Colors.redAccent,
            //             shape: StadiumBorder(),
            //           ),
            //         ]),
            //   ),
            // )
          ],
        );
      } else {
        print(">>>>>>>>>>>cart provider is emty");
        return Container(
          padding: EdgeInsets.only(left: 139),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                new Text(
                  'Cart is Empty',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ]),
        );
      }
    });
  }
}
