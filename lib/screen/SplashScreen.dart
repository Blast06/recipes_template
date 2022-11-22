import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/database/DatabaseHelper.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/DashboardScreen.dart';
import 'package:recipe_app/screen/DashboardWebScreen.dart';
import 'package:recipe_app/screen/WalkThroughScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

import '../controllers/AdmobController.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final admob = Get.find<AdmobController>();
  
  @override
  void initState() {
    if (!getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
      admob.appOpenAd?.show();
    }
    super.initState();
    init();
  }

  Future<void> init() async {
    //setStatusBarColor(appStore.isDarkMode ? scaffoldColorDark : white,statusBarBrightness: Brightness.light);
    if (isMobile) {
      database = await DatabaseHelper.instance.database;
    }
    await Future.delayed(Duration(seconds: 2));

    if (getBoolAsync(IS_FIRST_TIME, defaultValue: true) && isMobile) {
      WalkThroughScreen().launch(context, isNewTask: true);
    } else {
      if (isWeb) {
        DashboardWebScreen().launch(context, isNewTask: true);
      } else {
        DashboardScreen().launch(context, isNewTask: true);
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(appLogo, height: 120),
          16.height,
          Text(mAppName,
              style: boldTextStyle(size: 20, fontFamily: fontFamilyGloria)),
        ],
      ).center(),
    );
  }
}
