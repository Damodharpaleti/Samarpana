
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/Vendor_AccountModel.dart';
import 'package:Samarpana/model/WithdrawModel.dart';
import 'package:Samarpana/pages/AccountPage.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/utils/form_helper.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountwithdrawTransfer extends StatefulWidget {
  const AccountwithdrawTransfer({Key? key}) : super(key: key);

  @override
  _AccountwithdrawTransferState createState() =>
      _AccountwithdrawTransferState();
}

class _AccountwithdrawTransferState extends State<AccountwithdrawTransfer> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  late VendorAccountdetails vendorAccountdetails;
  late BankAccount bankAccount;
  List<UserdatafromDB> list = [];
  late UserdatafromDB model;
  late SharedPreferences sharedPrefs;
String confirmpassword = "";   // ✅ initialize
  late BankContactadded bankContactadded;
  int value = 0;                 // ✅ initialize
  TextEditingController _controler = new TextEditingController();
  double amt = 0.0;              // ✅ initialize
  double walbalance = 0;
  late WithdrawRequest withdrawRequest;

@override
void initState() {
  super.initState();   // ALWAYS FIRST

  apiService = APIService();
  vendorAccountdetails = VendorAccountdetails();
  bankAccount = BankAccount(
    name: '',
    account_number: '',
    ifsc: '',
  );
  bankContactadded = BankContactadded(
    rzpbankid: '',
    mobileNumber: '',
    message: '',
    statusCode: 0,
  );
  withdrawRequest = WithdrawRequest(
    userId: '',
    contRefId: '',
    bankRefId: '',
    rzpTransacid: '',
    status: '',
    amount: 0.0,
    statusCode: 0,
    message: '',
  );

  fetch();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.getVendorBankDetails();
  });
}


  @override
  void dispose() {
    super.dispose();
  }

  fetch() async {
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

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Consumer<CartProvider>(builder: (context, vendor, child) {
      if (vendor.vendorBankDetailsdata.statusCode == 200) {
        Center(
          child: Text("data coming"),
        );
      }
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: ProgressHUD(
              child: new Form(
                key: _formkey,
                child: formui(vendor.vendorBankDetailsdata),
              ),
              inAsyncCall: isApicallProcess,
              opacity: 0.3));
    });
  }

  Widget formui(VendorAccountdetails vendordata) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color.fromRGBO(123, 212, 165, 1),
          automaticallyImplyLeading: false,
          // bottom: TabBar(
          //   isScrollable: false,
          //   unselectedLabelColor: Colors.red,
          //   indicatorWeight: 1,
          //   indicator: UnderlineTabIndicator(
          //       borderSide: BorderSide(width: 2.0),
          //       insets: EdgeInsets.symmetric(horizontal: 16.0)),
          //   labelColor: Colors.red,
          //   tabs: [
          //     Container(
          //         height: 40,
          //         width: MediaQuery.of(context).size.width * 0.5,
          //         child: Center(
          //           child: Text(
          //             "Add Bank Details",
          //             style: TextStyle(fontSize: 20, color: Colors.red),
          //           ),
          //         )),
          //     FlatButton(
          //         onPressed: () {
          //           // Navigator.of(context).push(MaterialPageRoute(
          //           //   builder: (context) => QRViewExample(),
          //           // ));
          //         },
          //         height: 40,
          //         // width: MediaQuery.of(context).size.width * 0.5,
          //         child: Center(
          //           child: Text(
          //             "Add UPI",
          //             style: TextStyle(fontSize: 20, color: Colors.red),
          //           ),
          //         )),
          //   ],
          //   indicatorColor: Colors.white,
          // ),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletUIscreen(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text(
            'SUYOGA',
            style: TextStyle(color: Colors.black),
          ), systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text(
                      "Please select the Account",
                      style: TextStyle(
                          fontSize: 20, color: Color.fromRGBO(255, 95, 167, 1)),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(children: [
                        SizedBox(height: 20),
                        Radio(
                          value: 1,
                          groupValue: value,
                          activeColor: Color.fromRGBO(255, 95, 167, 1),
                          onChanged: (val) {
                            print("Radio $val");
                            setState(() {
                              value = 1;
                            });
                            // setSelectedRadio(val);
                          },
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.82,
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Color.fromRGBO(123, 212, 165, 1),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.account_balance,
                                      color: Color.fromRGBO(255, 95, 167, 1),
                                      size: 45),
                                  title: RichText(
                                      text: TextSpan(
                                          text: "Account ID : ",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 95, 167, 1),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: vendordata.accountNumber,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ])),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Available Wallet Amount : ",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 95, 167, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                          TextSpan(
                              text: '${vendordata.walletamt}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ])),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Add Amount to withdraw from wallet",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            this.amt = 500;
                            _controler.value = TextEditingValue(text: "500");
                            print(this.amt);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[100]),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 40,
                              width: 80,
                              //color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                "\u20B9" + " " + "500",
                                style: TextStyle(
                                    // color: Colors.green[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ),
                        TextButton(
                          onPressed: () {
                            this.amt = 700;
                            _controler.value = TextEditingValue(text: "700");
                            print(this.amt);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[100]),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 40,
                              width: 80,
                              //color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                "\u20B9" + " " + "700",
                                style: TextStyle(
                                    // color: Colors.green[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ),
                        TextButton(
                          onPressed: () {
                            this.amt = 1000;
                            _controler.value = TextEditingValue(text: "1000");
                            print(this.amt);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[100]),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 40,
                              width: 80,
                              //color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                "\u20B9" + " " + "1000",
                                style: TextStyle(
                                    // color: Colors.green[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            this.amt = 1500;
                            _controler.value = TextEditingValue(text: "1500");
                            print(this.amt);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[100]),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 40,
                              width: 80,
                              //color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                "\u20B9" + " " + "1500",
                                style: TextStyle(
                                    // color: Colors.green[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ),
                        TextButton(
                          onPressed: () {
                            this.amt = 2000;
                            _controler.value = TextEditingValue(text: "2000");
                            print(this.amt);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[100]),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 40,
                              width: 80,
                              //color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                "\u20B9" + " " + "2000",
                                style: TextStyle(
                                    // color: Colors.green[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ),
                        TextButton(
                          onPressed: () {
                            this.amt = 2500;
                            _controler.value = TextEditingValue(text: "2500");
                            print(this.amt);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  color: Colors.green[100]),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              height: 40,
                              width: 80,
                              //color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                "\u20B9" + " " + "2500",
                                style: TextStyle(
                                    // color: Colors.green[900],
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ))),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _controler,
                      cursorColor: Colors.black,
                      maxLines: 1,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.green[900],
                            size: 40,
                          ),
                          hintStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          hintText: 'Add Money To Withdraw'),
                      onSaved: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          this.amt = double.parse(value);
                        }
                      },
                      onChanged: (val) => this.amt = double.parse(val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    new Center(
                      child: FormHelper.saveButton("Submit", () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        withdrawRequest.bankRefId = vendordata.accountNumber ?? '';

                        withdrawRequest.contRefId =
                            prefs.getString("cont_refId") ?? '';

                        withdrawRequest.amount = this.amt;
                        if (withdrawRequest.amount != 0) {
                          withdrawRequest.status = "pending";
                          withdrawRequest.userId = vendordata.mobileNumber ?? '';
                          // orderProvider.getaccountProcess(account);
                          // if (validateandSave()) {
                          if (withdrawRequest.amount < (vendordata.walletamt ?? 0)) {
                            apiService
                                .withdrawmoney(withdrawRequest, model.token ?? '')
                                .then((value) {
                              if (value != null && value.statusCode == 201) {
                                if (value.statusCode == 201) {
                                  prefs.setDouble("Walletamt",
                                      (vendordata.walletamt ?? 0) - this.amt);
                                }
                                FormHelper.showMessage(
                                    context, "SAMARPANA", value.message ?? "", "OK",
                                    () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              WalletUIscreen()));
                                });
                              } else {
                                FormHelper.showMessage(
                                    context, "SAMARPANA", value?.message ?? "", "OK",
                                    () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                });
                              }
                            });
                          } else {
                            FormHelper.showMessage(context, "SAMARPANA",
                                "Please Check Wallet amount ", "OK", () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop();
                            });
                          }
                        } else {
                          FormHelper.showMessage(context, "SAMARPANA",
                              "Please Add Withdraw amount ", "OK", () {
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        }
                        //  orderProvider.fundcreate();
                                            }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  bool validateandSave() {
    final form = _formkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

String? password = "";
VendorAccountdetails vendorAccountdetails = VendorAccountdetails();
bool hidePassword = true;

@override
Widget build(BuildContext context) {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.green,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              isScrollable: false,
              unselectedLabelColor: Colors.red,
              indicatorWeight: 2,
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0),
                  insets: EdgeInsets.symmetric(horizontal: 16.0)),
              labelColor: Colors.red,
              tabs: [
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: Text(
                        "Add Bank Details",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => QRViewExample(),
                      // ));
                    },
                    child: Center(
                      child: Text(
                        "Add UPI",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    )),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.account_balance),
                //   iconSize: 40.0,
                // ),
                // new FloatingActionButton(
                //   onPressed: () => _tabController.animateTo(
                //       (_tabController.index + 1) % 2), // Switch tabs
                //   child: new Icon(Icons.swap_horiz),
                // ),

                // //Icon(Icons.qr_code_scanner),
              ],
              indicatorColor: Colors.white,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Text(
              'SUYOGA',
              style: TextStyle(color: Colors.white),
            ), systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Fill the Bank Details",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 10.0),
                //   child: Container(
                //     height: 60,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.grey[500].withOpacity(0.3),
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     child: TextFormField(
                //       onSaved: (input) => password = input,
                //       validator: (input) => input.length < 3
                //           ? "Password should be more than 3 characters"
                //           : null,
                //       obscureText: hidePassword,
                //       decoration: InputDecoration(
                //           errorStyle: TextStyle(color: Colors.white),
                //           prefixIcon: Padding(
                //             padding: EdgeInsets.symmetric(horizontal: 20),
                //             child: Icon(
                //               Icons.lock,
                //               size: 26,
                //               color: Colors.white,
                //             ),
                //           ),
                //           border: InputBorder.none,
                //           hintText: "Password",
                //           hintStyle: TextStyle(
                //             color: Colors.white,
                //             fontSize: 19,
                //           )),
                //       style: TextStyle(color: Colors.white),
                //       keyboardType: TextInputType.name,
                //       textInputAction: TextInputAction.done,
                //       cursorColor: Colors.white,
                //     ),
                //   ),
                // ),
                FormHelper.textInput(
                  context,
                  vendorAccountdetails.accountNumber ?? '',
                  (value) => {vendorAccountdetails.accountNumber = value},
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return "Please Enter First Name";
                    }
                    return null;
                  },
                  hintText: "First Name",
                  hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                    size: 30,
                  ),
                  //style: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (input) => vendorAccountdetails.walletamt,
                    validator: (input) => input == null || input.length < 5
                        ? "Password should be more than 5 characters"
                        : null,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Bank Name',
                        hintStyle: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (input) =>
                        vendorAccountdetails.accountNumber = input,
                    validator: (input) => input == null || input.length < 8
                        ? "Password should be more than 8 characters"
                        : null,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Account Number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (input) => password = input ?? "",
                    validator: (input) => input == null || input.length < 8
                        ? "Password should be more than 8 characters"
                        : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Account Number',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (input) => vendorAccountdetails.accountNumber,
                    validator: (input) => input == null || input.length < 8
                        ? "Password should be more than 8 characters"
                        : null,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'IFSC CODE',
                    ),
                  ),
                ),

                SizedBox(
                  height: 100,
                ),
                new Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red[500]),
                    ),
                    child: Text(
                      "Save Address",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      print(vendorAccountdetails);
                      // if (this.vendorAccountdetails != null) {
                      //   apiService
                      //       .addNewaddress(this.vendorAccountdetails, model.token)
                      //       .then((ret) {
                      //     FormHelper.showMessage(context, "SUYOGA",
                      //         "  Address Updated successfully", "OK", () {
                      //       Navigator.of(context).push(MaterialPageRoute(
                      //           builder: (context) => VerifyAddress()));
                      //     });
                      //   });
                      // } else {
                      //   Text("data");
                      // }
                    },
                  ),
                )),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 10.0),
                //   child: Container(
                //       height: 60,
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //         color: Colors.transparent,
                //         borderRadius: BorderRadius.circular(16),
                //       ),
                //       child: Text("data")),
                // ),
              ],
            ),
          )));
}
