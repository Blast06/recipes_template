import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:nb_utils/nb_utils.dart';
import '../database/DatabaseHelper.dart';
import '../screen/DashboardScreen.dart';
import '../screen/DashboardWebScreen.dart';
import '../screen/WalkThroughScreen.dart';
import '../utils/Constants.dart';
import 'AdmobController.dart';

import 'package:is_first_run/is_first_run.dart';

class SplashController extends GetxController {
  final admob = Get.find<AdmobController>();
  Logger log = Logger();

  bool showInterstitial = false;

  @override
  void onReady() async {
    log.i("onReady of splash controller");
    bool firstRun = await IsFirstRun.isFirstRun();
    
    super.onReady();
    // await admob.loadAd();

    await Future.delayed(const Duration(seconds: 5), () {
      // admob.showAdIfAvailable();
      if (!firstRun) {
        admob.appOpenAd!.show();
      }
      Get.off(() => DashboardScreen(), transition: Transition.zoom);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    log.i("Init of splash controller");
    // await prepareApi();
    // await admob.loadInterstitial();
  }

  // Future<void> init() async {
   
  //   if (isMobile) {
  //     database = await DatabaseHelper.instance.database;
  //   }
  //   await Future.delayed(Duration(seconds: 2));

  //   if (getBoolAsync(IS_FIRST_TIME, defaultValue: true) && isMobile) {
  //     WalkThroughScreen().launch(context, isNewTask: true);
  //   } else {
  //     if (isWeb) {
  //       DashboardWebScreen().launch(context, isNewTask: true);
  //     } else {
  //       DashboardScreen().launch(context, isNewTask: true);
  //     }
  //   }
  // }
}
