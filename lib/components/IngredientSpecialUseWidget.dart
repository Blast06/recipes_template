import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';

class IngredientSpecialUseWidget extends StatefulWidget {
  final String? specialUseValueData;

  IngredientSpecialUseWidget({this.specialUseValueData});

  @override
  IngredientSpecialUseWidgetState createState() => IngredientSpecialUseWidgetState();
}

class IngredientSpecialUseWidgetState extends State<IngredientSpecialUseWidget> {
  String? specialUseValue = 'for breading';

  List<String> specialUseList = [
    'for breading',
    'for coating',
    'for decorating',
    'for deep frying',
    'for dusting',
    'for frying',
    'for garnish',
    'for greasing',
    'for marinating',
    'for serving',
    'for shaking',
    'for sprinkling',
    'for thickening',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.specialUseValueData != null) {
      specialUseValue = widget.specialUseValueData!;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      height: context.height() * 0.3,
      width: context.width(),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                finish(context, specialUseValue.validate());
              },
              child: Text(language!.save, style: boldTextStyle(color: primaryColor)),
            ),
          ),
          8.height,
          Divider(color: grey),
          8.height,
          CupertinoTheme(
            data: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                pickerTextStyle: primaryTextStyle(),
              ),
            ),
            child: Container(
              height: 90,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: specialUseList.indexOf(specialUseValue!)),
                itemExtent: 30,
                children: specialUseList.map((e) {
                  return Text(e, style: primaryTextStyle(size: 20));
                }).toList(),
                onSelectedItemChanged: (int val) {
                  specialUseValue = specialUseList[val];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
