import 'package:flutter/material.dart';
import 'package:remote_care/constants/constants.dart';
import 'package:remote_care/widgets/base/base_button.dart';

///Simple basic button with the [title]
class CustomButton extends BaseButton {
  CustomButton({title,onPressed,color}):super(title:title,onPressed:onPressed,color:color);
}

/// Image Button
/// Sample Usage
///
/// ImageButton(title:"Google Sign Up",
///        color: AppColors.buttonSecondaryBackground,
///        textColor: AppColors.buttonSecondaryTextColor,
///        icon: Image.asset("assets/images/bitmap-9.png"))
class ImageButton extends BaseButton {
  ImageButton({title,
    icon,
    iconAlignment,
    color = AppColors.accentElement,
    textColor = AppColors.buttonTextColor,
    onPressed
  }):super(title:title,icon:icon,onPressed:onPressed,color:color,textColor:textColor);//Image.asset("assets/images/bitmap-9.png",)
}
