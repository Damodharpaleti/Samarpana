import 'package:flutter/material.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/ForgotPassword_model.dart';
import 'package:Samarpana/pages/Forgot_OTP.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/utils/background-image.dart';
import 'package:Samarpana/utils/form_helper.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //String username;
  late APIService apiService;
  bool isApiCallProcess = false;
  late ForgotPasswordOTP forgotPassword;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    forgotPassword = new ForgotPasswordOTP(mobile: '', accessCode: '');
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        BackgroundImage(image: 'assets/images/grocery.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                // Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: Text(
              'Forgot Password',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Text(
                        'Enter your Mobile Number we will send New Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: FormHelper.textInput(
                        context,
                        forgotPassword.mobile,
                        (value) => {this.forgotPassword.mobile = value},
                        onValidate: (value) => value.length < 10
                            ? "Please Enter Valid Mobile Number"
                            : null,
                        hintText: "Enter Your Mobile Number",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(vertical: 18, horizontal: 110),
                        shape: StadiumBorder(),
                      ),
                      onPressed: () {
                        //  print("deleted");
                        if (forgotPassword.mobile.isNotEmpty) {
                          setState(() {
                            isApiCallProcess = true;
                          });
                          apiService
                              .loginWithOTP(forgotPassword.mobile)
                              .then((value) => {
                                    if (value)
                                      {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotOTP(user: forgotPassword),
                                          ),
                                        ),
                                      }
                                    else
                                      {}
                                  });
                        }
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
