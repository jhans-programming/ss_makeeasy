import 'package:flutter/material.dart';

Map<String, Color> appColors = {
  "primaryDark2": Color(0xffad0072),
  "primaryDark1": Color(0xffdc0091),
  "primary": Color(0xffff00a8),
  "primaryLight1": Color(0xffff68b5),
  "primaryLight2": Color(0xfff17fca),
  "primaryLight3": Color(0xffff99dc),
  "primaryLight4": Color(0xffffebfc),
  "primaryLight5": Color(0xfffff8fe),

  "secondary": Color(0xffff7192),
  "secondaryLight1": Color(0xffffafc1),
  "secondaryLight2": Color(0xfffedee5),

  "accent": Color(0xff00b2ff),
  "accentLight1": Color(0xff68c9ff),
  "accentLight2": Color(0xffdaf6fe),
};

Map<String, LinearGradient> appGradients = {
  "primary": LinearGradient(
    colors: [Color(0xfffff7ad), Color(0xffffa9f9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
};

Map<String, TextStyle> appTextStyles = {
  "normalBlack": TextStyle(
    fontFamily: 'Montserrat',
    color: Colors.black,
    fontSize: 14,
  ),
  "textFormField": TextStyle(color: appColors['primaryDark1'], fontSize: 14),
  "textFormFieldLabel": TextStyle(
    color: appColors['primaryDark1'],
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
};
