import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/LatestRecipeWidget.dart';
import 'package:recipe_app/components/SliderWidget.dart';
import 'package:recipe_app/components/TitleWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/SettingScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

class HomeFragmentNew extends StatefulWidget {
  @override
  HomeFragmentNewState createState() => HomeFragmentNewState();
}

class HomeFragmentNewState extends State<HomeFragmentNew> with AutomaticKeepAliveClientMixin {
  PageController pageController = PageController();

  ScrollController scrollController = ScrollController();

  Future<List<RecipeModel>>? future;

  List<RecipeModel> recipeList = [];

  int page = 2;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

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
    init();
  }

  Future<void> init() async {
    future = getRecipeListDataDashboard(page, status: '1', recipeList: recipeList, perPage: 10, lastPageCallback: (c) {
      isLastPage = c;
      appStore.setLoading(false);
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
            child: Stack(
              children: [
                FutureBuilder<RecipeDashboardModel>(
                  future: getRecipeData(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      if (snap.data!.latestRecipe!.isEmpty) {
                        return EmptyWidget(title: language!.noDataFound);
                      }
                      return AnimatedScrollView(
                        controller: scrollController,
                        onNextPage: () {
                          if (!isLastPage) {
                            appStore.setLoading(true);
                            page++;
                            init();
                            setState(() {});
                          }
                        },
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: isWeb ? EdgeInsets.only(top: 16) : null,
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
                            web: LatestRecipeWidget(snap.data!.latestRecipe!, spanCount: 5, isFromDashboard: true),
                            tablet: LatestRecipeWidget(snap.data!.latestRecipe!, spanCount: 3, isFromDashboard: true),
                            mobile: LatestRecipeWidget(snap.data!.latestRecipe!, spanCount: 1, isFromDashboard: true),
                            useFullWidth: false,
                          ),
                          FutureBuilder<List<RecipeModel>>(
                            future: future,
                            builder: (context, snap) {
                              if (snap.hasData) {
                                if (snap.data == null) {
                                  return EmptyWidget(title: language!.noDataFound).visible(appStore.isLoader);
                                }
                                return Responsive(
                                  web: LatestRecipeWidget(snap.data!, spanCount: 5, isFromDashboard: true),
                                  tablet: LatestRecipeWidget(snap.data!, spanCount: 3, isFromDashboard: true),
                                  mobile: LatestRecipeWidget(snap.data!, spanCount: 1, isFromDashboard: true),
                                  useFullWidth: false,
                                ).paddingOnly(left: 0, right: 0, bottom: 0, top: 16);
                              }
                              return snapWidgetHelper(snap, loadingWidget: Loader(color: primaryColor).center());
                            },
                          ),
                        ],
                      );
                    }
                    return snapWidgetHelper(snap);
                  },
                ),
                Loader().visible(appStore.isLoader),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
