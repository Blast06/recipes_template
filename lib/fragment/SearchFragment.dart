import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/RecipeComponentWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/filter/filter_screen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailMobileScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailWebScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class SearchFragment extends StatefulWidget {
  final int spanCount;

  SearchFragment({this.spanCount = 2});

  @override
  SearchFragmentState createState() => SearchFragmentState();
}

class SearchFragmentState extends State<SearchFragment> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  Timer? searchDelayTime;

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  bool mISLastPage = false;

  List<RecipeModel> recipeSearch = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mISLastPage) {
          mPage++;

          init();
        }
      }
    });
    LiveStream().on(streamRefreshToDo, (v) {
      init();
    });
    setState(() {});
  }

  Future<void> init() async {
    Map<String, dynamic> req = {
      'status': 1,
      'dish_type': filterStore.dishTypeNameList.isNotEmpty ? filterStore.dishTypeNameList.join(',') : "",
      'cuisine': filterStore.cuisineNameList.isNotEmpty ? filterStore.cuisineNameList.join(',') : "",
      'keyword': searchController.text.trim().toLowerCase(),
      'user_id': appStore.userId,
    };
    appStore.setLoading(true);

    recipeSearchData(page: mPage, req: req).then((value) {
      appStore.setLoading(false);
      mISLastPage = value.data!.length != value.pagination!.per_page;

      totalPage = value.pagination!.totalPages!;
      currentPage = value.pagination!.currentPage!;

      if (mPage == 1) {
        recipeSearch.clear();
      }

      recipeSearch.addAll(value.data.validate());

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      log(e.toString());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    LiveStream().dispose(streamRefreshToDo);

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBarWidget(
          '',
          showBack: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: Container(
              width: isWeb ? context.width() : null,
              margin: EdgeInsets.only(top: 0, bottom: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                color: context.cardColor,
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              child: TextField(
                style: primaryTextStyle(),
                autofocus: false,
                controller: searchController,
                decoration: buildInputDecoration(
                  language!.recipeSearch,
                  prefixIcon: Icon(Icons.search, color: context.iconColor),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.filter_alt_outlined),
                    onPressed: () async {
                      bool? res = await FilterScreen().launch(context);
                      if (res ?? false) {
                        init();
                      } else {
                        recipeSearch = [];
                        setState(() {});
                      }
                    },
                  ),
                ),
                textAlign: TextAlign.start,
                maxLines: 1,
                maxLength: 20,
                onChanged: (val) {
                  if (searchDelayTime == null) {
                    searchDelayTime = Timer(1.seconds, () {
                      mPage = 1;
                      init();

                      appStore.setLoading(true);

                      searchDelayTime = null;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                setState(() {});
                await 2.seconds.delay;

                init();
                return Future.value(true);
              },
              child: recipeSearch.isNotEmpty
                  ? SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          runSpacing: 16,
                          spacing: 16,
                          children: recipeSearch.validate().map((e) {
                            return RecipeComponentWidget(
                              recipeModel: e,
                              spanCount: widget.spanCount,
                              widgetData: IconButton(
                                padding: EdgeInsets.only(bottom: 16),
                                icon: Icon(
                                  e.is_bookmark == 0 ? Icons.bookmark_border_rounded : Icons.bookmark,
                                  color: black,
                                  size: 20,
                                ),
                                visualDensity: VisualDensity.compact,
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

                                      addBookMarkData(e.id!, context, e.is_bookmark!).then((value) {
                                        LiveStream().emit(streamRefreshBookMark, streamRefreshBookMark);
                                      }).catchError((error) {
                                        if (e.is_bookmark == 0) {
                                          e.is_bookmark = 1;
                                        } else {
                                          e.is_bookmark = 0;
                                        }

                                        setState(() {});
                                        toast(error.toString());
                                      });
                                    }
                                  }
                                },
                              ).visible(!appStore.isAdmin && !appStore.isDemoAdmin),
                            ).onTap(() async {
                              hideKeyboard(context);
                              RecipeModel? res = kIsWeb
                                  ? await RecipeDetailWebScreen(
                                      recipeID: e.id,
                                      recipe: e,
                                    ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300))
                                  : await RecipeDetailMobileScreen(recipeID: e.id, recipe: e)
                                      .launch(
                                      context,
                                      pageRouteAnimation: PageRouteAnimation.Slide,
                                      duration: Duration(milliseconds: 300),
                                    )
                                      .then((value) {
                                      init();
                                      setState(() {});
                                    });
                              if (res != null) {
                                e = res;
                                setState(() {});
                              }
                            });
                          }).toList(),
                        ),
                      ),
                    )
                  : Observer(
                      builder: (context) => EmptyWidget(title: language!.noDataFound).visible(!appStore.isLoader),
                    ),
            ),
            Observer(builder: (context) => Loader().visible(appStore.isLoader)),
          ],
        ),
      ),
    );
  }
}
