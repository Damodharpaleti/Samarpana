import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';


double total = 0.0;

class CartCounters extends StatefulWidget {
  final Product data;
  final int initialNumOfItems;
  const CartCounters({Key? key, required this.data, this.initialNumOfItems = 0}) : super(key: key);

  @override
  _CartCountersState createState() => _CartCountersState();
}

class _CartCountersState extends State<CartCounters> {
  final dbHelper = DBProvider.instance;
  String textHolder = 'Add';
  late int numOfItems;

  @override
  void initState() {
    super.initState();
    numOfItems = widget.initialNumOfItems;
  }

  void changeText() {
    setState(() {
      textHolder = 'Added';
      numOfItems++;
      calculatePrice();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          numOfItems.toString() +
              " " +
              "Item Total" +
              " " +
              "|" +
              " " +
              total.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color.fromRGBO(123, 212, 165, 1),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (textHolder == "Add")
          Container(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: ElevatedButton(
              onPressed: changeText,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(255, 95, 167, 1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                shape: const StadiumBorder(),
              ),
              child: Text(textHolder),
            ),

            // FlatButton(
            //   child: Text(
            //     'Add',
            //     style: TextStyle(fontSize: 15.0),
            //   ),
            //   color: Colors.red,
            //   textColor: Colors.white,
            //   onPressed: () {

            //   },
            //   shape: StadiumBorder(),
            // ),
          ),
        if (textHolder == "Added")
          Container(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: ElevatedButton(
              onPressed: changeText,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(123, 212, 165, 1),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                shape: const StadiumBorder(),
              ),
              child: Text(textHolder),
            ),

            // FlatButton(
            //   child: Text(
            //     'Add',
            //     style: TextStyle(fontSize: 15.0),
            //   ),
            //   color: Colors.red,
            //   textColor: Colors.white,
            //   onPressed: () {

            //   },
            //   shape: StadiumBorder(),
            // ),
          ),
        // Container(
        //   padding: EdgeInsets.only(left: 20, right: 10),
        //   child: FlatButton(
        //     child: Text(
        //       'Add',
        //       style: TextStyle(fontSize: 15.0),
        //     ),
        //     color: Color.fromRGBO(255, 95, 167, 1),
        //     textColor: Colors.white,
        //     onPressed: () {
        //       this.widget.numOfItems++;
        //       calculatePrice();
        //       Scaffold.of(context).showSnackBar(SnackBar(
        //         // content: Text("Iteam added to the cart"),
        //         content: Text(
        //           this.widget.numOfItems.toString() +
        //               " " +
        //               "Item Total" +
        //               " " +
        //               "|"
        //                   " " +
        //               total.toString(),
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         // content: Text(
        //         //   this.widget.numOfItems.toString() +
        //         //       " " +
        //         //       this.widget.data.productName +
        //         //       " added to cart",
        //         //   style: TextStyle(
        //         //     color: Colors.white,
        //         //     fontSize: 16,
        //         //     fontWeight: FontWeight.bold,
        //         //   ),
        //         // ),
        //         duration: Duration(seconds: 2),
        //         backgroundColor: Color.fromRGBO(123, 212, 165, 1),
        //       ));

//center Toast
        // Fluttertoast.showToast(
        //     msg: this.widget.numOfItems.toString() +
        //         " " +
        //         this.widget.data.productName +
        //         " added to cart",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIos: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

        //
        // Navigator.push(
        //   context,
        // MaterialPageRoute(
        //   builder: (context) => ProductFullDetails(
        //       //product: data,
        //       ),
        // ),
        // MaterialPageRoute(
        //   // builder: (context) => cartpage(
        //   //     //product: data,
        //   //     ),

        //   // redirecting Other CartPage
        //   builder: (context) => CartPage(
        //       //product: data,
        //       ),
        // ),
        // );
        //
        //     },
        //     shape: StadiumBorder(),
        //   ),
        // )
        // buildOutlineButton(
        //   icon: Icons.remove,
        //   press: () {
        //     // _deleteCart();
        //     if (this.widget.numOfItems > 0) {
        //       setState(() {
        //         this.widget.numOfItems--;
        //         calculatePrice();
        //         //_addTocart();
        //       });
        //       //  UpdateCart();
        //     } else if (this.widget.numOfItems == 0) {
        //       _deleteCart();
        //     }
        //   },
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
        //   child: Text(
        //     // if our item is less  then 10 then  it shows 01 02 like that
        //     this.widget.numOfItems.toString().padLeft(2, "0"),
        //     style: Theme.of(context).textTheme.headline6,
        //   ),
        // ),
        // buildOutlineButton(
        //     icon: Icons.add,
        //     press: () {
        //       setState(() {
        //         this.widget.numOfItems++;
        //         // _addTocart();
        //         calculatePrice();
        //       });
        //     }),
      ],
    );
  }

  SizedBox buildOutlineButton({IconData? icon, VoidCallback? press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  Widget _addTocart(Product cp, double total, int numOfItems) {
    print(">>>>>>>>>call insert here>>>>>>" + cp.productId.toString());

    double totalprice = total;
    print(">>>>>>>>>call insert here>>>>>>66666");
    dbHelper.productInsert(
        cp.productId,
        cp.productName,
        cp.productCode,
        cp.priceValue,
        totalprice,
        cp.priceMinQuantity,
        cp.brandName,
        cp.priceId,
        cp.cityId,
        numOfItems);
    print(">>>>>>>>>call insert here>>>>>>>");
    //print(productLocal.brandname);
    print(total);
    print(">>>>>>>>>call insert here>>>>>>>");
    debugPrint(widget.data.priceValue);
    debugPrint(widget.data.productName);
    debugPrint(widget.data.priceMinQuantity.toString());
    debugPrint(numOfItems.toString());
    return const SizedBox.shrink();
  }

  void _deleteCart() {
    print(
        ">>>>>>>>>>>>>>>update the cart based on calculation3333 inside detail2222");
    final Product deleteProd = widget.data;
    final int id = deleteProd.productId ?? 0;
    dbHelper.delete(id);
    print(
        ">>>>>>>>>>>>>>>update the cart based on calculation3333 inside detail");
    // dbHelper.dbdelete(dId);
    // Product product;
  }

  void calculatePrice() {
    print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
    _deleteCart();
    final Product cp = widget.data;

    int Quantity = numOfItems;
    //data.price
    // double price = double.parse(cp.price);
    final double price = double.parse(widget.data.priceValue ?? '0');
    total = Quantity * price;
    _addTocart(cp, total, numOfItems);
    print("calculate total in details page>>");
    print(total);
    print("calculate total in details page>>");
    //delete(pid);
    //insert(produ, total);
  }
  // Widget _addTocart(cp, total, numOfItems) {
  //   print(">>>>>>>>>call insert here>>>>>>" + cp.productId.toString());

  //   double totalprice = total;
  //   print(">>>>>>>>>call insert here>>>>>>>44444");
  //   dbHelper.productInsert(
  //       cp.productId,
  //       cp.productName,
  //       cp.productCode,
  //       cp.priceValue,
  //       totalprice,
  //       cp.priceMinQuantity,
  //       cp.brandName,
  //       cp.priceId,
  //       cp.cityId,
  //       numOfItems);
  //   print(">>>>>>>>>call insert here>>>>>>>");
  //   //print(productLocal.brandname);
  //   print(total);
  //   print(">>>>>>>>>call insert here>>>>>>>");
  //   debugPrint(this.widget.data.priceValue);
  //   debugPrint(this.widget.data.productName);
  //   debugPrint(this.widget.data.priceMinQuantity.toString());
  //   debugPrint(this.widget.numOfItems.toString());
  // }

  // Widget _deleteCart() {
  //   print(">>>>>>>>>>>>>>>update the cart based on calculation2222");
  //   Product deleteProd;
  //   deleteProd = this.widget.data;
  //   int id = deleteProd.productId;
  //   dbHelper.delete(id);
  //   print(">>>>>>>>>>>>>>>update the cart based on calculation3333");
  //   // dbHelper.dbdelete(dId);
  //   // Product product;
  // }

  // void calculatePrice() {
  //   print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
  //   _deleteCart();
  //   Product cp;
  //   //int pid = cp.productId;
  //   cp = this.widget.data;

  //   int Quantity = this.widget.numOfItems;
  //   //data.price
  //   // double price = double.parse(cp.price);
  //   double price = double.parse(this.widget.data.priceValue);
  //   total = Quantity * price;
  //   _addTocart(cp, total, this.widget.numOfItems);
  //   //delete(pid);
  //   //insert(produ, total);
  // }

  void UpdateCart() {
    double updatedPrice = total;
    int pid = widget.data.productId ?? 0;
    dbHelper.updateCart(updatedPrice, pid);
    print(">>>>>>>>>>>>>>>update the cart based on calculation");
  }
}
