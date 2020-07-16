import 'package:health_iot/constants/constants.dart';
import 'package:health_iot/widgets/base/base_button.dart';

///Simple basic button with the [title]
class CustomButton extends BaseButton {
  CustomButton({title,onPressed,color}):super(title:title,onPressed:onPressed,color:color);
}

class ImageButton extends BaseButton {
  ImageButton({title,
    icon,
    iconAlignment,
    color = AppColors.accentElement,
    textColor = AppColors.buttonTextColor,
    onPressed
  }):super(title:title,icon:icon,onPressed:onPressed,color:color,textColor:textColor);//Image.asset("assets/images/bitmap-9.png",)
}
