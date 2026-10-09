
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/pages/product_details.dart';
import 'package:Samarpana/widgets/samarapanaProduct.dart';
import 'package:flutter/material.dart';

class WidgetOfferProduct extends StatefulWidget {
  WidgetOfferProduct({required Key key, required this.levelName, required this.tagId}) : super(key: key);

  String levelName;
  int tagId;

  @override
  _WidgetOfferProductState createState() => _WidgetOfferProductState();
}

class _WidgetOfferProductState extends State<WidgetOfferProduct> {
  late APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF4F7FA),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  this.widget.levelName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, top: 4),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => samarapanaProduct(
                                    key: ValueKey('samarapanaProduct'),
                                    // categoryId: data.categoryId,
                                    categoryId: 0,
                                  )));
                    },
                    child: Text(
                      'View ALL',
                      style: TextStyle(color: Colors.redAccent),
                    )),
              )
            ],
          ),
          _offerProductList(),
        ],
      ),
    );
  }

  Widget _offerProductList() {
    return new FutureBuilder(
        future: apiService.getTopsavingProduct(this.widget.tagId),
        builder: (BuildContext context, AsyncSnapshot<List<Product>> model) {
          if (model.hasData) {
            return _buildList(model.data ?? []);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Widget _buildList(List<Product> items) {
    return Container(
      height: 200,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            var data = items[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: 130,
                  height: 120,
                  alignment: Alignment.center,
                  // child: Image.network(
                  //   Config.imageurl + data.productCode + '.png',
                  //   height: 120,
                  // ),

                  child: InkWell(
                    onTap: () {
                      print("on click on image>>>>>>");
                      Navigator.push(
                          context,
                          // MaterialPageRoute(
                          //     builder: (context) => ProductPage(
                          //           // categoryId: data.categoryId,
                          //           categoryId: 1,
                          //         ))
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                              product: data,
                            ),
                          ));
                    },
                    child: Container(
                      child: Image.network(
                        Config.imageurl + (data.productCode ?? '') + '.png',
                        height: 120,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 5),
                          blurRadius: 15,
                        )
                      ]),
                ),
                Container(
                  width: 130,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.productName ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4, left: 4),
                  child: Row(
                    children: [
                      Text(
                        '${data.marketPrice}',
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text('${data.priceValue}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                )
              ],
            );
          }),
    );
  }
}
