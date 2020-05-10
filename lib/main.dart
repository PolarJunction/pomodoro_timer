import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodorotimer/screens/TimerScreen.dart';
import 'package:pomodorotimer/screens/WelcomeScreen.dart';
import 'package:pomodorotimer/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: (SplashScreen.id), routes: {
      SplashScreen.id: (context) => SplashScreen(),
      TimerScreen.id: (context) => TimerScreen(),
      WelcomeScreen.id: (context) => WelcomeScreen(),
    });
  }
}

class SplashScreen extends StatefulWidget {
  static const id = "splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future checkIntroSeen() async {
    SharedPreferences prefs = await _prefs;

    bool _introSeen = (prefs.getBool("seenIntro") ?? false);

//    if (_introSeen) {
//      Navigator.pushReplacementNamed(context, TimerScreen.id);
//    } else {
    Navigator.pushReplacementNamed(context, WelcomeScreen.id); // TODO - debug only, uncomment conditionals
//    }
  }

  @override
  void initState() {
    super.initState();

    new Timer(new Duration(milliseconds: 200), () {
      checkIntroSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [kBackgroundGradientBegin, kBackgroundGradientEnd])),
        child: Text("Loading.."),
      ),
    );
  }
}
