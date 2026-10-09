import 'package:Samarpana/model/ProductLocal.dart';
import 'package:Samarpana/utils/constants.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';

class PlaceOder extends StatefulWidget {
  PlaceOder({Key? key, required this.data, required this.numOfItems}) : super(key: key);
  ProductLocal data;
  int numOfItems = 0;
  double total = 0.0;
  @override
  _PlaceOderState createState() => _PlaceOderState();
}

class _PlaceOderState extends State<PlaceOder> {
  final dbHelper = DBProvider.instance;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildOutlineButton(
          icon: Icons.remove,
          press: () {
            // _deleteCart();
            if (this.widget.numOfItems > 0) {
              setState(() {
                this.widget.numOfItems--;
                calculatePrice();
                //_addTocart();
              });
              //  UpdateCart();
            } else if (this.widget.numOfItems == 0) {
              _deleteCart();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            this.widget.numOfItems.toString().padLeft(1, "0"),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        buildOutlineButton(
            icon: Icons.add,
            press: () {
              setState(() {
                this.widget.numOfItems++;
                // _addTocart();
                calculatePrice();
              });
            }),
      ],
    );
  }

  SizedBox buildOutlineButton({required IconData icon, required Function press}) {
    return SizedBox(
      width: 35.5,
      height: 30,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: () => press(),
        child: Icon(icon),
      ),
    );
  }

  void _addTocart(cp, total, numOfItems) {
    double totalprice = total;

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
    debugPrint(this.widget.numOfItems.toString());
  }

  void _deleteCart() {
    ProductLocal deleteProd;
    deleteProd = this.widget.data;
    int id = deleteProd.productId;
    dbHelper.delete(id);
  }

  void calculatePrice() {
    print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
    _deleteCart();
    ProductLocal cp;
    //int pid = cp.productId;
    cp = this.widget.data;

    int Quantity = this.widget.numOfItems;
    //data.price
    // double price = double.parse(cp.price);
    double price = double.parse(this.widget.data.price);
    this.widget.total = Quantity * price;
    _addTocart(cp, this.widget.total, this.widget.numOfItems);
    //delete(pid);
    //insert(produ, total);
  }

  void UpdateCart() {
    double updatedPrice = this.widget.total;
    int pid = this.widget.data.productId;
    dbHelper.updateCart(updatedPrice, pid);
    print(">>>>>>>>>>>>>>>update the cart based on calculation");
  }
}
