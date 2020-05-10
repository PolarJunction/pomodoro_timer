import 'package:flutter/material.dart';
import 'package:pomodorotimer/utils/constants.dart';

class PreferenceButton extends StatelessWidget {
  PreferenceButton({this.icon, this.onClick});

  final Function onClick;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onClick,
      child: Icon(
        icon,
        size: 25.0,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(4.0),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: kDarkFontColor,
    );
  }
}
