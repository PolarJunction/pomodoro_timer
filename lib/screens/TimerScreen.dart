import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodorotimer/components/ActionButton.dart';
import 'package:pomodorotimer/components/DoroWidget.dart';
import 'package:pomodorotimer/components/PreferenceButton.dart';
import 'package:pomodorotimer/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerScreen extends StatefulWidget {
  static const id = "timer";

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

// Time left tracker, displayed to the screen
Duration _duration;

// Initial duration, set by the user
Duration _workDuration = Duration(minutes: 25);
Duration _breakDuration = Duration(minutes: 5);
// Settings Temporary Ints
int setWorkTime = _workDuration.inMinutes;
int setRestTime = _breakDuration.inMinutes;

// The tick at which to check the time elapsed from the StopWatch
Duration _tick = Duration(milliseconds: 250);

// Stopwatch object, tracks the time elapsed between runs
var watch = Stopwatch();

// If the watch has been stopped, we don't keep polling for updates
bool _timerStop = true;
bool _onBreak = false;

IconData keyButtonIcon = Icons.play_arrow;

class _TimerScreenState extends State<TimerScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Duration getDuration() {
    if (_onBreak) {
      return _breakDuration;
    } else {
      return _workDuration;
    }
  }

  /* Starts the timer, and calls the periodic function that re-calculates time remaining */
  void startTimer() {
    watch.start();

    setState(() {
      _timerStop = false;
    });

    Timer.periodic(_tick, (timer) {
      if (_timerStop == true) {
        timer.cancel();
        return;
      }

      setState(() {
        // Calculate the time remaining
        _duration = getDuration() - watch.elapsed;

        // If we are negative, then we have "hit" zero
        if (_duration.isNegative) {
          watch.stop();
          watch.reset();
          _duration = Duration.zero;
          timer.cancel();

          hitZeroHandle();
        }
      });
    });
  }

  void pauseTimer() {
    watch.stop();

    setState(() {
      _timerStop = true;
      _duration = _workDuration - watch.elapsed;
    });
  }

  void resetTimer() {
    watch.stop();
    watch.reset();

    setState(() {
      _timerStop = true;

      _duration = getDuration();
    });
  }

  void skipTimer() {
    _timerStop = true;

    setState(() {
      _duration = Duration.zero;
      watch.stop();
      watch.reset();
    });

    hitZeroHandle();
  }

  void startBreak() {
    setState(() {
      _onBreak = true;
      resetTimer();
      startTimer();
    });
  }

  void startWork() {
    setState(() {
      _onBreak = false;
      resetTimer();
      startTimer();
    });
  }

  void hitZeroHandle() {
    if (_onBreak == true) {
      alertEndOfBreak();
    } else {
      alertEndOfWork();
    }
  }

  void alertEndOfWork() {
    Alert(
      context: context,
      title: "Time for a break!",
      image: Image(
        image: AssetImage("images/RestDoro.png"),
        width: 150,
        height: 150,
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        DialogButton(
          child: Text(
            "Start Break",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            Navigator.pop(context);
            startBreak();
          },
          color: kDarkFontColor,
        )
      ],
    ).show();
  }

  void alertEndOfBreak() {
    Alert(
      context: context,
      title: "Time to get back to work!",
      image: Image(
        image: AssetImage("images/FocusDoro.png"),
        width: 150,
        height: 150,
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        DialogButton(
          child: Text(
            "Start Work",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            Navigator.pop(context);
            startWork();
          },
          color: kDarkFontColor,
        )
      ],
    ).show();
  }

  Widget getKeyButton() {
    if (_timerStop == true) {
      return ActionButton(
        icon: keyButtonIcon,
        onClick: startTimer,
      );
    } else {
      return ActionButton(
        icon: Icons.pause,
        onClick: pauseTimer,
      );
    }
  }

  // Convert 1 to "01" for the timer formatting
  String toTwoDigitString(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  String getTimeString(Duration time) {
    String minutes = toTwoDigitString(time.inMinutes.remainder(60));
    String seconds = toTwoDigitString(time.inSeconds.remainder(60));

    return "$minutes:$seconds";
  }

  String getGreeting() {
    // Welcome greeting check
    var curHour = DateTime.now().hour;

    if (curHour < 12) {
      return "Good Morning!";
    } else if (curHour < 17) {
      return "Good Afternoon!";
    } else {
      return "Good Evening!";
    }
  }

  void setPreferences() async {
    setState(() {
      _workDuration = Duration(minutes: setWorkTime);
      _breakDuration = Duration(minutes: setRestTime);
    });

    // Set the local preference to avoid showing the intro every time
    SharedPreferences prefs = await _prefs;
    prefs.setInt("workTime", setWorkTime);
    prefs.setInt("restTime", setRestTime);
  }

  void _showSettings() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return BottomSheet(
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, setState) => Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("images/FocusDoro.png"),
                        width: 150.0,
                        height: 150.0,
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Work for:",
                            style: kPreferenceTextStyle,
                            textAlign: TextAlign.end,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              PreferenceButton(
                                  icon: Icons.remove,
                                  onClick: () {
                                    setState(() {
                                      if (setWorkTime > 1) setWorkTime--;
                                    });
                                  }),
                              Text("${toTwoDigitString(setWorkTime)} mins", style: kPreferenceTextStyle),
                              PreferenceButton(
                                  icon: Icons.add,
                                  onClick: () {
                                    setState(() {
                                      if (setWorkTime < 60) setWorkTime++;
                                    });
                                  }),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            " Rest for:",
                            style: kPreferenceTextStyle,
                            textAlign: TextAlign.end,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              PreferenceButton(
                                  icon: Icons.remove,
                                  onClick: () {
                                    setState(() {
                                      if (setRestTime > 1) setRestTime--;
                                    });
                                  }),
                              Text("${toTwoDigitString(setRestTime)} mins", style: kPreferenceTextStyle),
                              PreferenceButton(
                                  icon: Icons.add,
                                  onClick: () {
                                    setState(() {
                                      if (setRestTime < 60) setRestTime++;
                                    });
                                  }),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            onClosing: () {});
      },
    ).whenComplete(setPreferences);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initPreferences();
  }

  void initPreferences() async {
    SharedPreferences prefs = await _prefs;

    print("GOT work time preferences");

    setState(() {
      _workDuration = Duration(minutes: prefs.getInt("workTime"));
      _breakDuration = Duration(minutes: prefs.getInt("restTime"));
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
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: <Widget>[
                      Text(getTimeString(_duration ?? _workDuration), style: kTimerStyle),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          getKeyButton(),
                          ActionButton(
                            icon: Icons.restore,
                            onClick: resetTimer,
                          ),
                          ActionButton(
                            icon: Icons.skip_next,
                            onClick: skipTimer,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DoroWidget(
                greetMsg: getGreeting(),
                taskMsg: _onBreak ? "Time to rest.." : "Time to focus..",
                assetImage: _onBreak ? AssetImage("images/RestDoro.png") : AssetImage("images/HappyDoro.png"),
                onClick: _showSettings,
              ),
            ],
          ),
        )),
      ),
    );
  }
}
