import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/ChangePasswordFieldWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
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
    myBanner!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.changePassword, elevation: 0),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: ChangePasswordFieldWidget(),
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
