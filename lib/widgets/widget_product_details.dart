// import 'package:flutter/material.dart';

// subrath sir code

import 'package:Samarpana/components/Product_DetailsCart%20_counter.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/Product.dart';
import 'package:flutter/material.dart';

// import 'package:subjee/widgets/widget_product_details_fullgae.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({required Key key, required this.data}) : super(key: key);

  final Product data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20),
                    child: productImage(data, context)),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                    visible: data.calculateDiscount() > 0,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.green),
                        child: Text(
                          '${data.calculateDiscount()}% OFF',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data.productName ?? '',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.only(top: 3),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(data.productQuantity ?? ''),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: CartCounter(
                      //       data: data,
                      //       numOfItems: 0,
                      //     )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProductDetailsCart(
                            productdata: data,
                            numOfItems: 0,
                          )),
                      // FlatButton(
                      //   child: Text(
                      //     'Add to cart',
                      //     style: TextStyle(fontSize: 15.0),
                      //   ),
                      //   color: Colors.red,
                      //   textColor: Colors.white,
                      //   onPressed: () {

                      //     print(
                      //         'printing add to cart in product details>>>>>>>>>');

                      //     Navigator.push(
                      //       context,
                      //       // MaterialPageRoute(
                      //       //   builder: (context) => ProductFullDetails(
                      //       //       //product: data,
                      //       //       ),
                      //       // ),
                      //       MaterialPageRoute(
                      //         builder: (context) => cartpage(
                      //             //product: data,
                      //             ),
                      //       ),
                      //     );
                      //   },
                      // )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Brand name : ",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                            TextSpan(
                                text: data.brandName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ])),

                      //Text("product details"),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "MarketPrice : ",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                            TextSpan(
                                text: data.marketPrice,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ])),

                      //Text("product details"),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Price : ",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                            TextSpan(
                                text: data.priceValue,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ])),

                      //Text("product details"),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Min quantity  : ",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                            TextSpan(
                                text: data.priceMinQuantity.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ])),
                      //Text("product details"),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: Container(
                    child: RichText(
                      text: TextSpan(
                        text: "Product Description : ",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: data.productDescription,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(top: 3),
                //   // child: WidgetCategory(),
                //   child: WidgetOfferProduct(
                //       levelName: "Recomended Product", tagId: data.cId),
                // )
                // ProductFullDetails(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productImage(Product product, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xffE65829).withAlpha(40),
          ),
          Image.network(
            Config.imageurl + (product.productCode ?? '') + '.png',
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
