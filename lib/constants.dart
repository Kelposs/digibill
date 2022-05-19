import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff7cb342);
const kPrimaryLightColor = Color(0xFFF1F8E9);
const kTextColor = Color(0xFF0D1333);

const kHeadingextStyle = TextStyle(
  fontSize: 28,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);
const kSubheadingextStyle = TextStyle(
  fontSize: 24,
  color: Color(0xFF61688B),
  height: 2,
);

const kTitleTextStyle = TextStyle(
    fontSize: 20,
    color: kTextColor,
    fontWeight: FontWeight.w700,
    fontFamily: Constants.POPPINS);

const kSubtitleTextSyule = TextStyle(
  fontSize: 18,
  color: kTextColor,
  // fontWeight: FontWeight.bold,
);

class Constants {
  static const String POPPINS = "Poppins";
  static const String OPEN_SANS = "OpenSans";
  static const String SKIP = "Skip";
  static const String NEXT = "Next";
  static const String SLIDER_HEADING_1 = "Welcome to DigiBill";
  static const String SLIDER_HEADING_2 = "Save money with ease";
  static const String SLIDER_HEADING_3 = "Track your bills like never before";
  static const String SLIDER_DESC =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla ultricies, erat vitae porta consequat.";
}
