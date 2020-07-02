import 'package:flutter/material.dart';
import 'package:remote_care/constants/values.dart';

abstract class BaseButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Widget child;
  final Color color;
  final Color textColor;
  final Widget icon;

  BaseButton({this.title = "Button",this.onPressed,this.icon,this.child,this.color,
    this.textColor = AppColors.buttonTextColor});

  @override
  Widget build(BuildContext context) {
    return getDefaultButton();
  }
  @protected
  getDefaultButton(){
    return Container(
      width:double.infinity,
      height:48,
      margin: EdgeInsets.only(top: 5,left: 20,right: 20,bottom: 5),
      child: FlatButton(
        onPressed: () => onPressed(),
        color: color,//AppColors.accentElement,//default
        shape: RoundedRectangleBorder(
          borderRadius: Radii.k4pxRadius,
        ),
        textColor: textColor,//AppColors.textColor,//default
        padding: EdgeInsets.all(0),
        child: child ?? getBaseView() //if child null put a default title
      ),
    );
  }

  @protected
  getBaseView(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /*Visibility(
          visible: icon!=null,
          child: Image.asset("assets/images/bitmap-9.png"),
        ),*/
        SizedBox(
          width: 10,
        ),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ) ,
        ),
      ],
    );
  }
  @protected
  getTitle(title, textColor) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    );
  }
}
