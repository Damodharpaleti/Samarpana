import 'dart:convert';

import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/AdduserAddressModel.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/PlaceOrder_model.dart';
import 'package:Samarpana/model/UseraddressModel.dart';
import 'package:Samarpana/pages/TimsSlot_Page.dart';
import 'package:Samarpana/pages/cart_page.dart';
import 'package:Samarpana/pages/checkout_base.dart';
import 'package:Samarpana/utils/VerifyPage_FormHelper.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/utils/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyAddress extends CheckoutBase {
  double? totalamt;
  VerifyAddress({Key? key, this.totalamt}) : super();
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBaseState<VerifyAddress> {
  List<UserdatafromDB> list = [];
  late APIService apiService;
  int? selectedRadio = 0;
  bool isApicallProcess = false;
  final dbHelper = DBProvider.instance;
  String accountId = "";
  late AddUserAddress addnewaddress;
  String pincode = "";

  List<UserAddressLocalModel> localaddress = [];
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.resetSreams();
    caritemList.fetch();
    caritemList.getuseraddress();
    caritemList.getwalletbalance();
    caritemList.timeslots();
    super.initState();
    apiService = new APIService();
    addnewaddress = new AddUserAddress();
    list = <UserdatafromDB>[];
    print('verifyPageAddress: initState()');
    currentPage = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget pageUI() {
    return new Consumer<CartProvider>(builder: (context, useraddress, child) {
      return _listview(useraddress.userAddressmodel, useraddress.model);
    });
    // return Consumer<CartProvider>(builder: (context, userdataCustomer, chield) {
    //   if (userdataCustomer.model.mobileNumber != null) {
    //     return _formUI(userdataCustomer.model);
    //   }
    //   return Center(
    //     child: CircularProgressIndicator(),
    //   );
    // });
  }

  Widget _listview(List<UserAddressModel> useraddlist, UserdatafromDB model) {
    CreateOrder setaddress = new CreateOrder();
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(),
            ),
          );
          return true;
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        "  Select delivery address",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 95, 167, 1)),
                      )
                    ],
                  )),
              Divider(
                color: Colors.pink,
              ),
              Container(
                color: Colors.green[100],
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.99,
                  //  height: MediaQuery.of(context).size.height * 0.90,
                  child: Container(
                      child: ListView.builder(
                          itemCount: useraddlist.length,
                          physics: ScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 220,
                                          color: selectedRadio ==
                                                  useraddlist[index].id
                                              ? Colors.grey[300]
                                              : Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Radio(
                                                  value: useraddlist[index].id,
                                                  groupValue: selectedRadio,
                                                  activeColor: Colors.pink[500],
                                                  onChanged: (val) {
                                                    if (val != null) {
                                                      setSelectedRadio(val);
                                                    }
                                                  },
                                                ),
                                                Text(model.name ?? '',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 20,
                                                    )),
                                              ]),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(model.mobileNumber ?? '',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        useraddlist[index]
                                                            .address1 ?? '',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        useraddlist[index].city,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        useraddlist[index]
                                                            .state ?? '',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                        )),
                                                    Text(
                                                        '${useraddlist[index].pinCode}',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16,
                                                        )),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (selectedRadio ==
                                                              useraddlist[index]
                                                                  .id)
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    useSafeArea:
                                                                        true,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        content:
                                                                            Stack(
                                                                         // overflow:
                                                                            //  Overflow.visible,
                                                                          children: <
                                                                              Widget>[
                                                                            Positioned(
                                                                              right: -20.0,
                                                                              top: -15.0,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: CircleAvatar(
                                                                                  child: Icon(
                                                                                    Icons.close,
                                                                                    size: 25,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                  backgroundColor: Colors.transparent,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 20),
                                                                            Form(
                                                                              key: _formKey,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: <Widget>[
                                                                                  Center(
                                                                                    child: Text(
                                                                                      'Edit Existing Address',
                                                                                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 20,
                                                                                  ),
                                                                                  FormHelper.textInput(
                                                                                    context,
                                                                                    model.address1 = useraddlist[index].address1 ?? '',
                                                                                    (value) => {
                                                                                      model.address1 = value,
                                                                                    },
                                                                                    onValidate: (value) {
                                                                                      if (model.address1?.isNotEmpty ?? false) {
                                                                                        model.address1 = value;
                                                                                      }
                                                                                    },
                                                                                    isTextArea: true,
                                                                                    hintText: "Address",
                                                                                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                    prefixIcon: Icon(
                                                                                      Icons.location_city,
                                                                                      color: Colors.black,
                                                                                      size: 30,
                                                                                    ),
                                                                                  ),
                                                                                  FormHelper.textInput(
                                                                                    context,
                                                                                    model.city = useraddlist[index].city,
                                                                                    (value) => {
                                                                                      model.city = value
                                                                                    },
                                                                                   onValidate: (value) {
  if (model.address1 != null && model.address1!.isNotEmpty) {
    model.city = value;
  }
},
                                                                                    hintText: "City",
                                                                                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                    prefixIcon: Icon(
                                                                                      Icons.location_city,
                                                                                      color: Colors.black,
                                                                                      size: 30,
                                                                                    ),
                                                                                  ),
                                                                                  FormHelper.textInput(
                                                                                    context,
                                                                                    model.state = useraddlist[index].state ?? '',
                                                                                    (value) => {
                                                                                      model.state = value,
                                                                                    },
                                                                                    onValidate: (value) {
                                                                                      if ((model.state?.isNotEmpty) ?? false) {
                                                                                        model.state = value;
                                                                                      }
                                                                                    },
                                                                                    hintText: "State",
                                                                                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                    prefixIcon: Icon(
                                                                                      Icons.location_city,
                                                                                      color: Colors.black,
                                                                                      size: 30,
                                                                                    ),
                                                                                  ),
                                                                                  FormHelper.textInput(
                                                                                    context,
                                                                                    model.pinCode = useraddlist[index].pinCode.toString(),
                                                                                    (value) => {
                                                                                      model.pinCode = value
                                                                                    },
                                                                                    onValidate: (value) {
                                                                                      if (model.pinCode?.isNotEmpty ?? false) {
                                                                                        model.pinCode = value;
                                                                                      }
                                                                                    },
                                                                                    hintText: "Pincode",
                                                                                    hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                                                                                    prefixIcon: Icon(
                                                                                      Icons.location_city,
                                                                                      color: Colors.black,
                                                                                      size: 30,
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: const EdgeInsets.all(0.0),
                                                                                    height: 40,
                                                                                    decoration: BoxDecoration(color: Color.fromRGBO(255, 95, 167, 1), borderRadius: BorderRadius.circular(16.0)),
                                                                                    //for radio button
                                                                                    width: MediaQuery.of(context).size.width * 0.48,
                                                                                    child: ElevatedButton(
                                                                                      child: Text(
                                                                                        "Save Address",
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      onPressed: () async {
                                                                                        this.addnewaddress.userId = model.id;
                                                                                        this.addnewaddress.id = useraddlist[index].id;
                                                                                        this.addnewaddress.address1 = model.address1;
                                                                                        this.addnewaddress.city = model.city;
                                                                                        this.addnewaddress.state = model.state;
                                                                                        this.addnewaddress.pinCode = int.tryParse(model.pinCode ?? '');
                                                                                        // this.localaddress[index].address1 = this.addnewaddress.address1;
                                                                                        SharedPref prefs = new SharedPref();
                                                                                        await prefs.save('useraddressdata', jsonEncode(this.addnewaddress));
                                                                                        apiService.addNewaddress(addnewaddress, model.token ?? '').then((ret) {
                                                                                          FormHelper.showMessage(context, "SUYOGA", "  Address Updated successfully", "OK", () {
                                                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyAddress()));
                                                                                          });
                                                                                        });
                                                                                                                                                                            },
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    });
                                                              },
                                                              child: new Text(
                                                                  'Edit',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            95,
                                                                            167,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                  )),
                                                            ),
                                                          if (selectedRadio ==
                                                              useraddlist[index]
                                                                  .id)
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              child: Container(
                                                                height: 30,
                                                                decoration: BoxDecoration(
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            255,
                                                                            95,
                                                                            167,
                                                                            1),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14.0)),
                                                                //for radio button
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.52,
                                                                        child:
                                                                            ElevatedButton(
                                                                                onPressed:
                                                                                    () async {
                                                                                            if (selectedRadio !=
                                                                    0) {
                                                                  final SharedPreferences
                                                                      prefs =
                                                                      await SharedPreferences.getInstance();
                                                                  String
                                                                      useradd =
                                                                      prefs.getString("useraddressdata") ?? '';
                                                                    List
                                                                        l =
                                                                        json.decode(useradd);
                                                                    for (var i in l) {
                                                                      UserAddressLocalModel data2 = new UserAddressLocalModel.fromJson(i);
                                                                      if (selectedRadio == data2.id) {
                                                                        // Populate setaddress with selected address data
                                                                        setaddress.shipping = Shipping(
                                                                          firstName: model.name ?? '',
                                                                          lastName: '',
                                                                          address1: data2.address1 ?? '',
                                                                          address2: data2.address2 ?? '',
                                                                          city: data2.city ?? '',
                                                                          state: data2.state ?? '',
                                                                          postcode: data2.pinCode?.toString() ?? '',
                                                                          phone: model.mobileNumber ?? '',
                                                                          // email: model.emailId ?? '',
                                                                        );
                                                                        print('DEBUG: Selected address - address1=${data2.address1}, city=${data2.city}, state=${data2.state}');
                                                                        
                                                                        // Pass address to cart provider
                                                                        var orderProvider = Provider.of<CartProvider>(context, listen: false);
                                                                        orderProvider.addresstProcess(setaddress);
                                                                      }
                                                                      localaddress.add(data2);
                                                                    }

                                                                    this.widget.totalamt =
                                                                        prefs.getDouble("totalAmount");

                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => Timeslots(shippingaddress: setaddress, totalamt: this.widget.totalamt ?? 0.0, usermoblie: model.mobileNumber ?? '', token: model.token ?? ''),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    FormHelper.showMessage(
                                                                        context,
                                                                        "SUYOGA",
                                                                        "Please  Select Delivery Address",
                                                                        "OK",
                                                                        () {
                                                                      Navigator.of(context).pop();
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Text(
                                                                  "Delivery to this address",
                                                                  style: TextStyle(
                                                                      color: const Color.fromARGB(255, 242, 22, 14),
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.normal),
                                                                )),
                                                              ),
                                                            ),
                                                        ]),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(height: 5),
                                    ]),
                                onTap: () {
                                  setState(() {
                                    selectedRadio = useraddlist[index].id ?? 0;
                                  });
                                  // FormHelper.showMessage(context, "SUYOGA",
                                  //     "Please Select Delivery Address", "OK", () {
                                  //   Navigator.of(context).pop();
                                  // });
                                });
                          })),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Color.fromRGBO(255, 95, 167, 1),
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).push(
                      //     MaterialPageRoute(builder: (context) => Addnewaddress()));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
                                //overflow: Overflow.visible,
                                children: <Widget>[
                                  Positioned(
                                    right: -20.0,
                                    top: -15.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.close,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Add New Address',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        FormHelper.textInput(
                                          context,
                                          addnewaddress.address1 ?? '',
                                          (value) => {
                                            this.addnewaddress.address1 = value
                                          },
                                          isTextArea: true,
                                          onValidate: (value) {
                                            if (value.toString().isEmpty) {
                                              return "Please Enter Your Address";
                                            }
                                            return null;
                                          },
                                          hintText: "Address",
                                          textAlign: TextAlign.start,
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                          prefixIcon: Icon(
                                            Icons.location_city,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        FormHelper.textInput(
                                          context,
                                          addnewaddress.city ?? '',
                                          (value) =>
                                              {this.addnewaddress.city = value},
                                          onValidate: (value) {
                                            if (value.toString().isEmpty) {
                                              return "Please Enter Your City";
                                            }
                                            return null;
                                          },
                                          hintText: "City",
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                          prefixIcon: Icon(
                                            Icons.location_city,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        FormHelper.textInput(
                                          context,
                                          addnewaddress.state ?? '',
                                          (value) => {
                                            this.addnewaddress.state = value
                                          },
                                          onValidate: (value) {
                                            if (value.toString().isEmpty) {
                                              return "Please Enter Your State";
                                            }
                                            return null;
                                          },
                                          hintText: "State",
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                          prefixIcon: Icon(
                                            Icons.location_city,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        FormHelper.textInput(
                                          context,
                                          (addnewaddress.pinCode ?? 0).toString(),
                                          (value) => {
                                            this.addnewaddress.pinCode =
                                                int.parse(value),
                                          },
                                          onValidate: (value) {
                                            if (value.toString().isEmpty) {
                                              return "Please Enter Your City";
                                            }
                                            return null;
                                          },
                                          hintText: "Pincode",
                                          hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                          prefixIcon: Icon(
                                            Icons.location_city,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(0.0),
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 95, 167, 1),
                                              borderRadius:
                                                  BorderRadius.circular(16.0)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.48,
                                          child: ElevatedButton(
                                            child: Text(
                                              "Save Address",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onPressed: () {
                                              if (this.addnewaddress.city !=
                                                      null) {
                                                this.addnewaddress.userId =
                                                    model.id;
                                                this.addnewaddress.id = 0;
                                                apiService
                                                  .addNewaddress(
  addnewaddress,  // Add ! if you're certain it's not null
  model.token!     // Add ! if you're certain it's not null
)
                                                    .then((ret) {
                                                  FormHelper.showMessage(
                                                      context,
                                                      "SUYOGA",
                                                      " New Address added successfully",
                                                      "OK", () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                VerifyAddress()));
                                                  });
                                                });
                                              } else {
                                                FormHelper.showMessage(
                                                    context,
                                                    "SUYOGA",
                                                    " Please Fill the Required Details",
                                                    "OK", () {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: new Text('ADD NEW ADDRESS',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 95, 167, 1),
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ]));
  }
  // Widget _listview(List<UserAddressModel> useraddlist, UserdatafromDB model) {
  //   CreateOrder setaddress = new CreateOrder();
  //   print(useraddlist.length);
  //   return Container(
  //       width: MediaQuery.of(context).size.height,
  //       //  width: MediaQuery.of(context).size.width * 0.9,
  //       height: MediaQuery.of(context).size.height,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Form(
  //               key: globalFormKey,
  //               child: Container(
  //                   padding: EdgeInsets.all(1),
  //                   //width: 600,
  //                   //height: 360,
  //                   color: Colors.grey[200],
  //                   height: MediaQuery.of(context).size.height * 0.7,
  //                   width: MediaQuery.of(context).size.width * 1.1,
  //                   child: Card(
  //                       child: ListView(children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 10),
  //                       child: Text(
  //                         'Select Delivery Address',
  //                         style: TextStyle(
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 20,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 5,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 150, right: 40),
  //                       child: FlatButton.icon(
  //                         onPressed: () {
  //                           showDialog(
  //                               context: context,
  //                               builder: (BuildContext context) {
  //                                 return AlertDialog(
  //                                   content: Stack(
  //                                     overflow: Overflow.visible,
  //                                     children: <Widget>[
  //                                       // Positioned(
  //                                       //   right: -15.0,
  //                                       //   top: -5.0,
  //                                       //   child: GestureDetector(
  //                                       //     onTap: () {
  //                                       //       Navigator.of(context).pop();
  //                                       //     },
  //                                       //     child: CircleAvatar(
  //                                       //       child: Icon(
  //                                       //         Icons.close,
  //                                       //         size: 25,
  //                                       //         color: Colors.black,
  //                                       //       ),
  //                                       //       backgroundColor: Colors.red,
  //                                       //     ),
  //                                       //   ),
  //                                       // ),
  //                                       Form(
  //                                         key: _formKey,
  //                                         child: Column(
  //                                           mainAxisSize: MainAxisSize.min,
  //                                           mainAxisAlignment:
  //                                               MainAxisAlignment.start,
  //                                           children: <Widget>[
  //                                             Center(
  //                                               child: Text(
  //                                                 'Add New Address',
  //                                                 style: TextStyle(
  //                                                     color: Colors.black,
  //                                                     fontSize: 22,
  //                                                     fontWeight:
  //                                                         FontWeight.bold),
  //                                               ),
  //                                             ),
  //                                             SizedBox(
  //                                               height: 10,
  //                                             ),
  //                                             FormHelper.textInput(
  //                                               context,
  //                                               addnewaddress.address1,
  //                                               (value) => {
  //                                                 this.addnewaddress.address1 =
  //                                                     value
  //                                               },
  //                                               isTextArea: true,
  //                                               onValidate: (value) {
  //                                                 if (value
  //                                                     .toString()
  //                                                     .isEmpty) {
  //                                                   return "Please Enter Your Address";
  //                                                 }
  //                                                 return null;
  //                                               },
  //                                               hintText: "Address",
  //                                               // textAlign: TextAlign.start,
  //                                               hintStyle: TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontSize: 20),
  //                                               prefixIcon: Icon(
  //                                                 Icons.location_city,
  //                                                 color: Colors.black,
  //                                                 size: 30,
  //                                               ),
  //                                             ),
  //                                             FormHelper.textInput(
  //                                               context,
  //                                               addnewaddress.city,
  //                                               (value) => {
  //                                                 this.addnewaddress.city =
  //                                                     value
  //                                               },
  //                                               onValidate: (value) {
  //                                                 if (value
  //                                                     .toString()
  //                                                     .isEmpty) {
  //                                                   return "Please Enter Your City";
  //                                                 }
  //                                                 return null;
  //                                               },
  //                                               hintText: "City",
  //                                               hintStyle: TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontSize: 20),
  //                                               prefixIcon: Icon(
  //                                                 Icons.location_city,
  //                                                 color: Colors.black,
  //                                                 size: 30,
  //                                               ),
  //                                             ),
  //                                             FormHelper.textInput(
  //                                               context,
  //                                               addnewaddress.state,
  //                                               (value) => {
  //                                                 this.addnewaddress.state =
  //                                                     value
  //                                               },
  //                                               onValidate: (value) {
  //                                                 if (value
  //                                                     .toString()
  //                                                     .isEmpty) {
  //                                                   return "Please Enter Your State";
  //                                                 }
  //                                                 return null;
  //                                               },
  //                                               hintText: "State",
  //                                               hintStyle: TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontSize: 20),
  //                                               prefixIcon: Icon(
  //                                                 Icons.location_city,
  //                                                 color: Colors.black,
  //                                                 size: 30,
  //                                               ),
  //                                             ),
  //                                             FormHelper.textInput(
  //                                               context,
  //                                               addnewaddress.pinCode,
  //                                               (value) => {
  //                                                 this.addnewaddress.pinCode =
  //                                                     int.parse(value),
  //                                               },
  //                                               onValidate: (value) {
  //                                                 if (value
  //                                                     .toString()
  //                                                     .isEmpty) {
  //                                                   return "Please Enter Your City";
  //                                                 }
  //                                                 return null;
  //                                               },
  //                                               hintText: "Pincode",
  //                                               hintStyle: TextStyle(
  //                                                   color: Colors.black,
  //                                                   fontSize: 20),
  //                                               prefixIcon: Icon(
  //                                                 Icons.location_city,
  //                                                 color: Colors.black,
  //                                                 size: 30,
  //                                               ),
  //                                             ),
  //                                             Padding(
  //                                               padding:
  //                                                   const EdgeInsets.all(8.0),
  //                                               child: FlatButton(
  //                                                 color: Colors.red[500],
  //                                                 child: Text(
  //                                                   "Save Address",
  //                                                   style: TextStyle(
  //                                                       color: Colors.white),
  //                                                 ),
  //                                                 onPressed: () {
  //                                                   if (this
  //                                                               .addnewaddress
  //                                                               .address1 !=
  //                                                           null &&
  //                                                       this
  //                                                               .addnewaddress
  //                                                               .city !=
  //                                                           null &&
  //                                                       this
  //                                                               .addnewaddress
  //                                                               .state !=
  //                                                           null &&
  //                                                       this
  //                                                               .addnewaddress
  //                                                               .pinCode !=
  //                                                           null) {
  //                                                     this
  //                                                         .addnewaddress
  //                                                         .userId = model.id;
  //                                                     this.addnewaddress.id = 0;
  //                                                     apiService
  //                                                         .addNewaddress(
  //                                                             addnewaddress,
  //                                                             model.token)
  //                                                         .then((ret) {
  //                                                       FormHelper.showMessage(
  //                                                           context,
  //                                                           "SUYOGA",
  //                                                           " New Address added successfully",
  //                                                           "OK", () {
  //                                                         Navigator.of(context).push(
  //                                                             MaterialPageRoute(
  //                                                                 builder:
  //                                                                     (context) =>
  //                                                                         VerifyAddress()));
  //                                                       });
  //                                                     });
  //                                                   } else {
  //                                                     FormHelper.showMessage(
  //                                                         context,
  //                                                         "SUYOGA",
  //                                                         " Please Fill the Required Details",
  //                                                         "OK", () {
  //                                                       Navigator.of(context)
  //                                                           .pop();
  //                                                     });
  //                                                   }
  //                                                 },
  //                                               ),
  //                                             )
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 );
  //                               });
  //                         },
  //                         color: Colors.redAccent,
  //                         focusColor: Colors.green,
  //                         icon: Icon(
  //                           Icons.add,
  //                           color: Colors.white,
  //                         ),
  //                         label: Text("Add New Address",
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                             )),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 15,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 0),
  //                       child: ListView.builder(
  //                           itemCount: useraddlist.length,
  //                           physics: ScrollPhysics(),
  //                           padding: EdgeInsets.all(1),
  //                           shrinkWrap: true,
  //                           itemBuilder: (context, index) {
  //                             return Row(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   Radio(
  //                                     value: useraddlist[index].id,
  //                                     groupValue: selectedRadio,
  //                                     activeColor: Colors.red,
  //                                     onChanged: (val) {
  //                                       print("Radio $val");
  //                                       setSelectedRadio(val);
  //                                     },
  //                                   ),
  //                                   SizedBox(
  //                                     width: 300,
  //                                     child: GestureDetector(
  //                                       onTap: () {},
  //                                       child: new Card(
  //                                         elevation: 1,
  //                                         color: Colors.green[200],
  //                                         shape: RoundedRectangleBorder(
  //                                             borderRadius:
  //                                                 new BorderRadius.circular(
  //                                                     10.0)),
  //                                         child: Column(
  //                                           children: <Widget>[
  //                                             Padding(
  //                                               padding:
  //                                                   const EdgeInsets.symmetric(
  //                                                       vertical: 10),
  //                                               child: Row(
  //                                                 mainAxisAlignment:
  //                                                     MainAxisAlignment.start,
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                                   Padding(
  //                                                     padding:
  //                                                         const EdgeInsets.all(
  //                                                             8.0),
  //                                                     child: Column(
  //                                                       mainAxisAlignment:
  //                                                           MainAxisAlignment
  //                                                               .start,
  //                                                       crossAxisAlignment:
  //                                                           CrossAxisAlignment
  //                                                               .start,
  //                                                       children: [
  //                                                         Text(
  //                                                           model.firstName,
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             fontSize: 14,
  //                                                           ),
  //                                                         ),
  //                                                         Text(
  //                                                           model.mobileNumber,
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             fontSize: 14,
  //                                                           ),
  //                                                         ),
  //                                                         Container(
  //                                                           width: 270,
  //                                                           child: new Column(
  //                                                             mainAxisAlignment:
  //                                                                 MainAxisAlignment
  //                                                                     .start,
  //                                                             crossAxisAlignment:
  //                                                                 CrossAxisAlignment
  //                                                                     .start,
  //                                                             children: <
  //                                                                 Widget>[
  //                                                               new Text(
  //                                                                 useraddlist[
  //                                                                         index]
  //                                                                     .address1,
  //                                                                 style:
  //                                                                     TextStyle(
  //                                                                   color: Colors
  //                                                                       .black,
  //                                                                   fontWeight:
  //                                                                       FontWeight
  //                                                                           .bold,
  //                                                                   fontSize:
  //                                                                       14,
  //                                                                 ),
  //                                                                 textAlign:
  //                                                                     TextAlign
  //                                                                         .left,
  //                                                               ),
  //                                                             ],
  //                                                           ),
  //                                                         ),
  //                                                         Text(
  //                                                           useraddlist[index]
  //                                                               .city,
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             fontSize: 14,
  //                                                           ),
  //                                                         ),
  //                                                         Text(
  //                                                           useraddlist[index]
  //                                                               .state,
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             fontSize: 14,
  //                                                           ),
  //                                                         ),
  //                                                         Text(
  //                                                           useraddlist[index]
  //                                                               .pinCode
  //                                                               .toString(),
  //                                                           style: TextStyle(
  //                                                             color:
  //                                                                 Colors.black,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .bold,
  //                                                             fontSize: 14,
  //                                                           ),
  //                                                         ),
  //                                                         Padding(
  //                                                           padding:
  //                                                               EdgeInsets.only(
  //                                                                   left: 180),
  //                                                           child: FlatButton(
  //                                                               color:
  //                                                                   Colors.red,
  //                                                               onPressed: () {
  //                                                                 showDialog(
  //                                                                     context:
  //                                                                         context,
  //                                                                     builder:
  //                                                                         (BuildContext
  //                                                                             context) {
  //                                                                       return AlertDialog(
  //                                                                         content:
  //                                                                             Stack(
  //                                                                           overflow:
  //                                                                               Overflow.visible,
  //                                                                           children: <Widget>[
  //                                                                             // Positioned(
  //                                                                             //   right: -22.0,
  //                                                                             //   top: -15.0,
  //                                                                             //   child: InkResponse(
  //                                                                             //     onTap: () {
  //                                                                             //       Navigator.of(context).pop();
  //                                                                             //     },
  //                                                                             //     child: CircleAvatar(
  //                                                                             //       child: Icon(
  //                                                                             //         Icons.close,
  //                                                                             //         size: 25,
  //                                                                             //         color: Colors.black,
  //                                                                             //       ),
  //                                                                             //       backgroundColor: Colors.transparent,
  //                                                                             //     ),
  //                                                                             //   ),
  //                                                                             // ),
  //                                                                             Form(
  //                                                                               key: _formKey,
  //                                                                               child: Column(
  //                                                                                 mainAxisSize: MainAxisSize.min,
  //                                                                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                                                                 children: <Widget>[
  //                                                                                   Center(
  //                                                                                     child: Text(
  //                                                                                       'Edit Existing Address',
  //                                                                                       style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
  //                                                                                     ),
  //                                                                                   ),
  //                                                                                   SizedBox(
  //                                                                                     height: 20,
  //                                                                                   ),
  //                                                                                   FormHelper.textInput(
  //                                                                                     context,
  //                                                                                     model.address1 = useraddlist[index].address1,
  //                                                                                     (value) => {
  //                                                                                       model.address1 = value,
  //                                                                                     },
  //                                                                                     onValidate: (value) {
  //                                                                                       if (model.address1.isNotEmpty) {
  //                                                                                         model.address1 = value;
  //                                                                                       }
  //                                                                                     },
  //                                                                                     isTextArea: true,
  //                                                                                     hintText: "Address",
  //                                                                                     hintStyle: TextStyle(color: Colors.black, fontSize: 20),
  //                                                                                     prefixIcon: Icon(
  //                                                                                       Icons.location_city,
  //                                                                                       color: Colors.black,
  //                                                                                       size: 30,
  //                                                                                     ),
  //                                                                                   ),
  //                                                                                   FormHelper.textInput(
  //                                                                                     context,
  //                                                                                     model.city = useraddlist[index].city,
  //                                                                                     (value) => {
  //                                                                                       model.city = value
  //                                                                                     },
  //                                                                                     onValidate: (value) {
  //                                                                                       if (model.address1.isNotEmpty) {
  //                                                                                         model.city = value;
  //                                                                                       }
  //                                                                                     },
  //                                                                                     hintText: "City",
  //                                                                                     hintStyle: TextStyle(color: Colors.black, fontSize: 20),
  //                                                                                     prefixIcon: Icon(
  //                                                                                       Icons.location_city,
  //                                                                                       color: Colors.black,
  //                                                                                       size: 30,
  //                                                                                     ),
  //                                                                                   ),
  //                                                                                   FormHelper.textInput(
  //                                                                                     context,
  //                                                                                     model.state = useraddlist[index].state,
  //                                                                                     (value) => {
  //                                                                                       model.state = value,
  //                                                                                     },
  //                                                                                     onValidate: (value) {
  //                                                                                       if (model.state.isNotEmpty) {
  //                                                                                         model.state = value;
  //                                                                                       }
  //                                                                                     },
  //                                                                                     hintText: "State",
  //                                                                                     hintStyle: TextStyle(color: Colors.black, fontSize: 20),
  //                                                                                     prefixIcon: Icon(
  //                                                                                       Icons.location_city,
  //                                                                                       color: Colors.black,
  //                                                                                       size: 30,
  //                                                                                     ),
  //                                                                                   ),
  //                                                                                   FormHelper.textInput(
  //                                                                                     context,
  //                                                                                     model.pinCode = useraddlist[index].pinCode.toString(),
  //                                                                                     (value) => {
  //                                                                                       model.pinCode = value
  //                                                                                     },
  //                                                                                     onValidate: (value) {
  //                                                                                       if (model.pinCode.isNotEmpty) {
  //                                                                                         model.pinCode = value;
  //                                                                                       }
  //                                                                                     },
  //                                                                                     hintText: "Pincode",
  //                                                                                     hintStyle: TextStyle(color: Colors.black, fontSize: 20),
  //                                                                                     prefixIcon: Icon(
  //                                                                                       Icons.location_city,
  //                                                                                       color: Colors.black,
  //                                                                                       size: 30,
  //                                                                                     ),
  //                                                                                   ),
  //                                                                                   Padding(
  //                                                                                     padding: const EdgeInsets.all(8.0),
  //                                                                                     child: FlatButton(
  //                                                                                       color: Colors.red[500],
  //                                                                                       child: Text(
  //                                                                                         "Save Address",
  //                                                                                         style: TextStyle(color: Colors.white),
  //                                                                                       ),
  //                                                                                       onPressed: () async {
  //                                                                                         this.addnewaddress.userId = model.id;
  //                                                                                         this.addnewaddress.id = useraddlist[index].id;
  //                                                                                         this.addnewaddress.address1 = model.address1;
  //                                                                                         this.addnewaddress.city = model.city;
  //                                                                                         this.addnewaddress.state = model.state;
  //                                                                                         this.addnewaddress.pinCode = int.tryParse(model.pinCode);
  //                                                                                         // this.localaddress[index].address1 = this.addnewaddress.address1;
  //                                                                                         SharedPref prefs = new SharedPref();
  //                                                                                         await prefs.save('useraddressdata', jsonEncode(this.addnewaddress));
  //                                                                                         print(this.addnewaddress);
  //                                                                                         if (this.addnewaddress != null) {
  //                                                                                           apiService.addNewaddress(addnewaddress, model.token).then((ret) {
  //                                                                                             FormHelper.showMessage(context, "SUYOGA", "  Address Updated successfully", "OK", () {
  //                                                                                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => VerifyAddress()));
  //                                                                                             });
  //                                                                                           });
  //                                                                                         } else {
  //                                                                                           Text("data");
  //                                                                                         }
  //                                                                                       },
  //                                                                                     ),
  //                                                                                   )
  //                                                                                 ],
  //                                                                               ),
  //                                                                             ),
  //                                                                           ],
  //                                                                         ),
  //                                                                       );
  //                                                                     });
  //                                                               },
  //                                                               child: Text(
  //                                                                 'Edit',
  //                                                                 style: TextStyle(
  //                                                                     color: Colors
  //                                                                         .white),
  //                                                               )),
  //                                                         )
  //                                                       ],
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ]);
  //                           }),
  //                     )
  //                   ])))),
  //           Container(
  //             color: Colors.white,
  //             width: MediaQuery.of(context).size.width,
  //             height: 100,
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //               child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     FlatButton(
  //                       child: Row(
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             'Next',
  //                             style:
  //                                 TextStyle(fontSize: 20, color: Colors.white),
  //                           ),
  //                           Icon(Icons.chevron_right,
  //                               size: 30, color: Colors.white),
  //                         ],
  //                       ),
  //                       onPressed: () async {
  //                         if (selectedRadio != 0) {
  //                           final SharedPreferences prefs =
  //                               await SharedPreferences.getInstance();
  //                           String useradd = prefs.getString("useraddressdata");
  //                           List l = json.decode(useradd);
  //                           l.forEach((i) {
  //                             UserAddressLocalModel data2 =
  //                                 new UserAddressLocalModel.fromJson(i);
  //                             if (selectedRadio == data2.id) {
  //                               var orderProvider = Provider.of<CartProvider>(
  //                                   context,
  //                                   listen: false);

  //                               if (setaddress.shipping == null) {
  //                                 setaddress.shipping = new Shipping();
  //                                 setaddress.shipping.mobile =
  //                                     model.mobileNumber;
  //                                 setaddress.shipping.mobile = model.firstName;
  //                                 setaddress.shipping.mobile = model.lastName;
  //                                 setaddress.shipping.mobile = model.emailId;
  //                                 setaddress.shipping.address1 = data2.address1;
  //                                 setaddress.shipping.city = data2.city;
  //                                 setaddress.shipping.state = data2.state;
  //                                 pincode = setaddress.shipping.postalCode =
  //                                     data2.pinCode.toString();

  //                                 orderProvider.addresstProcess(setaddress);
  //                                 print(setaddress.shipping.address1);
  //                               }
  //                             }
  //                             localaddress.add(data2);
  //                             return i;
  //                           });

  //                           this.widget.totalamt =
  //                               prefs.getDouble("totalAmount");
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => Timeslots(
  //                                   shippingaddress: setaddress,
  //                                   totalamt: this.widget.totalamt,
  //                                   usermoblie: model.mobileNumber,
  //                                   token: model.token),
  //                             ),
  //                           );
  //                         } else {
  //                           FormHelper.showMessage(context, "SUYOGA",
  //                               "Please  Select Delivery Address", "OK", () {
  //                             Navigator.of(context).pop();
  //                           });
  //                         }
  //                       },
  //                       padding:
  //                           EdgeInsets.symmetric(horizontal: 40, vertical: 13),
  //                       color: Colors.green,
  //                       shape: StadiumBorder(),
  //                     ),
  //                   ]),
  //             ),
  //           ),
  //         ],
  //       ));
  // }
}
