import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/LatestRecipeWidget.dart';
import 'package:recipe_app/components/SliderWidget.dart';
import 'package:recipe_app/components/TitleWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/SettingScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeSeeAllScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> with AutomaticKeepAliveClientMixin {
  PageController pageController = PageController();

  int currentPage = 0;

  bool mISelect = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(streamRefreshToDo, (s) {
      setState(() {});
    });
    LiveStream().on(streamRefreshSlider, (s) {
      setState(() {});
    });
    LiveStream().on(streamRefreshRecipe, (s) {
      setState(() {});
    });
    LiveStream().on(streamRefreshRecipeData, (s) {
      setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(streamRefreshToDo);
    LiveStream().dispose(streamRefreshSlider);
    LiveStream().dispose(streamRefreshRecipe);
    LiveStream().dispose(streamRefreshRecipeData);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Observer(
        builder: (_) => Scaffold(
          appBar: isMobile
              ? appBarWidget(
                  mAppName,
                  titleWidget: Row(
                    children: [
                      Image.asset(appLogo, height: 40, width: 40, fit: BoxFit.cover),
                      8.width,
                      Text(mAppName, style: boldTextStyle(fontFamily: fontFamilyGloria, size: 20)),
                    ],
                  ),
                  titleTextStyle: boldTextStyle(fontFamily: fontFamilyGloria, size: 20),
                  showBack: false,
                  color: appStore.isDarkMode ? scaffoldSecondaryDark : white,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () {
                        SettingScreen()
                            .launch(
                              context,
                              pageRouteAnimation: PageRouteAnimation.SlideBottomTop,
                              duration: Duration(milliseconds: 300),
                            )
                            .then((value) => setState(() {}));
                      },
                      icon: Icon(Icons.settings, color: context.iconColor),
                    ).paddingOnly(right: 8)
                  ],
                )
              : null,
          key: PageStorageKey('Home'),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {});
              await 2.seconds.delay;

              return Future.value(true);
            },
            child: FutureBuilder<RecipeDashboardModel>(
              future: getRecipeData(),
              builder: (context, snap) {
                if (snap.hasData) {
                  if (snap.data!.latestRecipe!.isEmpty) {
                    return EmptyWidget(title: language!.noDataFound);
                  }
                  return SingleChildScrollView(
                    padding: isWeb ? EdgeInsets.only(top: 16) : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        snap.data!.slider!.isNotEmpty
                            ? Responsive(
                                mobile: SliderWidget(snap.data!.slider!, spanCount: context.width()),
                                web: SliderWidget(snap.data!.slider!, spanCount: context.width() * 0.77),
                              )
                            : Image.asset(EmptySlider, height: context.height() * 0.25, fit: BoxFit.cover),
                        16.height,
                        TitleWidget(language!.latestRecipes),
                        16.height,
                        Responsive(
                          web: LatestRecipeWidget(snap.data!.latestRecipe!, spanCount: 5),
                          tablet: LatestRecipeWidget(snap.data!.latestRecipe!, spanCount: 3),
                          mobile: LatestRecipeWidget(snap.data!.latestRecipe!, spanCount: 2),
                          useFullWidth: false,
                        ),
                        8.height,
                        Responsive(
                          web: AppButton(
                            width: context.width() * 0.5,
                            color: primaryColor,
                            text: language!.viewAll,
                            textStyle: boldTextStyle(color: white),
                            onTap: () {
                              RecipeSeeAllScreen().launch(context, duration: Duration(milliseconds: 300));
                            },
                            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                          ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
                          mobile: AppButton(
                            width: context.width(),
                            color: primaryColor,
                            text: language!.viewAll,
                            textStyle: boldTextStyle(color: white),
                            onTap: () {
                              RecipeSeeAllScreen().launch(context, duration: Duration(milliseconds: 300)).then((value) => setState(() {}));
                            },
                            shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                          ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
                        )
                      ],
                    ),
                  );
                }
                return snapWidgetHelper(snap);
              },
            ),
          ),
        ),
      ),
    );
  }
}
