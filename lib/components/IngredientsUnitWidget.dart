import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';

class IngredientsUnitWidget extends StatefulWidget {
  final String? selectValueData;

  IngredientsUnitWidget({this.selectValueData});

  @override
  IngredientsUnitWidgetState createState() => IngredientsUnitWidgetState();
}

class IngredientsUnitWidgetState extends State<IngredientsUnitWidget> {
  String? selectedValue = 'g';

  List<String> getIngredientList = [
    'g',
    'ml',
    'tsp',
    'tbsp',
    'bag',
    'bar',
    'bulb',
    'capsule',
    'cl',
    'clove',
    'cob',
    'dash',
    'drop',
    'head',
    'kg',
    'l',
    'leaf',
    'loaf',
    'package',
    'pinch',
    'scoop',
    'sheet',
    'slice',
    'spring',
    'stalk',
    'strip',
    'tea bag',
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.selectValueData != null) {
      selectedValue = widget.selectValueData;
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
                finish(context, selectedValue);
              },
              child: Text(language!.save, style: boldTextStyle(color: primaryColor)),
            ),
          ),
          8.height,
          Divider(color: grey),
          8.height,
          Container(
            color: context.cardColor,
            height: 90,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  pickerTextStyle: primaryTextStyle(),
                ),
              ),
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: getIngredientList.indexOf(selectedValue!)),
                itemExtent: 30,
                children: getIngredientList.map((e) {
                  return Text(e, style: primaryTextStyle(size: 20));
                }).toList(),
                onSelectedItemChanged: (int val) {
                  selectedValue = getIngredientList[val];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
