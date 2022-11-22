import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/utils/Colors.dart';

class StopWatchTimerWidget extends StatefulWidget {
  @override
  _StopWatchTimerWidgetState createState() => _StopWatchTimerWidgetState();
}

class _StopWatchTimerWidgetState extends State<StopWatchTimerWidget> {
  static const countdownDuration = Duration(minutes: 10);
  Duration duration = Duration();
  Timer? timer;

  bool countDown = true;
  bool misCheck = false;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          buildTime(),
          16.width,
          buildButtons(),
          8.width,
        ],
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 8),
        buildTimeCard(time: minutes),
        Text(' :', style: boldTextStyle(size: 22)),
        SizedBox(width: 8),
        buildTimeCard(time: seconds),
      ],
    );
  }

  Widget buildTimeCard({required String time}) => Text(
        "$time",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 22),
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        color: primaryColor,
      padding: EdgeInsets.zero,
            text: "Close Timer",
            textColor: Colors.black,
            onTap: () {
              startTimer();
            })
        : AppButton(
        shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        color: primaryColor,
        padding: EdgeInsets.all(12),
            text: "Start Timer!",
            textColor: Colors.black,
            onTap: () {
              startTimer();
            });
  }
}
