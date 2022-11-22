import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/screen/admin/AdminCuisineTypeScreen.dart';
import 'package:recipe_app/screen/admin/AdminDishTypeScreen.dart';
import 'package:recipe_app/screen/admin/AdminSliderScreen.dart';

import '../main.dart';

class AdminSettingMobileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        8.height,
        SettingItemWidget(
          leading: Icon(Icons.local_dining_sharp),
          title: language!.dishType,
          onTap: () {
            AdminDishTypeScreen().launch(context);
          },
        ),
        SettingItemWidget(
          leading: Icon(Icons.stream),
          title: language!.cuisine,
          onTap: () {
            AdminCuisineTypeScreen().launch(context);
          },
        ),
        SettingItemWidget(
          leading: Icon(Icons.door_sliding),
          title: language!.slider,
          onTap: () {
            AdminSliderScreen().launch(context);
          },
        ),
      ],
    );
  }
}
