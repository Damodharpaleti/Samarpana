import 'package:Samarpana/utils/VerifyPage_FormHelper.dart';
import 'package:flutter/material.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({required Key key}) : super(key: key);

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Stack(
                 // overflow: Overflow.visible,
                  children: <Widget>[
                    // Positioned(
                    //   right: -22.0,
                    //   top: -15.0,
                    //   child: InkResponse(
                    //     onTap: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     child: CircleAvatar(
                    //       child: Icon(
                    //         Icons.close,
                    //         size: 25,
                    //         color: Colors.black,
                    //       ),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //   ),
                    // ),
                    Form(
                      // key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Edit Existing Address',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FormHelper.textInput(
                            context,
                            "",
                            (value) => {},
                            onValidate: (value) => null,
                            hintText: "Pincode",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          FormHelper.textInput(
                            context,
                            "",
                            (value) => {},
                            onValidate: (value) => null,
                            hintText: "Pincode",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          FormHelper.textInput(
                            context,
                            "",
                            (value) => {},
                            onValidate: (value) => null,
                            hintText: "Pincode",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 20),
                            prefixIcon: Icon(
                              Icons.location_city,
                              color: Colors.black,
                              size: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[500],
                              ),
                              child: Text(
                                "Save Address",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {},
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return Text("data");
          }
          return Text("data");
        });
  }
}
