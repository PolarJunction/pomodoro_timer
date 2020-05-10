import 'package:flutter/material.dart';
import 'package:pomodorotimer/utils/constants.dart';

class ActionButton extends StatelessWidget {
  ActionButton({this.icon, this.onClick});

  final Function onClick;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onClick,
      child: Icon(
        icon,
        size: 35.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8.0),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: kDarkFontColor,
    );
  }
}
