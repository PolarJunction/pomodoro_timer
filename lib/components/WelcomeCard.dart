import 'package:flutter/material.dart';
import 'package:pomodorotimer/utils/constants.dart';

class WelcomeCard extends StatelessWidget {
  final String headerText;
  final String bodyText;
  final String actionText;
  final Function actionFunc;

  WelcomeCard(
      {this.headerText, this.bodyText, this.actionText, this.actionFunc});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              headerText,
              style: kCardHeaderTextStyle,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10.0),
            Text(
              bodyText,
              style: kCardBodyTextStyle,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 40.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Image(
                image: AssetImage("images/HappyDoro.png"),
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    actionText,
                    style: kCardBodyTextStyle.copyWith(
                        color: Colors.lightBlueAccent),
                    textAlign: TextAlign.right,
                  ),
                  onPressed: actionFunc,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
