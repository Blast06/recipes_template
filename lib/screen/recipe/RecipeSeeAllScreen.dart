import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/RecipeComponentWidget.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailMobileScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailWebScreen.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';

import '../../main.dart';

class RecipeSeeAllScreen extends StatefulWidget {
  final int spanCount;

  RecipeSeeAllScreen({this.spanCount = 2});

  @override
  RecipeSeeAllScreenState createState() => RecipeSeeAllScreenState();
}

class RecipeSeeAllScreenState extends State<RecipeSeeAllScreen> {
  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int currentPage = 1;

  bool mIsLastPage = false;
  List<RecipeModel> recipeListData = [];
  int mPage = 1;

  bool mISelect = false;

  @override
  void initState() {
    super.initState();
    LiveStream().on(streamRefreshToDo, (s) {
      init();
    });
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          appStore.setLoading(true);
          mPage++;
          setState(() {});

          init();
        }
      }
    });
  }

  Future<void> init() async {
    await 200.milliseconds.delay;
    appStore.setLoading(true);
    getRecipeListData(page: mPage, status: 1).then((value) {
      appStore.setLoading(false);
      mIsLastPage = value.data!.length != value.pagination!.per_page;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        recipeListData.clear();
      }
      recipeListData.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.latestRecipes),
      body: Stack(
        children: [
          SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 16, top: 4),
              controller: scrollController,
              child: recipeListData.isNotEmpty
                  ? Responsive(
                      useFullWidth: false,
                      tablet: Wrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: recipeListData.validate().map((e) {
                          return RecipeComponentWidget(
                            recipeModel: e,
                            spanCount: 3,
                            widgetData: IconButton(
                              padding: EdgeInsets.only(bottom: 16),
                              visualDensity: VisualDensity.compact,
                              icon: Icon(e.is_bookmark == 0 ? Icons.bookmark_border : Icons.bookmark, size: 20, color: black),
                              onPressed: () async {
                                if (appStore.isDemoAdmin) {
                                  snackBar(context, title: language!.demoUserMsg);
                                } else {
                                  if (!getBoolAsync(IS_LOGGED_IN)) {
                                    SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                                  } else {
                                    if (e.is_bookmark.validate() == 0) {
                                      e.is_bookmark = 1;
                                    } else {
                                      e.is_bookmark = 0;
                                    }
                                    setState(() {});
                                    await addBookMarkData(e.id!, context, e.is_bookmark!).then((value) {
                                      LiveStream().emit(streamRefreshBookMark, streamRefreshBookMark);
                                    }).catchError((error) {
                                      if (e.is_bookmark == 0) {
                                        e.is_bookmark = 1;
                                      } else {
                                        e.is_bookmark = 0;
                                      }

                                      setState(() {});
                                      toast(error.toString());
                                      log(error);
                                    });
                                  }
                                }
                              },
                            ).visible(appStore.isAdmin && appStore.isDemoAdmin),
                          ).onTap(() async {
                            RecipeModel? res = kIsWeb
                                ? await RecipeDetailWebScreen(recipeID: e.id, recipe: e).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300))
                                : await RecipeDetailMobileScreen(recipeID: e.id, recipe: e).launch(context);
                            if (res != null) {
                              e = res;
                              setState(() {});
                            }
                          });
                        }).toList(),
                      ).center(),
                      mobile: Wrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: recipeListData.validate().map((e) {
                          return RecipeComponentWidget(
                            recipeModel: e,
                            spanCount: 1,
                            isFromDashboard: true,
                            widgetData: IconButton(
                              padding: EdgeInsets.only(bottom: 16),
                              visualDensity: VisualDensity.compact,
                              icon: Icon(e.is_bookmark == 0 ? Icons.bookmark_border : Icons.bookmark, size: 20, color: black),
                              onPressed: () async {
                                if (appStore.isDemoAdmin) {
                                  snackBar(context, title: language!.demoUserMsg);
                                } else {
                                  if (!getBoolAsync(IS_LOGGED_IN)) {
                                    SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                                  } else {
                                    if (e.is_bookmark.validate() == 0) {
                                      e.is_bookmark = 1;
                                    } else {
                                      e.is_bookmark = 0;
                                    }
                                    setState(() {});
                                    await addBookMarkData(e.id!, context, e.is_bookmark!).then((value) {
                                      LiveStream().emit(streamRefreshBookMark, streamRefreshBookMark);
                                    }).catchError((error) {
                                      if (e.is_bookmark == 0) {
                                        e.is_bookmark = 1;
                                      } else {
                                        e.is_bookmark = 0;
                                      }

                                      setState(() {});
                                      toast(error.toString());
                                      log(error);
                                    });
                                  }
                                }
                              },
                            ).visible(!appStore.isAdmin && !appStore.isDemoAdmin),
                          ).onTap(() async {
                            RecipeModel? res = kIsWeb
                                ? await RecipeDetailWebScreen(recipeID: e.id, recipe: e).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300))
                                : await RecipeDetailMobileScreen(recipeID: e.id, recipe: e).launch(context);
                            if (res != null) {
                              e = res;
                              setState(() {});
                            }
                          });
                        }).toList(),
                      ).center(),
                      web: Wrap(
                        runSpacing: 16,
                        spacing: 16,
                        children: recipeListData.validate().map((e) {
                          return RecipeComponentWidget(
                            recipeModel: e,
                            spanCount: 5,
                            widgetData: IconButton(
                              padding: EdgeInsets.only(bottom: 16),
                              visualDensity: VisualDensity.compact,
                              icon: Icon(e.is_bookmark == 0 ? Icons.bookmark_border : Icons.bookmark, size: 20, color: black),
                              onPressed: () async {
                                if (appStore.isDemoAdmin) {
                                  snackBar(context, title: language!.demoUserMsg);
                                } else {
                                  if (!getBoolAsync(IS_LOGGED_IN)) {
                                    SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                                  } else {
                                    if (e.is_bookmark.validate() == 0) {
                                      e.is_bookmark = 1;
                                    } else {
                                      e.is_bookmark = 0;
                                    }
                                    setState(() {});
                                    await addBookMarkData(e.id!, context, e.is_bookmark!).then((value) {
                                      LiveStream().emit(streamRefreshBookMark, streamRefreshBookMark);
                                    }).catchError((error) {
                                      if (e.is_bookmark == 0) {
                                        e.is_bookmark = 1;
                                      } else {
                                        e.is_bookmark = 0;
                                      }

                                      setState(() {});
                                      toast(error.toString());
                                      log(error);
                                    });
                                  }
                                }
                              },
                            ).visible(appStore.isAdmin && appStore.isDemoAdmin),
                          ).onTap(() async {
                            RecipeModel? res = kIsWeb
                                ? await RecipeDetailWebScreen(recipeID: e.id, recipe: e).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300))
                                : await RecipeDetailMobileScreen(recipeID: e.id, recipe: e).launch(context);
                            if (res != null) {
                              e = res;
                              setState(() {});
                            }
                          });
                        }).toList(),
                      ).center(),
                    )
                  : EmptyWidget(title: language!.noDataFound).visible(appStore.isLoader)),
          Observer(builder: (_) => Loader().visible(appStore.isLoader))
        ],
      ),
    );
  }
}
