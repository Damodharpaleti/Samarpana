// import 'package:Samarpana/components/cart_provider.dart';
// import 'package:Samarpana/config.dart';
// import 'package:Samarpana/model/ProductLocal.dart';
// import 'package:Samarpana/utils/constants.dart';
// import 'package:Samarpana/utils/dataBase.dart';
// import 'package:Samarpana/utils/message_pop.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// double total = 0.0;

// class CartProduct extends StatefulWidget {
//   CartProduct({this.data});
//   ProductLocal data;

//   //int numOfItems = 0;
//   //double total = 0.0;

//   @override
//   _CartProductState createState() => _CartProductState();
// }

// class _CartProductState extends State<CartProduct> {
//   final dbHelper = DBProvider.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2.0,
//       margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
//       child: Container(
//         decoration: BoxDecoration(color: Colors.white),
//         child: makeListTitle(context),
//       ),
//     );
//   }

//   ListTile makeListTitle(BuildContext context) => ListTile(
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//         leading: Container(
//           height: 100,
//           width: 50,
//           alignment: Alignment.center,
//           child: Image.network(
//             Config.imageurl + widget.data.productCode + '.png',
//             height: 150,
//           ),
//         ),
//         title: Padding(
//           padding: EdgeInsets.all(5),
//           child: Text(
//             widget.data.productName,
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//         ),
//         subtitle: Padding(
//           padding: EdgeInsets.all(5),
//           child: Wrap(
//             direction: Axis.vertical,
//             children: [
//               Text(
//                 // '${widget.data.price.toString()}',
//                 '${widget.data.totalPrice.toString()}',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ],
//           ),
//         ),

//         // trailing: Container(
//         //   width: 120,
//         //   child: PlaceOder(
//         //     data: widget.data,
//         //     numOfItems: widget.data.numOfItems,
//         //   ),
//         // ),

//         trailing: Container(
//           width: 120,
//           child: Row(
//             children: <Widget>[
//               buildOutlineButton(
//                 icon: Icons.remove,
//                 press: () {
//                   print("print item value>>>>>>>>>>>>>>");
//                   print(widget.data.numOfItems);
//                   print("print item value>>>>>>>>>>>>>>");
//                   // _deleteCart();
//                   //this.widget.numOfItems = widget.data.numOfItems;
//                   // if (this.widget.numOfItems > 0) {
//                   if (widget.data.numOfItems > 1) {
//                     setState(() {
//                       //this.widget.numOfItems = widget.data.numOfItems;
//                       //this.widget.numOfItems--;
//                       widget.data.numOfItems--;
//                       calculatePrice();
//                     });
//                     //  UpdateCart();
//                   }
//                   //  else if (this.widget.numOfItems == 0) {
//                   else if (widget.data.numOfItems == 0 ||
//                       widget.data.numOfItems == 1) {
//                     print("the value is>>>>>>>>>>>>>>>>>>>>>>");
//                     print(widget.data.numOfItems);
//                     print("the value is>>>>>>>>>>>>>>>>>>>>>>");
//                     // _deleteCart();

//                     PopMessage.showMessage(
//                         context,
//                         'Suyoga',
//                         'Do you want to delete this item?',
//                         'Yes',
//                         () {
//                           print("yes to delete clicked>>>>>>>>>>>>>>");
//                           int id = widget.data.productId;
//                           print("delete using above id>>>>>/");
//                           print(id);
//                           print("delete using above id>>>>>/");
//                           dbHelper.delete(id);

//                           Navigator.of(context).pop(setState(() {}));
//                           //  Navigator.of(context).push(MaterialPageRoute(
//                           //     builder: (context) => CartPage()));
//                           var caritemList =
//                               Provider.of<CartProvider>(context, listen: false);
//                           caritemList.updaterecord();
//                         },
//                         buttonText2: 'No',
//                         isconformationDialog: true,
//                         onPressed2: () {
//                           Navigator.of(context).pop();
//                         });
//                   }
//                 },
//               ),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
//                 child: Text(
//                   // if our item is less  then 10 then  it shows 01 02 like that
//                   widget.data.numOfItems.toString().padLeft(1, "0"),
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//               ),
//               buildOutlineButton(
//                   icon: Icons.add,
//                   press: () {
//                     setState(() {
//                       // this.widget.numOfItems++;
//                       widget.data.numOfItems++;
//                       // // _addTocart();
//                       calculatePrice();
//                       // var caritemList = Provider.of<CartProvider>(context, listen: false);
//                       // caritemList.updaterecord();
//                     });
//                   }),
//             ],
//           ),
//         ),

// //

//         ///
//       );

//   SizedBox buildOutlineButton({IconData icon, Function press}) {
//     return SizedBox(
//       width: 35.5,
//       height: 30,
//       child: OutlineButton(
//         padding: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(13),
//         ),
//         onPressed: press,
//         child: Icon(icon),
//       ),
//     );
//   }

//   void calculatePrice() {
//     print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
//     _deleteCart();
//     ProductLocal cp;
//     //int pid = cp.productId;
//     cp = this.widget.data;

//     // int Quantity = this.widget.numOfItems;
//     int Quantity = widget.data.numOfItems;

//     //data.price
//     // double price = double.parse(cp.price);
//     double price = double.parse(this.widget.data.price);
//     total = Quantity * price;
//     // _addTocart(cp, total, this.widget.numOfItems);
//     _addTocart(cp, total, widget.data.numOfItems);
//     // widget.data.numOfItems--;
//     //delete(pid);
//     //insert(produ, total);
//   }

//   Widget _deleteCart() {
//     print(">>>>>>>>>>>>>>>update the cart based on calculation2222");
//     ProductLocal deleteProd;
//     deleteProd = this.widget.data;
//     int id = deleteProd.productId;
//     dbHelper.delete(id);
//     print(">>>>>>>>>>>>>>>update the cart based on calculation3333");
//     // dbHelper.dbdelete(dId);
//     // Product product;
//   }

//   Widget _addTocart(cp, total, numOfItems) {
//     print(">>>>>>>>>call insert here>>>>>>" + cp.productId.toString());
//     if (numOfItems == 0) {
//       print("iteam count ais less then zero>>>>>>>>>>>>>>>>>>");
//     } else {
//       double totalprice = total;
//       print(">>>>>>>>>call insert here>>>>>>>44444");
//       dbHelper.productInsert(
//           cp.productId,
//           cp.productName,
//           cp.productCode,
//           cp.price,
//           totalprice,
//           cp.priceMinQuantity,
//           cp.brandname,
//           cp.priceId,
//           cp.cityId,
//           numOfItems);
//       print(">>>>>>>>>call insert here>>>>>>>");
//       //print(productLocal.brandname);
//       print(total);
//       print(">>>>>>>>>call insert here>>>>>>>");
//       debugPrint(this.widget.data.price);
//       debugPrint(this.widget.data.productName);
//       debugPrint(this.widget.data.priceMinQuantity.toString());
//       var caritemList = Provider.of<CartProvider>(context, listen: false);
//       caritemList.updaterecord();
//       // debugPrint(this.widget.numOfItems.toString());
//     }
//   }
  
//   OutlineButton({EdgeInsets padding, RoundedRectangleBorder shape, Function onPressed, Icon child}) {}
// }

import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/ProductLocal.dart';
import 'package:Samarpana/utils/constants.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/utils/message_pop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double total = 0.0;

class CartProduct extends StatefulWidget {
  CartProduct({required this.data});
  ProductLocal data;

  //int numOfItems = 0;
  //double total = 0.0;

  @override
  _CartProductState createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final dbHelper = DBProvider.instance;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTitle(context),
      ),
    );
  }

  ListTile makeListTitle(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Container(
          height: 150,
          width: 50,
          alignment: Alignment.center,
          child: Image.network(
            Config.imageurl + widget.data.productCode + '.png',
            height: 150,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            widget.data.productName,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Text(
                // '${widget.data.price.toString()}',
                '${widget.data.totalPrice.toString()}',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),

        // trailing: Container(
        //   width: 120,
        //   child: PlaceOder(
        //     data: widget.data,
        //     numOfItems: widget.data.numOfItems,
        //   ),
        // ),

        trailing: Container(
          width: 120,
          child: Row(
            children: <Widget>[
              buildOutlineButton(
                icon: Icons.remove,
                press: () {
                  print("print item value>>>>>>>>>>>>>>");
                  print(widget.data.numOfItems);
                  print("print item value>>>>>>>>>>>>>>");
                  // _deleteCart();
                  //this.widget.numOfItems = widget.data.numOfItems;
                  // if (this.widget.numOfItems > 0) {
                  if (widget.data.numOfItems > 1) {
                    setState(() {
                      //this.widget.numOfItems = widget.data.numOfItems;
                      //this.widget.numOfItems--;
                      widget.data.numOfItems--;
                      calculatePrice();
                    });
                    //  UpdateCart();
                  }
                  //  else if (this.widget.numOfItems == 0) {
                  else if (widget.data.numOfItems == 0 ||
                      widget.data.numOfItems == 1) {
                    print("the value is>>>>>>>>>>>>>>>>>>>>>>");
                    print(widget.data.numOfItems);
                    print("the value is>>>>>>>>>>>>>>>>>>>>>>");
                    // _deleteCart();

                    PopMessage.showMessage(
                        context,
                        'Suyoga',
                        'Do you want to delete this item?',
                        'Yes',
                        () {
                          print("yes to delete clicked>>>>>>>>>>>>>>");
                          int id = widget.data.productId;
                          print("delete using above id>>>>>/");
                          print(id);
                          print("delete using above id>>>>>/");
                          dbHelper.delete(id);
                               Navigator.of(context,rootNavigator: true).pop();
                          //  Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => CartPage()));
                          var caritemList =
                              Provider.of<CartProvider>(context, listen: false);
                          caritemList.updaterecord();
                        },
                        buttonText2: 'No',
                        isconformationDialog: true,
                        onPressed2: () {
                               Navigator.of(context,rootNavigator: true).pop();
                        });
                  }
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
                child: Text(
                  // if our item is less  then 10 then  it shows 01 02 like that
                  widget.data.numOfItems.toString().padLeft(1, "0"),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              buildOutlineButton(
                  icon: Icons.add,
                  press: () {
                    setState(() {
                      // this.widget.numOfItems++;
                      widget.data.numOfItems++;
                      // // _addTocart();
                      calculatePrice();
                      // var caritemList = Provider.of<CartProvider>(context, listen: false);
                      // caritemList.updaterecord();
                    });
                  }),
            ],
          ),
        ),

//

        ///
      );

  SizedBox buildOutlineButton({required IconData icon, required VoidCallback? press}) {
    return SizedBox(
      width: 35.5,
      height: 30,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  void calculatePrice() {
    print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
    _deleteCart();
    ProductLocal cp;
    //int pid = cp.productId;
    cp = this.widget.data;

    // int Quantity = this.widget.numOfItems;
    int Quantity = widget.data.numOfItems;

    //data.price
    // double price = double.parse(cp.price);
    double price = double.parse(this.widget.data.price);
    total = Quantity * price;
    // _addTocart(cp, total, this.widget.numOfItems);
    _addTocart(cp, total, widget.data.numOfItems);
    // widget.data.numOfItems--;
    //delete(pid);
    //insert(produ, total);
  }

void _deleteCart() {
  print(">>>>>>>>>>>>>>>update the cart based on calculation2222");
  ProductLocal deleteProd;
  deleteProd = this.widget.data;
  int id = deleteProd.productId;
  dbHelper.delete(id);
  print(">>>>>>>>>>>>>>>update the cart based on calculation3333");
  // dbHelper.dbdelete(dId);
  // Product product;
}

  void _addTocart(cp, total, numOfItems) {
    print(">>>>>>>>>call insert here>>>>>>" + cp.productId.toString());
    if (numOfItems == 0) {
      print("iteam count ais less then zero>>>>>>>>>>>>>>>>>>");
    } else {
      double totalprice = total;
      print(">>>>>>>>>call insert here>>>>>>>44444");
      dbHelper.productInsert(
          cp.productId,
          cp.productName,
          cp.productCode,
          cp.price,
          totalprice,
          cp.priceMinQuantity,
          cp.brandname,
          cp.priceId,
          cp.cityId,
          numOfItems);
      print(">>>>>>>>>call insert here>>>>>>>");
      //print(productLocal.brandname);
      print(total);
      print(">>>>>>>>>call insert here>>>>>>>");
      debugPrint(this.widget.data.price);
      debugPrint(this.widget.data.productName);
      debugPrint(this.widget.data.priceMinQuantity.toString());
      var caritemList = Provider.of<CartProvider>(context, listen: false);
      caritemList.updaterecord();
      // debugPrint(this.widget.numOfItems.toString());
    }
  }
}