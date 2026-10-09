// import 'package:Samarpana/model/SamarpanaProductDetails.dart';

// import 'package:Samarpana/utils/dataBase.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:flutter/foundation.dart';

// class CartCounter extends StatefulWidget {
//   double total = 0.0;
//   CartCounter({Key key, this.data, this.numOfItems}) : super(key: key);
//   SamarpanaProductDetails data;
//   int numOfItems = 0;
//   @override
//   _CartCounterState createState() => _CartCounterState();
// }

// class _CartCounterState extends State<CartCounter> {
//   final dbHelper = DBProvider.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.only(left: 20, right: 10),
//           child: FlatButton(
//             child: Text(
//               'Add',
//               style: TextStyle(fontSize: 15.0),
//             ),
//             color: Colors.red,
//             textColor: Colors.white,
//             onPressed: () {
//               this.widget.numOfItems++;
//               calculatePrice();
//               Scaffold.of(context).showSnackBar(SnackBar(
//                 // content: Text("iteam Added"),
//                 //  content: Text("Iteam added to the cart"),
//                 content: Text(
//                   this.widget.numOfItems.toString() +
//                       " " +
//                       "Item Total" +
//                       " " +
//                       "|"
//                           " " +
//                       this.widget.total.toString(),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 duration: Duration(seconds: 3),
//                 backgroundColor: Colors.green,
//               ));
//             },
//             shape: StadiumBorder(),
//           ),
//         )
//       ],
//     );
//   }

//   SizedBox buildOutlineButton({IconData icon, Function press}) {
//     return SizedBox(
//       width: 40,
//       height: 32,
//       child: OutlineButton(
//         padding: EdgeInsets.zero,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         onPressed: press,
//         child: Icon(icon),
//       ),
//     );
//   }

//   Widget _addTocart(cp, total, numOfItems) {
//     print(">>>>>>>>>call insert here>>>>>>" + cp.productId.toString());

//     double totalprice = total;
//     print(">>>>>>>>>call insert here>>>>>>>44444");
//     // dbHelper.productInsert(
//     //     cp.productId,
//     //     cp.productName,
//     //     cp.productCode,
//     //     cp.priceValue,
//     //     totalprice,
//     //     cp.priceMinQuantity,
//     //     cp.brandName,
//     //     cp.priceId,
//     //     numOfItems);
//     print(">>>>>>>>>call insert here>>>>>>>");
//     //print(productLocal.brandname);
//     print(total);
//     print(">>>>>>>>>call insert here>>>>>>>");
//     // debugPrint(this.widget.data.price);
//     debugPrint(this.widget.data.productName);
//     debugPrint(this.widget.data.priceMinQuantity.toString());
//     debugPrint(this.widget.numOfItems.toString());
//   }

//   Widget _deleteCart() {
//     print(">>>>>>>>>>>>>>>update the cart based on calculation2222");
//     SamarpanaProductDetails deleteProd;
//     deleteProd = this.widget.data;
//     int id = deleteProd.productId;
//     dbHelper.delete(id);
//     print(">>>>>>>>>>>>>>>update the cart based on calculation3333");
//     // dbHelper.dbdelete(dId);
//     // Product product;
//   }

//   void calculatePrice() {
//     print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
//     _deleteCart();
//     SamarpanaProductDetails cp;
//     //int pid = cp.productId;
//     cp = this.widget.data;

//     int Quantity = this.widget.numOfItems;
//     //data.price
//     // double price = double.parse(cp.price);
//     double price = double.parse(this.widget.data.priceValue.toString());
//     this.widget.total = Quantity * price;
//     _addTocart(cp, this.widget.total, this.widget.numOfItems);
//     //delete(pid);
//     //insert(produ, total);
//   }

//   void UpdateCart() {
//     double updatedPrice = this.widget.total;
//     int pid = this.widget.data.productId;
//     dbHelper.updateCart(updatedPrice, pid);
//     print(">>>>>>>>>>>>>>>update the cart based on calculation");
//   }
// }
