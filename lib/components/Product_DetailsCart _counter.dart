import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/pages/cart_page.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';

double total = 0.0;

class ProductDetailsCart extends StatefulWidget {
  ProductDetailsCart({Key? key, required this.productdata, required this.numOfItems})
      : super(key: key);
  final Product productdata;

  final int numOfItems;
  @override
  ProductDetailsCartState createState() => ProductDetailsCartState();
}

class ProductDetailsCartState extends State<ProductDetailsCart> {
  final dbHelper = DBProvider.instance;
  late int itemCount;

  @override
  void initState() {
    super.initState();
    itemCount = widget.numOfItems;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 1),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: StadiumBorder(),
            ),
            child: Text(
              'Add to cart',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                print("increment here>>>>>>>>>>");
                itemCount++;
                calculatePrice();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  // content: Text("Iteam added to the cart"),
                  content: Text(
                    itemCount.toString() +
                        " " +
                        "Item Total" +
                        " " +
                        "|"
                            " " +
                        total.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  //+ " added to cart"),
                  backgroundColor: Colors.green,
                ));
                print(itemCount);
                print("increment here>>>>>>>>>>");
              });
            },
          ),
        ),
        // buildOutlineButton(
        //   icon: Icons.remove,
        //   press: () {
        //     // _deleteCart();
        //     if (this.widget.numOfItems > 0) {
        //       setState(() {
        //         this.widget.numOfItems--;

        //         print('calling inser here decrement>>>>>>>>>>>>');
        //         //calculatePrice();
        //       });
        //       //  UpdateCart();
        //     } else if (this.widget.numOfItems == 0) {
        //       print('calling inser here nonincrement>>>>>>>>>>>>');
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
        //         print('calling inser here increment>>>>>>>>>>>>');
        //         // calculatePrice();
        //         // _addTocart();
        //         //calculatePrice();
        //       });
        //     }),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: StadiumBorder(),
            ),
            child: Text(
              'Buy now',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
            onPressed: () {
              calculatePrice();

              //
              Navigator.push(
                context,
                // MaterialPageRoute(
                //   builder: (context) => ProductFullDetails(
                //       //product: data,
                //       ),
                // ),
                MaterialPageRoute(
                  // builder: (context) => cartpage(
                  //     //product: data,
                  //     ),

                  // redirecting Other CartPage
                  builder: (context) => CartPage(
                      //product: data,
                      ),
                ),
              );
              //
            },
          ),
        )
      ],
    );
  }

  SizedBox buildOutlineButton({required IconData icon, required Function press}) {
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
        onPressed: () => press(),
        child: Icon(icon),
      ),
    );
  }

  void _addTocart(cp, total, numOfItems) {
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
    debugPrint(this.widget.productdata.priceValue);
    debugPrint(this.widget.productdata.productName);
    debugPrint(this.widget.productdata.priceMinQuantity.toString());
    debugPrint(this.widget.numOfItems.toString());
  }

  void _deleteCart() {
    print(
        ">>>>>>>>>>>>>>>update the cart based on calculation3333 inside detail2222");
    Product deleteProd;
    deleteProd = this.widget.productdata;
    int id = deleteProd.productId ?? 0;
    dbHelper.delete(id);
    print(
        ">>>>>>>>>>>>>>>update the cart based on calculation3333 inside detail");
    // dbHelper.dbdelete(dId);
    // Product product;
  }

  calculatePrice() {
    print(">>>>>>>>>>>>>>>update the cart based on calculation11111");
    _deleteCart();
    Product cp;
    //int pid = cp.productId;
    cp = this.widget.productdata;

    int Quantity = itemCount;
    //data.price
    // double price = double.parse(cp.price);
    double price = double.parse(this.widget.productdata.priceValue ?? '0.0');
    total = Quantity * price;
    _addTocart(cp, total, itemCount);
    print("calculate total in details page>>");
    print(total);
    print("calculate total in details page>>");
    //delete(pid);
    //insert(produ, total);
  }
  
}
