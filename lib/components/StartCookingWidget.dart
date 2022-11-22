import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/QuickRecipeStepWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class StartCookingWidget extends StatefulWidget {
  final List<RecipeStepModel>? recipeStepData;

  StartCookingWidget({this.recipeStepData});

  @override
  StartCookingWidgetState createState() => StartCookingWidgetState();
}

class StartCookingWidgetState extends State<StartCookingWidget> with TickerProviderStateMixin {
  RewardedAd? _rewardedAd;
  late AnimationController controller;
  late final Animation<double> _animation = CurvedAnimation(
    parent: controller,
    curve: Curves.linearToEaseOut,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat(reverse: true);
    if (kReleaseMode) {
      _createRewardedAd();
    }
  }

  Future<void> _createRewardedAd() async {
    await RewardedAd.load(
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    });
    _rewardedAd = null;
  }

  @override
  void dispose() {
    controller.dispose();
    if (kReleaseMode) {
      _showRewardedAd();
    }
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: context.width(),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: radius(defaultRadius),
        gradient: LinearGradient(
          colors: [
            Color(0xFFFCD693),
            Color(0xFFF6C455),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _animation,
            child: commonCachedNetworkImage(ChefImage, height: 60, width: 60, fit: BoxFit.cover),
          ),
          20.width,
          Text(language!.startCooking, style: boldTextStyle(size: 20)),
        ],
      ),
    ).onTap(() {
      QuickRecipeStepWidget(
        recipeStepData: widget.recipeStepData,
      ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300));
    }, highlightColor: context.cardColor).paddingOnly(left: 16, right: 16);
  }
}
