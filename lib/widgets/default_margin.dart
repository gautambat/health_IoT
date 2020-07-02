import 'package:flutter/material.dart';
import 'package:remote_care/constants/values.dart';

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
