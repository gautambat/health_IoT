import 'package:flutter/material.dart';
import 'package:health_iot/constants/constants.dart';

class DefaultMargin extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  DefaultMargin({Key key,this.child,
    this.padding = Margins.baseMarginAllScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.red,
      padding: padding,
      child: child,
    );
  }
}
