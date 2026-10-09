import 'package:flutter/material.dart';

const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;

const String FontNameDefault = 'Montserrat';

const AppBarTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: MediumTextSize,
  color: Colors.white,
);

const TitleTextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: LargeTextSize,
  color: Colors.black,
);

const Body1TextStyle = TextStyle(
  fontFamily: FontNameDefault,
  fontWeight: FontWeight.w300,
  fontSize: BodyTextSize,
  color: Colors.black,
);

TextStyle headingStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700
);
TextStyle contentStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  fontFamily: 'sfpro'
);
LinearGradient gradientStyle = LinearGradient(
    colors: [Color(0xfff3953b), Color(0xffe57509)],
    stops: [0,1],
    begin: Alignment.topCenter
);
