import 'package:Samarpana/config.dart';
import 'package:Samarpana/model/LoginRespose.dart';
//import 'package:Samarpana/pages/Report_issue.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/Order_details_Model.dart';
import 'package:Samarpana/pages/base_page.dart';
import 'package:Samarpana/widgets/widget_checkpoint.dart';

class MyordersProductList extends BasePage {
  final String mobileNumber;
  final OrderModel orderModels;

  MyordersProductList({
    Key? key,
    required this.mobileNumber,
    required this.orderModels,
  }) : super(key: key);

  @override
  _MyordersProductListState createState() =>
      _MyordersProductListState();
}


class _MyordersProductListState extends BasePageState<MyordersProductList> {
  late APIService apiService;
  bool isCheck = false;
  final dbHelper = DBProvider.instance;
  late UserdatafromDB usermodel;
 late String firstuserName;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    fetch();
  }

  @override
 Widget pageUI() {
  List<OrderModel> ordermodel = [];
  return orderDetailsUI(ordermodel);
}


  fetch() async {
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          print(allRows);
          usermodel = UserdatafromDB(
            row["id"],
            row["name"],
            // row["lastName"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            // row["emailId"],
            row["walletamt"],
          );
        firstuserName = usermodel.name ?? "";
          list.add(usermodel);
        });
    print(allRows);
  }

  Widget orderDetailsUI(List<OrderModel> model) {
final OrderModel orderModel =
    ModalRoute.of(context)!.settings.arguments as OrderModel;
    // if (orderModel.totalprice < 200) {
    //   deliverycharges = 20.00;
    // } else {
    //   deliverycharges = 0.00;
    //}
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Order Number :"
            "${orderModel.invoiceNumber}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "Date :"
            "${orderModel.orderdate}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Divider(
            color: Colors.green[300],
            thickness: 2.0,
          ),
          Text(
            "Delivery To",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            "${orderModel.address}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${orderModel.city}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${orderModel.state}",
            style: Theme.of(context).textTheme.labelText,
          ),
          Text(
            "${orderModel.pincode}",
            style: Theme.of(context).textTheme.labelText,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Payment Method",
            style: Theme.of(context).textTheme.labelHeading,
          ),
          Text(
            "${orderModel.paymentMethod}",
            style: Theme.of(context).textTheme.labelText,
          ),
          // Padding(
          //     padding: const EdgeInsets.only(left: 260),
          //     child: FlatButton(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: new BorderRadius.circular(16.0)),
          //       color: Colors.redAccent,
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => ReportIssue(
          //                 username: this.firstuserName,
          //                 mobileNumber: this.widget.mobileNumber,
          //                 orderNumber: "${orderModel.invoiceNumber}"),
          //           ),
          //         );
          //       },
          //       child: Text(
          //         "Report Issue",
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 16,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     )),
          Divider(
            thickness: 1.5,
            color: Colors.green[300],
          ),
          CheckPoints(
            checkedTill: 0,
            checkPointFilledColor: Colors.redAccent,
            checkPoints: ["Processing", "Shipping", "Delivered"],
          ),
          Divider(
            color: Colors.grey,
          ),
          listOrderItems(model),
          Divider(
            color: Colors.green[900],
            thickness: 2.0,
          ),
          itemsTotal(
            "Delivery Charges",
            "${orderModel.deliveryCharges}",
              textStyle: const TextStyle(fontSize: 14),

          ),
          itemsTotal(
            "Items Total",
            "${orderModel.totalprice}",
              textStyle: const TextStyle(fontSize: 14),

          ),
          SizedBox(
            height: 30,
          ),
          // if (isCheck == true)
          //   Center(
          //       child: FlatButton(
          //           color: Colors.red,
          //           onPressed: () {},
          //           child: Text(
          //             "Return Products",
          //             style: TextStyle(color: Colors.white),
          //           )))
        ],
      ),
    );
  }

  Widget listOrderItems(List<OrderModel> orderModel) {
final OrderModel orderModel =
    ModalRoute.of(context)!.settings.arguments as OrderModel;

    return ListView.builder(
      itemCount: orderModel.productList.length,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return productslitsItems(orderModel.productList[index]);
      },
    );
  }

  Widget productslitsItems(ProductLists productLists) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // new Checkbox(
            //   activeColor: Colors.red,
            //   checkColor: Colors.white,
            //   value: this.isCheck,
            //   onChanged: (bool v) {
            //     this.isCheck = v;
            //     setState(() {});
            //   },
            // ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 44,
                maxHeight: 44,
              ),
              child: Image.network(
                Config.imageurl + productLists.productCode + '.png',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productLists.productName,
                  style: Theme.of(context).textTheme.productnameText,
                ),
                new Text(
                  "Qty :" + "${productLists.numOfItems}",
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              productLists.price,
              style: Theme.of(context).textTheme.productnameText,
            ),
          ],
        )
      ],
    );
  }

  Widget itemsTotal(String label, String value, { required TextStyle textStyle}) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity(
        horizontal: 0,
        vertical: -4,
      ),
      contentPadding: EdgeInsets.fromLTRB(2, -10, 2, -10),
      title: new Text(
        label,
        style: Theme.of(context).textTheme.labelHeading,
      ),
      trailing: new Text(
        "$value",
        style: Theme.of(context).textTheme.labelText,
      ),
    );
  }
}

extension CustomStyles on TextTheme {
  TextStyle get labelHeading {
    return TextStyle(
        fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold);
  }

  TextStyle get labelText {
    return TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold);
  }

  TextStyle get productnameText {
    return TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);
  }
}
