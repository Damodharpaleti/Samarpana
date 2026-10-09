// import 'package:Samarpana/model/UpdatePasswordModel.dart';
// import 'package:Samarpana/pages/Update_Password.dart';
// import 'package:Samarpana/utils/dataBase.dart';
// import 'package:flutter/material.dart';
// import 'package:sms_autofill/sms_autofill.dart';
// import 'package:Samarpana/api_service.dart';
// import 'package:Samarpana/pages/loggin.dart';
// import 'package:Samarpana/style.dart';
// import 'package:Samarpana/utils/ProgressHUD.dart';
// import 'package:Samarpana/utils/form_helper.dart';

// class UpdateOTP extends StatefulWidget {
//   UpdatePasswordModel user;
//   //APIService apiService;
//   //bool isApicallProcess = false;

//   UpdateOTP({Key key, this.user}) : super(key: key);

//   // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//   @override
//   _UpdateOTPState createState() => _UpdateOTPState();
// }

// class _UpdateOTPState extends State<UpdateOTP> {
//   APIService apiService;
//   bool isApicallProcess = false;
//   // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   String accesscode;
//   final dbHelper = DBProvider.instance;
//   @override
//   void initState() {
//     super.initState();
//     apiService = new APIService();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Map<String, dynamic> user = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//         body: ProgressHUD(
//             child: new Form(
//               //   key: _formkey,
//               child: formui(),
//             ),
//             inAsyncCall: isApicallProcess,
//             opacity: 0.3));
//   }

//   Widget formui() {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(10.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: 100,
//             ),
//             Text(
//               "OTP Verification",
//               style: headingStyle,
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             Text(
//               "We sent Verification code To +91 " +
//                   " " +
//                   this.widget.user.mobileNumber,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("This code valid Upto "),
//                 TweenAnimationBuilder(
//                   tween: Tween(
//                     begin: 120.0,
//                     end: 0,
//                   ),
//                   duration: Duration(seconds: 120),
//                   builder: (BuildContext context, value, child) => Text(
//                     " ${value.toInt()}" + " " + "Seconds",
//                     style: TextStyle(color: Colors.red),
//                   ),
//                   onEnd: () {},
//                 ),
//               ],
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
//               child: PinFieldAutoFill(
//                 codeLength: 4,
//                 onCodeChanged: (val) {
//                   if (val.isNotEmpty) {
//                     accesscode = this.widget.user.accessCode = val;
//                   }
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 200,
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 50),
//               child: new Row(
//                 children: [
//                   FormHelper.cancelButton("Cancel", () {
//                     FormHelper.showMessage(context, "SUYOGA",
//                         "Are you sure you want to back", "OK", () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => UpdatePassword(),
//                         ),
//                       );
//                     });
//                   }),
//                   SizedBox(
//                     width: 25,
//                   ),
//                   FormHelper.saveButton("Submit", () {
//                     if (accesscode != null) {
//                       setState(() {
//                         isApicallProcess = true;
//                       });
//                       apiService.updatepassword(this.widget.user).then((value) {
//                         setState(() {
//                           isApicallProcess = false;
//                         });
//                         if (value.statusCode == 201) {
//                           dbHelper.userdelete();
//                           FormHelper.showMessage(
//                               context, "SUYOGA", value.message, "OK", () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => LoginPage(),
//                               ),
//                             );
//                           });
//                         } else {
//                           FormHelper.showMessage(
//                               context, "SUYOGA", value.message, "OK", () {
//                             Navigator.of(context).pop();
//                           });
//                         }
//                       });
//                     }
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
