import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/fragment/HomeFragment.dart';
import 'package:recipe_app/fragment/ProfileFragment.dart';
import 'package:recipe_app/fragment/SearchFragment.dart';
import 'package:recipe_app/models/AppModel.dart';
import 'package:recipe_app/screen/AboutAppScreen.dart';
import 'package:recipe_app/screen/admin/AdminCuisineTypeScreen.dart';
import 'package:recipe_app/screen/admin/AdminDishTypeScreen.dart';
import 'package:recipe_app/screen/admin/AdminSettingScreen.dart';
import 'package:recipe_app/screen/admin/AdminSliderScreen.dart';
import 'package:recipe_app/screen/newRecipe/NewRecipeScreen.dart';

import '../main.dart';

List<AppModel> getAllData() {
  List<AppModel> list = [];
  list.add(AppModel(name: language!.home, widget: HomeFragment()));
  list.add(AppModel(
    name: language!.search,
    widget: Responsive(
      useFullWidth: false,
      tablet: SearchFragment(spanCount: 3),
      web: SearchFragment(spanCount: 5),
      mobile: SearchFragment(spanCount: 2),
    ),
  ));
  if (appStore.isAdmin || appStore.isDemoAdmin) list.add(AppModel(name: language!.addRecipe, widget: NewRecipeScreen()));
  list.add(AppModel(name: language!.profile, widget: ProfileFragment()));

  return list;
}

List<AppModel> getSettingData() {
  List<AppModel> list = [];
  list.add(AppModel(name: language!.selectTheme, icon: MaterialCommunityIcons.theme_light_dark));
  list.add(AppModel(name: language!.language, icon: FontAwesome.language));
  list.add(AppModel(name: language!.adminSetting, icon: Icons.admin_panel_settings_outlined, widget: AdminSettingScreen()));
  list.add(AppModel(name: language!.changePassword, icon: Icons.vpn_key_outlined));
  list.add(AppModel(name: language!.privacyPolicy, icon: Icons.assignment_outlined));
  list.add(AppModel(name: language!.helpSupport, icon: Icons.support_rounded));
  list.add(AppModel(name: language!.about, icon: Icons.info_outline, widget: AboutAppScreen()));
  list.add(AppModel(name: language!.logout, icon: Icons.exit_to_app_rounded));

  return list;
}

List<AppModel> getAdminSettingData() {
  List<AppModel> adminSettingList = [];
  adminSettingList.add(AppModel(name: language!.dishType, icon: Icons.local_dining_sharp, widget: AdminDishTypeScreen()));
  adminSettingList.add(AppModel(name: language!.cuisine, icon: Icons.stream, widget: AdminCuisineTypeScreen()));
  adminSettingList.add(AppModel(name: language!.slider, icon: Icons.door_sliding, widget: AdminSliderScreen()));

  return adminSettingList;
}
