import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final double? height;
  final double? width;

  EmptyWidget({required this.title, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        commonCachedNetworkImage(emptyData, height: height ?? 200, width: width ?? 200,isScaled: false),
        16.height,
        Text(title, style: primaryTextStyle(size: 18)),
      ],
    ).center();
  }
}
