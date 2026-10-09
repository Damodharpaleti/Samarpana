
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/model/TimeSlot_Model.dart';
import 'package:Samarpana/pages/checkout_base.dart';
import 'package:Samarpana/pages/payment_screen.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/utils/form_helper.dart';
import 'package:Samarpana/widgets/Order_Sucess_Widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Timeslots extends CheckoutBase {
  double totalamt;
  String usermoblie;
  String token;
  CreateOrder shippingaddress;

  Timeslots({
    required this.shippingaddress,
    required this.totalamt,
    required this.usermoblie,
    required this.token,
  });
  @override
  _TimeslotsState createState() => _TimeslotsState();
}

class _TimeslotsState extends CheckoutBaseState<Timeslots> {
  TextEditingController textcontroller = new TextEditingController();
  late String couponcode;
  String? _selectedtimeslot;
  double finalamt = 0.0;
  double itemscost = 0.0;
  bool _visible = false;
  bool _visiblily = true;
  late APIService apiService;
  double walletbalance = 0;
  double waldiscount = 0;
  List<UserdatafromDB> list = <UserdatafromDB>[];
  final dbHelper = DBProvider.instance;
 late UserdatafromDB model;
  bool isCheck = false;
  bool ischecked = true;
  @override
  void initState() {
    super.initState();
    // var orderProvider = Provider.of<CartProvider>(context, listen: false);
    // orderProvider.timeslots();

    currentPage = 1;
    fetch();
    itemscost = this.widget.totalamt;
    finalamt = this.widget.totalamt;
    
    // Store the shipping address in the cart provider
    var orderProvider = Provider.of<CartProvider>(context, listen: false);
    if (this.widget.shippingaddress.shipping != null) {
      print('DEBUG Timeslots: Storing shipping address:');
      print('  address1: ${this.widget.shippingaddress.shipping?.address1}');
      print('  city: ${this.widget.shippingaddress.shipping?.city}');
      print('  state: ${this.widget.shippingaddress.shipping?.state}');
      print('  postcode: ${this.widget.shippingaddress.shipping?.postcode}');
      orderProvider.addresstProcess(this.widget.shippingaddress);
    } else {
      print('ERROR: Shipping address is null in Timeslots page!');
    }
  }

  fetch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    walletbalance = prefs.getDouble("Walletamt") ?? 0.0;
    final allRows = await dbHelper.queryuserRows();
    allRows.forEach((row) {
          model = UserdatafromDB(
            row["id"],
            row["name"],
            row["address1"],
            row["address2"],
            row["state"],
            row["city"],
            row["pinCode"],
            row["mobileNumber"],
            row["token"],
            row["walletamt"],
          );
          list.add(model);
        });
    print(model.token);
    setState(() {
      build(context);
    });
  }

  // Widget build(BuildContext context) {
  //   return new Consumer<CartProvider>(builder: (context, timeslotmodel, child) {
  //     return timeslotmodel.timeslotlist == null
  //         ? Center(
  //             child: LoginPage(),
  //           )
  //         : _listview(context, timeslotmodel.timeslotlist);

  //     //
  //   });
  // }

  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, timeslotmodel, child) {
      if (timeslotmodel.timeslotlist.isEmpty) {
        return Center(
          child: Container(
            child: Text("Loading Time Slots..."),
          ),
        );
      }
      return _listview(context, timeslotmodel.timeslotlist);
    });
  }

  Widget _listview(BuildContext context, List<Timeslot> timeslotlist) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'SUYOGA',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromRGBO(123, 212, 165, 1),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: SafeArea(
          child: timeslotwidget(timeslotlist),
        ));
  }

  Widget timeslotwidget(List<Timeslot> timeslotlist) {
    List<String> timeslot = [];
    
    // Build time slot options, handle variable list sizes
    for (int i = 0; i < timeslotlist.length && i < 3; i++) {
      final slot = timeslotlist[i];
      final morningTime = slot.time.isNotEmpty && slot.time[0].morningTime != null
          ? slot.time[0].morningTime
          : 'Morning';
      timeslot.add('${slot.dateDay} @ $morningTime');
    }
    
    // If no valid slots, show loading message
    if (timeslot.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text(
            "No time slots available. Please try again.",
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }
    //
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 1, top: 40, bottom: 3),
            children: <Widget>[
              Center(
                child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //color: Colors.blue,
                        padding: EdgeInsets.only(left: 1, top: 10, bottom: 3),
                        child: Text("Delivery Time Slots ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.only(left: 10, top: 5, bottom: 3)),
                      DropdownButton(
                        hint: Text(
                          '  Select Delivery Date & Time',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            // background: Paint()..color = Colors.green,
                          ),
                        ), // Not necessary for Option 1
                        value: _selectedtimeslot,
                        iconSize: 30,
                        iconEnabledColor: Colors.green,
                        //isExpanded: true,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedtimeslot = newValue;
                          });
                        },
                        items: timeslot.map((selectedtimeslot) {
                          return DropdownMenuItem(
                            child: new Text(
                              selectedtimeslot,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                //  background: Paint()..color = Colors.blue,
                              ),
                            ),
                            value: selectedtimeslot,
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),

                      SizedBox(
                        height: size.height * 0.15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            new Checkbox(
                                activeColor: Colors.red,
                                checkColor: Colors.white,
                                value: this.isCheck,
                                onChanged: (bool? v) {
                                  this.isCheck = v ?? false;
                                  setState(() {
                                    if (this.isCheck == true &&
                                        itemscost >= this.walletbalance) {
                                      finalamt = this.widget.totalamt -
                                          this.walletbalance;
                                      waldiscount = this.walletbalance;
                                    } else if (this.isCheck == true &&
                                        itemscost <= this.walletbalance) {
                                      waldiscount = finalamt;
                                      finalamt = this.widget.totalamt -
                                          this.waldiscount;
                                    } else {
                                      finalamt = this.widget.totalamt;
                                    }
                                  });
                                }),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Wallet Balance :",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "\u20B9 " + '${this.walletbalance}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: size.height * 0.08,
                      ),

                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "   Items Total Cost :",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("${this.widget.totalamt}" + "   ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   "   Coupon Discount :",
                          //   style: TextStyle(
                          //       fontSize: 17,
                          //       color: Colors.green,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          // Text("-" + "$_discountAmount" + "   ",
                          //     style: TextStyle(
                          //       color: Colors.red,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 18,
                          //     )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "   Wallet Discount :",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          if (isCheck == false)
                            Text("-" + '0.0' + "   ",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          if (isCheck == true)
                            Text("-" + '${this.waldiscount}' + "   ",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(color: Colors.red),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //  Padding(padding: EdgeInsets.all(10)),
                          Text(
                            "   Total Amount :",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                          Text('$finalamt' + "   ",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),

                      // FormHelper.saveButton('Next', () {
                      //   // _myActivityResult = _myActivity;
                      //   if (_selectedLocation != null) {
                      //     //  _myActivityResult = _myActivity;
                      //     var orderProvider =
                      //         Provider.of<CartProvider>(context, listen: false);
                      //     CreateOrder setTimeslot = new CreateOrder();
                      //     setTimeslot.timeSlot = _selectedLocation;
                      //     setTimeslot.status = "Order Placed Successfully";
                      //     setTimeslot.totalAmount = totalamt;
                      //     setTimeslot.deliveryCharges = deliverycharges;
                      //     orderProvider.placetimeslotProcess(setTimeslot);
                      //     print(_selectedLocation);
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => PaymentScreen(),
                      //         ));
                      //   } else {
                      //     FormHelper.showMessage(context, "SUYOGA",
                      //         "Select Delivery Date and Time", "OK", () {
                      //       Navigator.of(context).pop();
                      //     });
                      //   }
                      // }),
                    ]),
              ),
              Container(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(
                    children: [
                      // Divider(
                      //   height: size.width,
                      // ),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Icon(Icons.chevron_right,
                                          size: 30, color: Colors.white),
                                    ],
                                  ),
                                  onPressed: () {
                                    if (finalamt != 0) {
                                      //  _myActivityResult = _myActivity;
                                      var orderProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      CreateOrder setTimeslot =
                                          new CreateOrder();
                                      setTimeslot.timeSlot = _selectedtimeslot;
                                      setTimeslot.status =
                                          "Order Placed Successfully";
                                      setTimeslot.totalAmount = itemscost;
                                      setTimeslot.deliveryCharges = 0;
                                      if (isCheck == true) {
                                        setTimeslot.walletamt =
                                            this.waldiscount;
                                      } else {
                                        setTimeslot.walletamt = 0;
                                      }
                                      setTimeslot.razorpayamt = finalamt;
                                      orderProvider
                                          .placetimeslotProcess(setTimeslot);
                                      print(_selectedtimeslot);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentScreen(),
                                          ));
                                    } else if (finalamt == 0) {
                                      var orderProvider =
                                          Provider.of<CartProvider>(context,
                                              listen: false);
                                      CreateOrder setTimeslot =
                                          new CreateOrder();
                                      setTimeslot.timeSlot = _selectedtimeslot;
                                      setTimeslot.status =
                                          "Order Placed Successfully";
                                      setTimeslot.totalAmount = itemscost;
                                      setTimeslot.deliveryCharges = 0;
                                      if (isCheck == true) {
                                        setTimeslot.walletamt =
                                            this.waldiscount;
                                      } else {
                                        setTimeslot.walletamt = 0;
                                      }
                                      setTimeslot.razorpayamt = finalamt;
                                      setTimeslot.paymentMethod = "Wallet";
                                      setTimeslot.paymentMethodTitle = "Wallet";
                                      setTimeslot.transactionId =
                                          "Totally_Paid_through_Wallet";
                                      orderProvider
                                          .placetimeslotProcess(setTimeslot);
                                      orderProvider.addresstProcess(
                                          this.widget.shippingaddress);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderSucessWidgetbyWallet(),
                                          ));
                                    } else {
                                      FormHelper.showMessage(
                                          context,
                                          "SUYOGA",
                                          "Select Delivery Date and Time",
                                          "OK", () {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(255, 95, 167, 1),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 13),
                                    shape: StadiumBorder(),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )),
                ),
              )
            ]));
  }

  // Future<PromocodeModel> promocode() async {
  //   PromocodeModel data;
  //   // bool ret = false;
  //   String token = model.token;
  //   try {
  //     // String url = Config.url + Config.promocode;
  //     //  print(url);

  //     var response = await Dio().post("url",
  //         data: {
  //           "userName": model.mobileNumber,
  //           "promoCode": textcontroller.text,
  //           "totalAmount": this.widget.totalamt,
  //         },
  //         options: new Options(headers: {
  //           HttpHeaders.contentTypeHeader: 'application/json',
  //           HttpHeaders.authorizationHeader: 'Bearer $token',
  //         }));
  //     if (response.statusCode == 200) {
  //       //   print(response.data);
  //       data = PromocodeModel.fromJson(response.data);
  //       // return ret = true;
  //     }
  //     // print(token);
  //   } on DioError catch (e) {
  //     data = PromocodeModel.fromJson(e.response.data);
  //     print(e.response);
  //     //  return ret = false;
  //   }

  //   return data;
  // }
}

class AppCheckbox extends StatelessWidget {
  final bool value;
  final bool disabled;
  final double size;
  final ValueChanged<bool> onChanged;

  const AppCheckbox({
    Key? key,
    this.size = 24,
    this.value = false,
    this.disabled = true,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backColor = Colors.transparent;
    final checkColor = Colors.red;

    return Theme(
      data: Theme.of(context).copyWith(
        disabledColor: Colors.green,
        unselectedWidgetColor: Colors.blue,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Container(
          decoration: BoxDecoration(
            color: backColor,
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.hardEdge,
          child: Transform.scale(
            scale: size / Checkbox.width,
            child: Checkbox(
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              activeColor: Colors.red,
              checkColor: checkColor,
              value: value,
              onChanged: disabled
                  ? null
                  : (value) {
                      onChanged(value ?? false);
                    },
            ),
          ),
        ),
      ),
    );
  }
}
