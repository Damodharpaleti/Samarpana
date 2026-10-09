// import 'package:Samarpana/model/UpdatePasswordModel.dart';
// import 'package:Samarpana/pages/Delivery_status.dart';
// import 'package:Samarpana/pages/Update_Password_OTP.dart';
// import 'package:flutter/material.dart';
// import 'package:Samarpana/api_service.dart';
// import 'package:Samarpana/utils/ProgressHUD.dart';
// import 'package:Samarpana/utils/VerifyPage_FormHelper.dart';

// import '../model/LoginRespose.dart';
// import '../utils/dataBase.dart';

// class UpdatePassword extends StatefulWidget {
//   @override
//   _UpdatePasswordState createState() => _UpdatePasswordState();
// }

// class _UpdatePasswordState extends State<UpdatePassword> {
//   //String username;
//   APIService apiService;
//   bool isApiCallProcess = false;
//   UpdatePasswordModel updatePasswordModel;
//   GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
//   String confirmpassword = "";
//   bool hidePassword = true;
//   bool hidePassword1 = true;
//   bool hidePassword2 = true;
//   final dbHelper = DBProvider.instance;
//   UserdatafromDB model;
//   List<UserdatafromDB> list = new List();

//   @override
//   void initState() {
//     super.initState();
//     apiService = new APIService();
//     updatePasswordModel = new UpdatePasswordModel();
//     fetch();
//   }

//   fetch() async {
//     final coutnt = await dbHelper.getCount();

//     final allRows = await dbHelper.queryuserRows();
//     allRows.forEach((row) => {
//           model = UserdatafromDB(
//             row["id"].toString(),
//             row["firstName"],
//             row["lastName"],
//             row["address1"],
//             row["address2"],
//             row["state"],
//             row["city"],
//             row["pinCode"],
//             row["mobileNumber"],
//             row["token"],
//             row["emailId"],
//             row["walletamt"],
//           ),
//           list.add(model)
//         });
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ProgressHUD(
//       child: _uiSetup(context),
//       inAsyncCall: isApiCallProcess,
//       opacity: 0.3,
//     );
//   }

//   Widget _uiSetup(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Stack(
//       children: [
//         // BackgroundImage(image: 'assets/images/grocery.jpg'),
//         Scaffold(
//           //  resizeToAvoidBottomInset: false,
//           backgroundColor: Colors.blueGrey[100],
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => OrderStatus(),
//                   ),
//                 );
//               },
//               icon: Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.black,
//               ),
//             ),
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: Text('Update Password',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold)),
//             centerTitle: true,
//           ),
//           body: Column(
//             children: [
//               Center(
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: size.height * 0.1,
//                     ),
//                     Container(
//                       width: size.width * 0.8,
//                       child: Text(
//                         'Enter your Password Details Here we will Update Your Password',
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: FormHelper.textInput(
//                         context,
//                         this.updatePasswordModel.mobileNumber =
//                             model.mobileNumber,
//                         (value) =>
//                             {this.updatePasswordModel.mobileNumber = value},
//                         onValidate: (value) => value.length < 10
//                             ? "Please Enter Your New Password"
//                             : null,
//                         hintText: "Enter Your Registered Mobile Number",
//                         hintStyle: TextStyle(
//                             color: Colors.black,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold),
//                         prefixIcon: Icon(
//                           Icons.phone,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: FormHelper.textInput(
//                           context,
//                           updatePasswordModel.oldPassword,
//                           (value) =>
//                               {this.updatePasswordModel.oldPassword = value},
//                           onValidate: (value) => value.length < 4
//                               ? "Please Enter Your Old Password"
//                               : null,
//                           hintText: "Enter Your Old Password",
//                           obscureText: hidePassword1,
//                           hintStyle: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20),
//                           prefixIcon: Icon(
//                             Icons.lock,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 hidePassword1 = !hidePassword1;
//                               });
//                             },
//                             color: Colors.red,
//                             icon: Icon(hidePassword1
//                                 ? Icons.visibility_off
//                                 : Icons.visibility),
//                           )),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: FormHelper.textInput(
//                           context,
//                           this.updatePasswordModel.newPassword,
//                           (value) =>
//                               {this.updatePasswordModel.newPassword = value},
//                           onValidate: (value) => value.length <= 4
//                               ? "Password should be more than 4 characters"
//                               : null,
//                           hintText: "Enter Your New Password",
//                           hintStyle: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20),
//                           obscureText: hidePassword,
//                           prefixIcon: Icon(
//                             Icons.lock,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                           suffixIcon: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 hidePassword = !hidePassword;
//                               });
//                             },
//                             color: Colors.red,
//                             icon: Icon(hidePassword
//                                 ? Icons.visibility_off
//                                 : Icons.visibility),
//                           )),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: FormHelper.textInput(
//                         context, this.confirmpassword,
//                         (value) => {this.confirmpassword = value},
//                         onValidate: (value) => value.length <= 4
//                             ? "Password should be more than 4 characters"
//                             : null,
//                         hintText: "Confirm Your New Password",
//                         hintStyle: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20),
//                         obscureText: hidePassword2,
//                         prefixIcon: Icon(
//                           Icons.lock,
//                           color: Colors.black,
//                           size: 30,
//                         ),
//                         // suffixIcon: IconButton(
//                         //   onPressed: () {
//                         //     // setState(() {
//                         //     //   hidePassword = !hidePassword;
//                         //     // });
//                         //   },
//                         //   color: Colors.red,
//                         //   icon: Icon(hidePassword1
//                         //       ? Icons.visibility_off
//                         //       : Icons.visibility),
//                         // )
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     FlatButton(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 18, horizontal: 110),
//                       onPressed: () {
//                         if (updatePasswordModel.mobileNumber != null &&
//                             updatePasswordModel.oldPassword != null &&
//                             updatePasswordModel.newPassword != null) {
//                           if (updatePasswordModel.newPassword.length >= 4) {
//                             if (updatePasswordModel.newPassword ==
//                                 confirmpassword) {
//                               setState(() {
//                                 isApiCallProcess = true;
//                               });
//                               apiService
//                                   .loginWithOTP(
//                                       updatePasswordModel.mobileNumber)
//                                   .then((value) => {
//                                         if (value)
//                                           {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder: (context) => UpdateOTP(
//                                                     user: updatePasswordModel),
//                                               ),
//                                             ),
//                                           }
//                                       });
//                             } else {
//                               FormHelper.showMessage(
//                                   context,
//                                   "SUYOGA",
//                                   " Confirm password should be match to new password",
//                                   "OK", () {
//                                 Navigator.of(context).pop();
//                               });
//                             }
//                           } else {
//                             FormHelper.showMessage(
//                                 context,
//                                 "SUYOGA",
//                                 " New Password should be More than 4 Characters",
//                                 "OK", () {
//                               Navigator.of(context).pop();
//                             });
//                           }
//                         } else {
//                           FormHelper.showMessage(context, "SUYOGA",
//                               " Please Fill the Required Details", "OK", () {
//                             Navigator.of(context).pop();
//                           });
//                         }
//                       },
//                       child: Text(
//                         "Continue",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                         ),
//                       ),
//                       color: Colors.green,
//                       shape: StadiumBorder(),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
