import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/SettingMobileWidget.dart';
import 'package:recipe_app/components/SettingWebWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Constants.dart';

class SettingScreen extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (isMobile) myBanner = buildBannerAd()..load();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode ? mAdMobBannerId : BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: AdRequest(keywords: testDevices),
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (isMobile) myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb
          ? null
          : appBarWidget(
              language!.setting,
              backWidget: CloseButton(color: context.iconColor),
              actions: [
                Text('v${packageInfo.versionName}', style: boldTextStyle()).paddingRight(16).center(),
              ],
            ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Responsive(
            web: SettingWebWidget(),
            mobile: SettingMobileWidget(),
          ),
          if (isMobile)
            myBanner != null && !disabled_ads
                ? Positioned(
                    child: AdWidget(ad: myBanner!),
                    bottom: 0,
                    height: AdSize.banner.height.toDouble(),
                    width: context.width(),
                  )
                : SizedBox(),
        ],
      ),
    );
  }
}
