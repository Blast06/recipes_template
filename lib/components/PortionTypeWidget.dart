import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/UtensilModel.dart';
import 'package:recipe_app/utils/Colors.dart';

class PortionTypeWidget extends StatefulWidget {
  final int? unit;
  final String? type;

  PortionTypeWidget({this.unit, this.type});

  @override
  PortionTypeWidgetState createState() => PortionTypeWidgetState();
}

class PortionTypeWidgetState extends State<PortionTypeWidget> {
  String? selectedValue = 'Serving';
  int current = 1;

  List portionType = [
    "Serving",
    "Pieces",
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.unit != null) {
      current = widget.unit!;
      selectedValue = widget.type!;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16),
      height: context.height() * 0.27,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                PortionTypeModel model = PortionTypeModel();
                model.portionType = selectedValue;
                model.portionUnit = current;
                finish(context, model);
              },
              child: Text(language!.save, style: boldTextStyle()),
            ),
          ),
          Divider(color: grey),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              NumberPicker(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor), top: BorderSide(color: primaryColor))),
                value: current,
                minValue: 1,
                maxValue: 60,
                itemHeight: 30,
                onChanged: (value) {
                  current = value;
                  setState(() {});
                },
                textStyle: primaryTextStyle(),
              ),
              16.width,
              Container(
                height: 90,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      pickerTextStyle: primaryTextStyle(),
                    ),
                  ),
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: portionType.indexOf(selectedValue)),
                    backgroundColor: context.cardColor,
                    itemExtent: 30,
                    children: portionType.map((e) {
                      return Text(e, style: primaryTextStyle(size: 20));
                    }).toList(),
                    onSelectedItemChanged: (int val) {
                      selectedValue = portionType[val];
                    },
                  ),
                ),
              ).expand(),
            ],
          )
        ],
      ),
    );
  }
}
