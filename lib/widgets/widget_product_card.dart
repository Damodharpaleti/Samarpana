import 'package:Samarpana/components/cart_counter.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/pages/product_details.dart';
import 'package:Samarpana/utils/CustomTextStyle.dart';
import 'package:flutter/material.dart';

// keep this code

class ProductCard extends StatelessWidget {
  ProductCard({Key? key, required this.data}) : super(key: key);
  final Product data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              product: data,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            height: 165,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            right: 0, left: 0, top: 20, bottom: 8),
                        width: 100,
                        height: 130,
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.transparent,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  Config.imageurl + (data.productCode ?? '') + '.png',
                                ))))
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            '${data.productName}',
                            maxLines: 2,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        Expanded(
                            child: Text('Market Price' + ' ${data.marketPrice}',
                                style: TextStyle(
                                  height: 1.5,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ))),
                        Expanded(
                            child: Text(
                                'Min Quantity' + ' ${data.productQuantity}',
                                style: TextStyle(
                                  height: 1.4,
                                  // decoration: TextDecoration.lineThrough,
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ))),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '\u20B9' + ' ' + '${data.priceValue}',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CartCounters(
                                    data: data,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
