//import 'package:Samarpana/QR/ScanQR.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/components/cart_provider.dart';
import 'package:Samarpana/model/LoginRespose.dart';
import 'package:Samarpana/model/Vendor_AccountModel.dart';
import 'package:Samarpana/pages/AccountPage.dart';
import 'package:Samarpana/utils/VerifyPage_FormHelper.dart';
import 'package:Samarpana/utils/dataBase.dart';
import 'package:Samarpana/utils/message_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountTransfer extends StatefulWidget {
  const AccountTransfer({Key? key}) : super(key: key);

  @override
  _AccountTransferState createState() => _AccountTransferState();
}

class _AccountTransferState extends State<AccountTransfer> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  late VendorAccountdetails vendorAccountdetails;
  late BankAccount bankAccount;
  List<UserdatafromDB> list = <UserdatafromDB>[];
  late UserdatafromDB model;
  late SharedPreferences sharedPrefs;
  late String confirmpassword;
  late BankContactadded bankContactadded;
  bool isvalidaccount = false;

  @override
  void initState() {
    fetch();
    super.initState();
    apiService = new APIService();
    vendorAccountdetails = new VendorAccountdetails();
    bankAccount = new BankAccount(name: '', account_number: '', ifsc: '');
    bankContactadded = new BankContactadded(
      rzpbankid: '',
      mobileNumber: '',
      message: '',
      statusCode: 0,
    );
    var caritemList = Provider.of<CartProvider>(context, listen: false);
    caritemList.getVendorBankDetails();
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
    bool isdiable = true;
    return new Consumer<CartProvider>(builder: (context, vendor, child) {
      return new Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                automaticallyImplyLeading: false,
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
              body: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Account Details Already added",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Contact_Id  :",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Text(vendor.vendorBankDetails.rzpContactId ?? '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Account_Id :",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Text(vendor.vendorBankDetails.accountNumber ?? '',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        PopMessage.showMessage(
                            context,
                            'Suyoga',
                            'This option will be commingsoon',
                            '',
                            () {
                              
                            },
                            buttonText2: 'OK',
                            
                            isconformationDialog: true,
                            onPressed2: () {
                               Navigator.of(context,rootNavigator: true).pop();
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(123, 212, 165, 1),
                      ),
                      child: Text("Update Bank details",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    )
                  ],
                )),
              )));
    });

    // return new Consumer<CartProvider>(builder: (context, vendor, child) {
    //   if (vendor.vendorBankDetailsdata != null) {
    //     isvalidaccount = true;
    //   }
    //   return Scaffold(
    //       resizeToAvoidBottomInset: false,
    //       body: ProgressHUD(
    //           child: new Form(
    //             key: _formkey,
    //             child: formui(isvalidaccount),
    //           ),
    //           inAsyncCall: isApicallProcess,
    //           opacity: 0.3));
    // });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return new Consumer<CartProvider>(builder: (context, vendor, child) {
  //     if (vendor.vendorBankDetailsdata != null &&
  //         vendor.vendorBankDetailsdata.statusCode == 200) {
  //       return  Center(child: Text("sgsefd"));
  //     } else {
  //     Scaffold(
  //           resizeToAvoidBottomInset: false,
  //           body: ProgressHUD(
  //               child: new Form(
  //                 key: _formkey,
  //                 child: formui(),
  //               ),
  //               inAsyncCall: isApicallProcess,
  //               opacity: 0.3));
  //     }
  //     return ;
  //   });
  // }

  Widget formui(bool isvalid) {
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
                  SizedBox(height: 20),
                  Text(
                    "Please Fill the Bank Details",
                    style: TextStyle(
                        fontSize: 20, color: Color.fromRGBO(255, 95, 167, 1)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FormHelper.textInput(
                    context,
                    bankAccount.name,
                    (value) => {this.bankAccount.name = value},
                    onValidate: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter Account Holder Name";
                      }
                      return null;
                    },
                    hintText: "Account Holder Name",
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 20),
                    // prefixIcon: Icon(
                    //   Icons.account_balance,
                    //   color: Colors.black,
                    //   size: 30,
                    // ),
                  ),
                  FormHelper.textInput(
                    context,
                    bankAccount.account_number,
                    (value) => {this.bankAccount.account_number = value},
                    onValidate: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter Account Number";
                      }
                      return null;
                    },
                    hintText: "Account Number",
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 20),
                    // prefixIcon: Icon(
                    //   Icons.account_balance,
                    //   color: Colors.black,
                    //   size: 30,
                    // ),
                  ),

                  FormHelper.textInput(
                    context,
                    bankAccount.account_number,
                    (value) => {confirmpassword = value},
                    onValidate: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter Confirm Account Number";
                      }
                      return null;
                    },
                    hintText: "Confirm Account Number",
                    obscureText: true,
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 20),
                    // prefixIcon: Icon(
                    //   Icons.account_balance,
                    //   color: Colors.black,
                    //   size: 30,
                    // ),
                  ),
                  FormHelper.textInput(
                    context,
                    bankAccount.ifsc,
                    (value) => {this.bankAccount.ifsc = value},
                    onValidate: (value) {
                      if (value.toString().isEmpty) {
                        return "Please Enter IFSC Code";
                      } else if (this.bankAccount.ifsc.length < 11) {
                        return "Please Enter valid IFSC Code";
                      }
                      return null;
                    },
                    hintText: "IFSC Code",
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 20),
                    // prefixIcon: Icon(
                    //   Icons.account_balance,
                    //   color: Colors.black,
                    //   size: 30,
                    // ),
                  ),
                  // FormHelper.textInput(
                  //   context,
                  //   vendorAccountdetails.bankName,
                  //   (value) =>
                  //       {this.vendorAccountdetails.bankName = value},
                  //   onValidate: (value) {
                  //     if (value.toString().isEmpty) {
                  //       return "Please Enter Account Holder Name";
                  //     }
                  //     return null;
                  //   },
                  //   hintText: "Account Holder Name",
                  //   hintStyle:
                  //       TextStyle(color: Colors.grey[500], fontSize: 20),
                  //   // prefixIcon: Icon(
                  //   //   Icons.account_balance,
                  //   //   color: Colors.black,
                  //   //   size: 30,
                  //   // ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  new Center(
                      child: FormHelper.saveButton("Submit", () async {
                    if (confirmpassword == bankAccount.account_number) {
                      Provider.of<CartProvider>(context, listen: false);
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      FundAccount account = new FundAccount(
                        accountType: "bank_account",
                        contactId: prefs.getString("cont_refId") ?? '',
                        bankAccount: bankAccount,
                      );
                      print(prefs.getString("cont_refId"));
                      if (validateandSave()) {
                        apiService.addfundAccount(account).then((value) {
                            bankContactadded = BankContactadded(
                              rzpbankid: value?.id ?? '',
                              mobileNumber: model.mobileNumber ?? '',
                              message: '',
                              statusCode: 0,
                            );
                            apiService
                                .addbankcontact(bankContactadded, model.token ?? '')
                              .then((data) => {
                                    if (data != null &&
                                        data.statusCode == 201)
                                      {
                                        FormHelper.showMessage(
                                            context,
                                            "SAMARPANA",
                                            "Your Bank details added Successfully",
                                            "OK", () {
                                          var caritemList =
                                              Provider.of<CartProvider>(
                                                  context,
                                                  listen: false);
                                          caritemList.getVendorBankDetails();
                                          // Navigator.of(context).pop();
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      WalletUIscreen()));
                                        })
                                      }
                                    else
                                      {
                                        FormHelper.showMessage(
                                            context,
                                            "SAMARPANA",
                                            "Please check your Bank details",
                                            "OK", () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        })
                                      }
                                  });
                                                });
                      }
                    } else {
                      FormHelper.showMessage(context, "SAMARPANA",
                          "Please check Confirm Account Number ", "OK", () {
                        Navigator.of(context, rootNavigator: true).pop();
                      });
                    }
                  })),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

TabController? _tabController;
String password = "";
late APIService apiService;
late VendorAccountdetails vendorAccountdetails;
bool hidePassword = true;
@override
void initState() {
  apiService = new APIService();
  vendorAccountdetails = new VendorAccountdetails();
}

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
                    validator: (input) => (input?.length ?? 0) < 5
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
                    validator: (input) => (input?.length ?? 0) < 8
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
                    onSaved: (input) => password = input ?? '',
                    validator: (input) => (input?.length ?? 0) < 8
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
                    validator: (input) => (input?.length ?? 0) < 8
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
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
