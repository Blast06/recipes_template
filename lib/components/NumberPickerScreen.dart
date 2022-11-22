import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';

class NumberPickerScreen extends StatefulWidget {
  final int? aHour;
  final int? aMinutes;

  NumberPickerScreen({this.aHour, this.aMinutes});

  @override
  NumberPickerScreenState createState() => NumberPickerScreenState();
}

class NumberPickerScreenState extends State<NumberPickerScreen> {
  int currentHours = 0;
  int currentMinutes = 0;
  int totalTime = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    currentHours = widget.aHour!;
    currentMinutes = widget.aMinutes!;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                totalTime = currentHours * 60 + currentMinutes;
                finish(context, totalTime);
              },
              child: Text(language!.done, style: primaryTextStyle()),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: primaryColor), top: BorderSide(color: primaryColor)),
                  ),
                  value: currentHours,
                  minValue: 0,
                  maxValue: 24,
                  itemHeight: 30,
                  onChanged: (value) {
                    currentHours = value;
                    setState(() {});
                  },
                  textStyle: primaryTextStyle(),
                ),
                32.width,
                NumberPicker(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor), top: BorderSide(color: primaryColor))),
                  value: currentMinutes,
                  minValue: 0,
                  maxValue: 60,
                  itemHeight: 30,
                  onChanged: (value) {
                    currentMinutes = value;
                    setState(() {});
                  },
                  textStyle: primaryTextStyle(),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(language!.hours, style: primaryTextStyle()),
              Text(language!.minutes, style: primaryTextStyle()),
            ],
          )
        ],
      ),
    );
  }
}
