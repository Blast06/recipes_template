import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';

class TitleWithGlassWidget extends StatelessWidget {
  final String title;

  TitleWithGlassWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appStore.isDarkMode ? appButtonColorDark : viewLineColor,
      ),
      padding: EdgeInsets.all(16),
      width: context.width(),
      child: Text(title, style: boldTextStyle()),
    );
  }
}
