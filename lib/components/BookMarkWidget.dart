import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailMobileScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailWebScreen.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class BookMarkWidget extends StatefulWidget {
  @override
  BookMarkWidgetState createState() => BookMarkWidgetState();
}

class BookMarkWidgetState extends State<BookMarkWidget> {
  ScrollController controller = ScrollController();

  int currentPage = 1;
  int totalPage = 1;
  int mPage = 1;

  bool mIsLastPage = false;
  bool mIsLoading = false;

  List<RecipeModel> bookMarkData = [];

  @override
  void initState() {
    super.initState();
    init();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        if (!mIsLastPage) {
          mPage++;
          setState(() {});

          init();
        }
      }
    });

    LiveStream().on(streamRefreshBookMark, (s) {
      init();
    });
    LiveStream().on(streamRefreshToDo, (s) {
      init();
    });
  }

  void init() async {
    if (appStore.isLoggedIn) {
      mIsLoading = true;
      setState(() {});

      getBookMarkData(page: mPage).then((value) {
        mIsLoading = false;
        setState(() {});
        mIsLastPage = value.data!.length != value.pagination!.per_page;

        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;

        if (mPage == 1) {
          bookMarkData.clear();
        }
        bookMarkData.addAll(value.data!);

        setState(() {});
      }).catchError((error) {
        if (!error.toString().toLowerCase().contains('exception')) {
          mIsLoading = false;
          setState(() {});
          toast(error.toString());
        }
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: bookMarkData.isNotEmpty
              ? Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: bookMarkData.validate().map((e) {
                    return Container(
                      width: context.width() / 2 - 24,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          e.recipe_image_gallery.validate().isNotEmpty
                              ? commonCachedNetworkImage(
                                  e.recipe_image_gallery![0].url.validate(),
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: context.width() / 2 - 24,
                                ).cornerRadiusWithClipRRect(defaultRadius)
                              : e.recipeImageWidget(context.width() / 2 - 24),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), gradient: gradientDecoration()),
                            padding: EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(defaultRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: glassBoxDecoration(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.title.validate(),
                                            style: boldTextStyle(color: black, size: 14),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ).expand(flex: 5),
                                          Icon(Icons.bookmark, color: black, size: 20).onTap(() async {
                                            if (appStore.isDemoAdmin) {
                                              snackBar(context, title: language!.demoUserMsg);
                                            } else {
                                              if (!getBoolAsync(IS_LOGGED_IN)) {
                                                SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                                              } else {
                                                Map req = {
                                                  'user_id': appStore.userId,
                                                  'recipe_id': e.id,
                                                };
                                                await removeBookMark(req).then((value) {
                                                  init();
                                                  LiveStream().emit(streamRefreshToDo);
                                                  LiveStream().emit(streamRefreshRecipe);
                                                }).catchError((e) {
                                                  log(e);
                                                });
                                              }
                                            }
                                          }).expand(),
                                        ],
                                      ),
                                      8.height,
                                      Row(
                                        children: [
                                          Text('${stringToMin(e.preparationTime.validate())} min', style: secondaryTextStyle(color: black)).fit(),
                                          4.width,
                                          Container(width: 1, height: 15, color: black),
                                          4.width,
                                          Text(
                                            '${e.portionUnit.toString().validate()} ${e.portionType.validate()}',
                                            style: secondaryTextStyle(color: black),
                                          ).fit(),
                                        ],
                                      ).fit(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).onTap(() async {
                      kIsWeb ? await RecipeDetailWebScreen(recipeID: e.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300)) : await RecipeDetailMobileScreen(recipeID: e.id).launch(context);
                      init();
                    });
                  }).toList(),
                )
              : Container(height: context.height() * 0.6, child: EmptyWidget(title: language!.noDataFound).visible(!mIsLoading)),
        ),
        Loader().visible(mIsLoading)
      ],
    );
  }
}
