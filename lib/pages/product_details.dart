import 'package:Samarpana/model/Product.dart';
import 'package:Samarpana/pages/base_page.dart';
import 'package:Samarpana/widgets/widget_product_details.dart';
import 'package:flutter/material.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key? key, required this.product}) : super(key: key);

  Product product;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  @override
  Widget pageUI() {
    return ProductDetailsWidget(
      key: UniqueKey(),
      data: this.widget.product,
    );
  }
}
