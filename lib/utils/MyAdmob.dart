import 'dart:io';

import 'package:logger/logger.dart';
import 'package:get/get.dart';

const TEST = true;

class MyAdmob {
  //TEST
  static final String TEST_app_id_ios =
      'ca-app-pub-2334510780816542~6726672523';
  static final String TEST_app_id_android =
      'ca-app-pub-2334510780816542~7385148076';
  static final String TEST_banner_id_ios =
      'ca-app-pub-3940256099942544/2934735716';
  static final String TEST_banner_id_ios2 =
      'ca-app-pub-3940256099942544/2934735716';
  static final String TEST_banner_id_android =
      'ca-app-pub-3940256099942544/6300978111';
  static final String TEST_banner_id_android2 =
      'ca-app-pub-3940256099942544/6300978111';
  static final String TEST_interstitial_id_ios =
      'ca-app-pub-3940256099942544/4411468910';
  static final String TEST_interstitial_id_android =
      'ca-app-pub-3940256099942544/1033173712';

  static final String TEST_open_ad_id_android =
      'ca-app-pub-3940256099942544/3419835294';
  static final String TEST_open_ad_id_ios =
      'ca-app-pub-3940256099942544/3419835294';

  //PROD
  static final String PROD_app_id_ios =
      'ca-app-pub-4473546092325949~8186929167';
  static final String PROD_app_id_android =
      'ca-app-pub-4473546092325949~9494409811';
  static final String PROD_banner_id_ios =
      'ca-app-pub-4473546092325949/8732579210';
  static final String PROD_banner_id_ios2 =
      'ca-app-pub-4473546092325949/3480252531';
  static final String PROD_banner_id_android =
      'ca-app-pub-4473546092325949/1475786166';
  static final String PROD_banner_id_android2 =
      'ca-app-pub-4473546092325949/9162704490';
  static final String PROD_interstitial_id_ios =
      'ca-app-pub-4473546092325949/5977496040';
  static final String PROD_interstitial_id_android =
      'ca-app-pub-4473546092325949/7857988037';
  static final String PROD_open_ad_id_android =
      'ca-app-pub-4473546092325949/7096063917';
  static final String PROD_open_ad_id_ios =
      'ca-app-pub-4473546092325949/5560765822';

  static String getAppName() {
    if (Platform.isAndroid) {
      return 'title'.tr;
    } else {
      return 'title'.tr;
    }
  }

  static String? getAdMobAppId() {
    if (Platform.isIOS) {
      return TEST ? MyAdmob.TEST_app_id_ios : MyAdmob.PROD_app_id_ios;
    } else if (Platform.isAndroid) {
      return TEST ? MyAdmob.TEST_app_id_android : MyAdmob.PROD_app_id_android;
    }
    return null;
  }

  static String getBannerAdId() {
    if (Platform.isIOS) {
      // return ;
      return TEST ? MyAdmob.TEST_banner_id_ios : MyAdmob.PROD_banner_id_ios;
    } else if (Platform.isAndroid) {
      // return ;
      return TEST
          ? MyAdmob.TEST_banner_id_android
          : MyAdmob.PROD_banner_id_android;
    }
    return 'null';
  }

  static String getBannerAdId_2() {
    if (Platform.isIOS) {
      // return ;
      return TEST ? MyAdmob.TEST_banner_id_ios2 : MyAdmob.PROD_banner_id_ios2;
    } else if (Platform.isAndroid) {
      // return ;
      return TEST
          ? MyAdmob.TEST_banner_id_android2
          : MyAdmob.PROD_banner_id_android2;
    }
    return 'null';
  }

  static String getInterstitialAdId() {
    if (Platform.isIOS) {
      return TEST
          ? MyAdmob.TEST_interstitial_id_ios
          : MyAdmob.PROD_interstitial_id_ios;
    } else if (Platform.isAndroid) {
      return TEST
          ? MyAdmob.TEST_interstitial_id_android
          : MyAdmob.PROD_interstitial_id_android;
    }
    return 'null';
  }

  String? getOpenAdId() {
    if (Platform.isIOS) {
      return TEST ? MyAdmob.TEST_open_ad_id_ios : MyAdmob.PROD_open_ad_id_ios;
    } else if (Platform.isAndroid) {
      return TEST
          ? MyAdmob.TEST_open_ad_id_android
          : MyAdmob.PROD_open_ad_id_android;
    }
    return null;
  }
}
