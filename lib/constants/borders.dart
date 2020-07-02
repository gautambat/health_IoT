

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:remote_care/constants/values.dart';


class Borders {
  static const BorderSide primaryBorder = BorderSide(
    color: Color.fromARGB(255, 151, 151, 151),
    width: 1,
    style: BorderStyle.solid,
  );
  static const BorderSide noBorder = BorderSide(
    color: Colors.transparent,
    width: 1,
    style: BorderStyle.solid,
  );
  static const BorderSide secondaryBorder = BorderSide(
    color: Color.fromARGB(255, 227, 232, 237),
    width: 1,
    style: BorderStyle.solid,
  );
  static const BorderSide errorBorder = BorderSide(
    color: Color.fromARGB(255, 255, 0, 0),
    width: 1,
    style: BorderStyle.solid,
  );
  static const outlineInputBorder = OutlineInputBorder(
      borderSide: Borders.secondaryBorder,
      borderRadius: Radii.k4pxRadius
  );
  static const outlineErrorInputBorder = OutlineInputBorder(
      borderSide: Borders.errorBorder,
      borderRadius: Radii.k4pxRadius
  );
}
class Margins{
  static const EdgeInsets baseMarginVertical =  EdgeInsets.only(top: 8,bottom: 8);
  static const EdgeInsets baseMarginHorizontalScreen =  EdgeInsets.only(left: 16,right: 16);
  static const EdgeInsets baseMarginAllScreen =  EdgeInsets.only(left:16.0,right:16.0,top:5,bottom: 5);
}