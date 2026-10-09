import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:Samarpana/api_service.dart';
import 'package:Samarpana/model/User_Signup_Model.dart';
import 'package:Samarpana/style.dart';
import 'package:Samarpana/utils/ProgressHUD.dart';
import 'package:Samarpana/utils/form_helper.dart';

class OTP extends StatefulWidget {
  User user;
  //APIService apiService;
  //bool isApicallProcess = false;

  OTP({Key? key, required this.user}) : super(key: key);

  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  late APIService apiService;
  bool isApicallProcess = false;
  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late String? accesscode;
  @override
  void initState() {
    super.initState();
    apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: ProgressHUD(
            child: new Form(
              //   key: _formkey,
              child: formui(),
            ),
            inAsyncCall: isApicallProcess,
            opacity: 0.3));
  }

  Widget formui() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Text(
              "OTP Verification",
              style: headingStyle,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "We sent Verification code To +91 " +
                  " " +
                  (this.widget.user.mobileNumber ?? ""),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("This code valid Upto "),
                TweenAnimationBuilder(
                  tween: Tween(
                    begin: 120.0,
                    end: 0,
                  ),
                  duration: Duration(seconds: 120),
                  builder: (BuildContext context, value, child) => Text(
                    " ${value.toInt()}" + " " + "Seconds",
                    style: TextStyle(color: Colors.red),
                  ),
                  onEnd: () {},
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              child: PinFieldAutoFill(
                codeLength: 4,
                onCodeChanged: (val) {
                  print(val);
                  if (val != null && val.isNotEmpty) {
                    accesscode = this.widget.user.accessCode = val;
                  }
                },
              ),
            ),
            // print(onCodeChanged);
            SizedBox(
              height: 200,
            ),
            new Center(
              child: FormHelper.saveButton("Continue", () {
                //  print(usersignup.toJson());
                setState(() {
                  isApicallProcess = true;
                });
                            }),
            ),
          ],
        ),
      ),
    );
  }
}
