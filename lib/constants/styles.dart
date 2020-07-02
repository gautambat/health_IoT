import 'package:flutter/material.dart';
import 'package:remote_care/constants/values.dart';

class BaseStyles{
  static TextStyle hintTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.66667,
  );
  static TextStyle loginSubHeadingTextStyle = TextStyle(
  color: AppColors.secondaryText,
  fontWeight: FontWeight.w400,
  fontSize: 16,
  height: 1.5,
  );
  static const TextStyle editLabelTextStyle = TextStyle(
    color: AppColors.secondaryText,

  );
  static const TextStyle editTextTextStyle2 = TextStyle(
    color: AppColors.secondaryText,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5,
  );

  static const TextStyle editTextTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5,
  );
  static const TextStyle eRxTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.5,
  );
  static const TextStyle editHintTextStyle = TextStyle(
    color: Color.fromARGB(255, 221, 225, 230),
    fontFamily: "Manrope",
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
  );
  static TextStyle baseTextStyle = TextStyle(color: AppColors.primaryText,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.428571,);


  static TextStyle titleTextStyle = TextStyle(
    color: AppColors.primaryText,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.33333,
  );

  static TextStyle loginHeadingTextStyle =
  TextStyle(
  color: AppColors.primaryText,
  fontWeight: FontWeight.w700,
  fontSize: 24,
  height: 1.45833,
  );
  static TextStyle errorTextStyle = TextStyle(
    color: AppColors.errorColor,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.33333,
  );

  static TextStyle navigationTextStyle = TextStyle(
    color: AppColors.secondaryText,
    fontFamily: "Manrope",
    fontWeight: FontWeight.w500, //400
    fontSize: 11, //10
    height: 1.4,
  );
  static TextStyle navigationTextStyle2 = TextStyle(
    color: AppColors.activeIconColor,
    fontFamily: "Manrope",
    fontWeight: FontWeight.w500, //400
    fontSize: 11, //10
    height: 1.4,
  );
  static TextStyle appTitleTextStyle =TextStyle(
    color: AppColors.white,//Color.fromARGB(255, 255, 255, 255),
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.625,
  );

}