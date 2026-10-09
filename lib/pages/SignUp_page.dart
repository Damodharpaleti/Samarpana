import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/User_Signup_Model.dart';
import 'package:Samarpana/pages/SignUp_otp.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/utils/background-image.dart';
import 'package:Samarpana/utils/dataBase.dart';

import '../utils/form_helper.dart';

class SignUP extends StatefulWidget {
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final dbHelper = DBProvider.instance;
  late APIService apiService;
  bool isApicallProcess = false;
  bool hidePassword = true;
  late User usersignup;

  late SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    usersignup = new User();
    usersignup.firstName = '';
    usersignup.lastName = '';
    usersignup.mobileNumber = '';
    usersignup.emailId = '';
    usersignup.location = '';
    usersignup.city = '';
    usersignup.password = '';
  }

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ProgressHUD(
            child: new Form(
              key: _formkey,
              child: formui(),
            ),
            inAsyncCall: isApicallProcess,
            opacity: 0.3));
  }

  Widget formui() {
    return Stack(children: [
      BackgroundImage(
        image: 'assets/images/grocery.jpg',
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        child: Image.asset('assets/images/logo.png',
                            width: 100, height: 100, fit: BoxFit.fill),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.firstName ?? '',
                        (value) => {this.usersignup.firstName = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter First Name";
                          }
                          return null;
                        },
                        hintText: "First Name",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                        //style: TextStyle(color: Colors.white),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.lastName ?? '',
                        (value) => {this.usersignup.lastName = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Last Name";
                          }
                          return null;
                        },
                        hintText: "Last Name",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.mobileNumber ?? '',
                        (value) => {this.usersignup.mobileNumber = value},
                        onValidate: (value) => value.length < 10
                            ? "Please Enter Valid Mobile Number"
                            : null,
                        hintText: "Phone No",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.emailId ?? '',
                        (value) => {this.usersignup.emailId = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Email Id";
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return 'Please Enter a valid Email';
                          }
                          return null;
                        },
                        hintText: "Mail Id",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.location ?? '',
                        (value) => {this.usersignup.location = value},
                        onValidate: (value) {
                          if (value.toString().isEmpty) {
                            return "Please Enter Your City";
                          }
                          return null;
                        },
                        hintText: "City",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.location_city,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(
                        context,
                        usersignup.city ?? '',
                        (value) => {this.usersignup.pinCode = value},
                        onValidate: (value) =>
                            value.length < 6 ? "Please Enter PinCode" : null,
                        hintText: "PinCode",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.local_post_office,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      FormHelper.textInput(context, usersignup.password ?? '',
                          (value) => {this.usersignup.password = value},
                          onValidate: (value) => value.length < 4
                              ? "Password should be more than 4 characters"
                              : null,
                          hintText: "Password",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 20),
                          obscureText: hidePassword,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 30,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color: Colors.white,
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      new Center(
                        child: FormHelper.saveButton("Submit", () {
                          if (validateandSave()) {
                            print(usersignup.toJson());
                            setState(() {
                              isApicallProcess = true;
                            });
                            apiService
                                .loginWithOTP(usersignup.mobileNumber ?? '')
                                .then((ret) {
                              setState(() {
                                isApicallProcess = false;
                              });
                              if (ret) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OTP(
                                      user: usersignup,
                                    ),
                                  ),
                                );
                              } else {
                                FormHelper.showMessage(
                                    context,
                                    "SUYOGA",
                                    "Mobile No. or Email already exists",
                                    "OK", () {
                                  Navigator.of(context).pop();
                                });
                              }
                            });
                          }
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
          ))
    ]);
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
