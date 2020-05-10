import 'package:flutter/material.dart';
import 'package:pomodorotimer/utils/constants.dart';

class DoroWidget extends StatelessWidget {
  DoroWidget({this.greetMsg, this.taskMsg, this.assetImage, this.onClick});

  final String greetMsg;
  final String taskMsg;
  final Function onClick;
  final AssetImage assetImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                  bottomLeft: Radius.zero)),
          child: FlatButton(
            child: Image(
              image: assetImage,
              height: 80.0,
              width: 80.0,
            ),
            onPressed: onClick,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              greetMsg,
              style: kLargeTextStyle,
            ),
            Text(
              taskMsg,
              style: kSmallTextStyle,
            ),
          ],
        ),
      ],
    );
  }
}
