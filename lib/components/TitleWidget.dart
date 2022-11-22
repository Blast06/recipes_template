import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  TitleWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        8.height,
        Text(title, style: boldTextStyle(size: 18, fontFamily: fontFamilyGloria)),
        Image.asset(lineImage, width: 70, color: appStore.isDarkMode ? Colors.white : Colors.black),
        16.height,
      ],
    ).center();
  }
}
