import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/DetailStepImageComponent.dart';
import 'package:recipe_app/components/StartCookingWidget.dart';
import 'package:recipe_app/components/TitleWithGlassWidget.dart';
import 'package:recipe_app/database/IngredientsDBModel.dart';
import 'package:recipe_app/database/IngredientsDataProvider.dart';
import 'package:recipe_app/database/RecipeDBModel.dart';
import 'package:recipe_app/database/RecipeDataProvider.dart';
import 'package:recipe_app/fragment/ShoppingListFragment.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDetailModel.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/PhotoViewScreen.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeCommentScreen.dart';
import 'package:recipe_app/screen/user/ReviewScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeDetailMobileScreen extends StatefulWidget {
  final int? recipeID;
  final RecipeModel? recipe;

  RecipeDetailMobileScreen({this.recipeID, this.recipe});

  static String tag = '/RecipeDetailScreen';

  @override
  RecipeDetailMobileScreenState createState() => RecipeDetailMobileScreenState();
}

class RecipeDetailMobileScreenState extends State<RecipeDetailMobileScreen> with TickerProviderStateMixin {
  RecipeDetailModel? recipeData;
  late AnimationController _controller;
  late Animation<double> _animation;

  PageController pageController = PageController();

  int currentPage = 0;

  int total = 0;
  int hours = 0;
  int minutes = 0;

  double ratingVal = 0.0;

  String? name;

  int difficultyLevel = 1;

  bool isLoading = true;
  bool isError = true;
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(streamRefreshRecipeData, (s) {
      setState(() {});
    });
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    getRecipeDetailData(recipeID: widget.recipeID).then((value) {
      isLoading = false;
      isError = false;
      recipeData = value;

      setState(() {});
    }).catchError((e) {
      isLoading = false;
      isError = true;
      errorMsg = e.toString();

      setState(() {});
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void addToShoppingClick({required bool isExist, required RecipeModel data, required String? imageUrl}) async {
    if (isExist) {
      ShoppingListFragment(mIShow: true).launch(context, duration: Duration(milliseconds: 300));
    } else {
      if (!await isRecipeExists(data.id!)) {
        RecipeDBModel dbModel = RecipeDBModel();

        dbModel.id = data.id;
        dbModel.title = data.title;
        dbModel.recipeImg = imageUrl.validate();

        dbModel.createAt = DateFormat('yyyy-MM-dd').format(DateTime.now());
        dbModel.userId = getIntAsync(USER_ID);

        await addRecipeLocalData(dbModel);

        List<IngredientsDBModel> list = [];

        data.ingredients.validate().forEach((element) {
          IngredientsDBModel model = IngredientsDBModel();

          model.ingredientId = element.id;
          model.recipeId = element.recipe_id;
          model.name = element.name;
          model.amount = element.amount;
          model.unit = element.unit;
          model.status = 0;
          model.createdAt = DateFormat('yyyy-MM-dd').format(DateTime.now());

          list.add(model);
        });

        addIngredientsLocalDB(list).then((value) {
          LiveStream().emit(streamRefreshToDo);

          toast(language!.addedShoppingList);
          setState(() {});
        }).catchError((e) {
          toast(e.toString());
        });
      }
    }
  }

  Widget favWidget(RecipeModel data) {
    return IconButton(
      onPressed: () async {
        if (appStore.isDemoAdmin) {
          snackBar(context, title: language!.demoUserMsg);
        } else {
          if (!getBoolAsync(IS_LOGGED_IN)) {
            SignInScreen().launch(context, duration: Duration(milliseconds: 300));
          } else {
            if (data.is_bookmark.validate() == 0) {
              data.is_bookmark = 1;
            } else {
              data.is_bookmark = 0;
            }
            setState(() {});
            //
            await addBookMarkData(data.id!, context, data.is_bookmark!).then((value) {
              LiveStream().emit(streamRefreshToDo);
            }).catchError((error) {
              if (data.is_bookmark == 0) {
                data.is_bookmark = 1;
              } else {
                data.is_bookmark = 0;
              }

              setState(() {});
              log(error);
            });
          }
        }
      },
      icon: Icon(data.is_bookmark == 0 ? Icons.bookmark_border : Icons.bookmark, color: primaryColor),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    setStatusBarColor(appStore.isDarkMode ? scaffoldSecondaryDark : white);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCookingTimeWidget() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          cookingTimeWidget(
            context: context,
            title: '${stringToMin(recipeData!.recipes!.preparationTime.validate())}',
            subtitle: language!.cookingPreparation,
            percentage: (60 / recipeData!.recipes!.restingTime.toInt()),
          ),
          cookingTimeWidget(
            context: context,
            title: '${stringToMin(recipeData!.recipes!.bakingTime.validate())}',
            subtitle: language!.baking,
            percentage: (60 / recipeData!.recipes!.bakingTime.toInt()),
          ),
          cookingTimeWidget(
            context: context,
            title: '${stringToMin(recipeData!.recipes!.restingTime.validate())}',
            subtitle: language!.resting,
            percentage: (60 / recipeData!.recipes!.restingTime.toInt()),
          ),
        ],
      );
    }

    Widget getImage() {
      if (recipeData!.recipes!.recipe_image_gallery.validate().isNotEmpty) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              children: recipeData!.recipes!.recipe_image_gallery.validate().map((e) {
                return Stack(
                  children: [
                    commonCachedNetworkImage(
                      e.url,
                      fit: BoxFit.cover,
                      width: context.width(),
                      height: context.height(),
                    ),
                    Container(
                      width: context.width(),
                      height: context.height() * 0.55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          tileMode: TileMode.repeated,
                        ),
                      ),
                    ).onTap(() {
                      PhotoViewScreen(imgList: recipeData!.recipes!.recipe_image_gallery.validate(), isList: true).launch(context, duration: Duration(milliseconds: 300));
                    })
                  ],
                );
              }).toList(),
            ),
            if (recipeData!.recipes!.recipe_image_gallery.validate().length > 1)
              DotIndicator(
                indicatorColor: white,
                pageController: pageController,
                pages: recipeData!.recipes!.recipe_image_gallery.validate(),
                unselectedIndicatorColor: Colors.grey,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
              ),
          ],
        );
      } else {
        if (recipeData!.recipes!.recipe_image!.isNotEmpty) {
          return commonCachedNetworkImage(
            recipeData!.recipes!.recipe_image![0].url.validate(),
            fit: BoxFit.cover,
            width: context.width(),
            height: context.height(),
          ).onTap(() {
            PhotoViewScreen(img: recipeData!.recipes!.recipe_image![0].url, isList: false).launch(context, duration: Duration(milliseconds: 300));
          });
        } else {
          return Image.asset(
            'images/placeholder.jpg',
            fit: BoxFit.cover,
            width: context.width(),
            height: context.height(),
          );
        }
      }
    }

    Widget _buildBody() {
      if (isLoading) {
        return Loader();
      } else if (isError) {
        return Text(errorMsg, style: secondaryTextStyle()).center();
      } else if (recipeData != null) {
        return NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            if (innerBoxIsScrolled) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
            return <Widget>[
              SliverAppBar(
                expandedHeight: 350,
                floating: false,
                pinned: true,
                elevation: 3,
                leading: BackButton(
                  color: appStore.isDarkMode
                      ? Colors.white
                      : innerBoxIsScrolled
                          ? Colors.black
                          : Colors.white,
                ),
                actions: [
                  if (innerBoxIsScrolled) favWidget(recipeData!.recipes!).visible(!appStore.isAdmin && !appStore.isDemoAdmin),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 50, bottom: 16, right: 50),
                  collapseMode: CollapseMode.parallax,
                  title: innerBoxIsScrolled
                      ? FadeTransition(
                          opacity: _animation,
                          alwaysIncludeSemantics: true,
                          child: Text(
                            recipeData!.recipes!.title.validate(),
                            style: boldTextStyle(size: 18),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : SizedBox.shrink(),
                  background: Stack(
                    children: [
                      getImage(),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          decoration: glassBoxDecoration().copyWith(
                            borderRadius: radius(defaultRadius),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: RatingBarWidget(
                            allowHalfRating: true,
                            rating: recipeData!.recipes!.total_rating.validate().toDouble(),
                            size: 16,
                            activeColor: black,
                            inActiveColor: Colors.black38,
                            disable: true,
                            onRatingChanged: (val) {
                              ratingVal = val;
                            },
                          ).onTap(() async {
                            if (!getBoolAsync(IS_LOGGED_IN)) {
                              SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                            } else {
                              await ReviewScreen(
                                recipeId: recipeData!.recipes!.id,
                                recipeRatingModel: recipeData!.user_rating,
                                img: recipeData!.recipes!.recipe_image![0].url,
                                imageList: recipeData!.recipes!.recipe_image_gallery,
                                title: recipeData!.recipes!.title,
                              ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));
                              init();
                            }
                          }, highlightColor: white),
                        ),
                      ),
                      if (!appStore.isAdmin && !appStore.isDemoAdmin)
                        appStore.selectedLanguageCode != 'ar'
                            ? Positioned(
                                right: 8,
                                top: 32,
                                child: favWidget(recipeData!.recipes!),
                              )
                            : Positioned(
                                left: 8,
                                top: 32,
                                child: favWidget(recipeData!.recipes!),
                              ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 16, bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipeData!.recipes!.title.validate(), style: boldTextStyle(size: 26, height: 1.2)).paddingOnly(left: 16, right: 16).expand(),
                    if (appStore.isAdmin && appStore.isDemoAdmin)
                      Row(
                        children: [
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () async {
                              if (appStore.isDemoAdmin) {
                                snackBar(context, title: language!.demoUserMsg);
                              } else {
                                if (!getBoolAsync(IS_LOGGED_IN)) {
                                  SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                                } else {
                                  if (recipeData!.recipes!.is_like == 0) {
                                    recipeData!.recipes!.is_like = 1;
                                    recipeData!.recipes!.like_count = recipeData!.recipes!.like_count! + 1;
                                  } else if (recipeData!.recipes!.is_like == 1) {
                                    recipeData!.recipes!.like_count = recipeData!.recipes!.like_count! - 1;
                                    recipeData!.recipes!.is_like = 0;
                                  }
                                  setState(() {});

                                  await addLikeDisLike(recipeData!.recipes!.id!, context, recipeData!.recipes!.is_like!).then((value) {
                                    //
                                  }).catchError((error) {
                                    if (recipeData!.recipes!.is_like != 0) {
                                      recipeData!.recipes!.is_like = 1;
                                      recipeData!.recipes!.like_count = recipeData!.recipes!.like_count! - 1;
                                    } else {
                                      recipeData!.recipes!.like_count = recipeData!.recipes!.like_count! + 1;

                                      recipeData!.recipes!.is_like = 0;
                                    }
                                    setState(() {});
                                  });
                                }
                              }
                              setState(() {});
                            },
                            icon: Icon(recipeData!.recipes!.is_like == 0 ? Icons.favorite_border : Icons.favorite, color: context.primaryColor),
                          ),
                          Text(recipeData!.recipes!.like_count.toString(), style: boldTextStyle()),
                          8.width,
                        ],
                      ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(language!.difficulty, style: boldTextStyle(size: 18)).expand(),
                            Text(" :", style: boldTextStyle(size: 18)),
                          ],
                        ).expand(flex: 2),
                        8.width,
                        Text(recipeData!.recipes!.difficulty.validate(), style: primaryTextStyle()).expand(flex: 3),
                      ],
                    ),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(language!.dishTypeData, style: boldTextStyle(size: 18)).expand(),
                            Text(" :", style: boldTextStyle(size: 18)),
                          ],
                        ).expand(flex: 2),
                        8.width,
                        Wrap(
                          children: recipeData!.recipes!.dish_type.validate().split(',').map((e) {
                            int index = recipeData!.recipes!.dish_type.validate().split(',').indexOf(e);
                            return Text(index == recipeData!.recipes!.dish_type.validate().split(',').length - 1 ? e : '$e, ', style: primaryTextStyle(), overflow: TextOverflow.ellipsis);
                          }).toList(),
                        ).expand(flex: 3),
                      ],
                    ),
                    16.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(language!.cuisineData, style: boldTextStyle(size: 18)).expand(),
                            Text(" :", style: boldTextStyle(size: 18)),
                          ],
                        ).expand(flex: 2),
                        8.width,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: recipeData!.recipes!.cuisine!.split(',').map((e) {
                            int index = recipeData!.recipes!.cuisine.validate().split(',').indexOf(e);
                            return Text(index == recipeData!.recipes!.cuisine!.split(',').length - 1 ? e : '$e, ', style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis);
                          }).toList(),
                        ).expand(flex: 3),
                      ],
                    ),
                  ],
                ).paddingAll(16),
                Divider(),
                Responsive(
                  mobile: _buildCookingTimeWidget(),
                  web: _buildCookingTimeWidget(),
                  tablet: _buildCookingTimeWidget(),
                ).paddingTop(16),
                Divider().paddingSymmetric(vertical: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language!.ingredients, style: boldTextStyle(size: 18)),
                    16.height,
                    ...recipeData!.recipes!.ingredients!.map((e) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.name.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                              Text(" :", style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ).expand(flex: 2),
                          8.width,
                          Text('${e.amount.validate()}   ${e.unit.validate()}', style: primaryTextStyle(), maxLines: 2).expand(flex: 3),
                        ],
                      ).paddingBottom(8);
                    }).toList(),
                    SnapHelperWidget<bool>(
                      future: isRecipeExists(recipeData!.recipes!.id!),
                      onSuccess: (isExist) {
                        return Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: primaryColor),
                              ),
                              child: Text(language!.remove, style: boldTextStyle()),
                              onPressed: () async {
                                showConfirmDialogCustom(
                                  context,
                                  title: language!.removeThisRecipe,
                                  primaryColor: primaryColor,
                                  dialogType: DialogType.DELETE,
                                  positiveText: language!.yes,
                                  negativeText: language!.no,
                                  onAccept: (c) {
                                    removeRecipeById(recipeData!.recipes!.id!).then((value) {
                                      LiveStream().emit(streamRefreshToDo);

                                      toast(language!.removedShoppingList);
                                      setState(() {});
                                    }).catchError((e) {
                                      toast(e.toString());
                                    });
                                  },
                                );
                              },
                            ).expand().visible(isExist),
                            16.width.visible(isExist),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: primaryColor),
                              ),
                              child: Text(isExist ? language!.view : language!.addToShoppingList, style: boldTextStyle()),
                              onPressed: () {
                                /// todo : null check
                                addToShoppingClick(
                                  data: recipeData!.recipes!,
                                  isExist: isExist,
                                  imageUrl: recipeData!.recipes!.recipe_image_gallery.validate().isNotEmpty ? recipeData!.recipes!.recipe_image_gallery![0].url : (widget.recipe!.recipe_image!.isNotEmpty ? widget.recipe!.recipe_image![0].url : null),
                                );
                              },
                            ).expand()
                          ],
                        ).paddingTop(32);
                      },
                      loadingWidget: SizedBox(),
                      errorWidget: SizedBox(),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
                Divider(),
                16.height,
                if (isMobile) StartCookingWidget(recipeStepData: recipeData!.steps).paddingBottom(16),
                ...recipeData!.steps.validate().map((e) {
                  int index = recipeData!.steps!.indexOf(e);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// todo : null check
                      TitleWithGlassWidget('${language!.step} ${index + 1}/${recipeData!.steps!.length}'),
                      e.step_image_gallery!.isNotEmpty
                          ? DetailStepImageComponent(imageList: e.step_image_gallery.validate())
                          : e.recipe_step_image!.isNotEmpty
                              ? commonCachedNetworkImage(
                                  e.recipe_step_image![0].url,
                                  width: context.width(),
                                  fit: BoxFit.cover,
                                  height: 310,
                                ).onTap(() {
                                  PhotoViewScreen(img: e.recipe_step_image![0].url, isList: false).launch(context, duration: Duration(milliseconds: 300));
                                })
                              : Offstage(),
                      16.height,
                      Text(e.description.validate(), style: primaryTextStyle()).paddingOnly(left: 16, right: 16, bottom: 8),
                      if (e.utensil!.isEmpty) Divider(color: grey),
                      e.utensil!.isEmpty ? SizedBox() : 16.height,
                      e.utensil!.isEmpty ? SizedBox() : Text(language!.utensil, style: boldTextStyle()).paddingOnly(left: 16),
                      16.height,
                      Container(
                        margin: EdgeInsets.only(left: 8, right: 8, bottom: 16),
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Wrap(
                          children: e.utensil!.map((i) {
                            return Text(e.utensil!.length - 1 == e.utensil!.indexOf(i) ? '${i.name!.validate()}' : '${i.name!.validate()} - ', style: primaryTextStyle());
                          }).toList(),
                        ),
                      )
                    ],
                  );
                }).toList(),
                AppButton(
                  width: context.width(),
                  text: language!.viewComments + " " + language!.review,
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  onTap: () async {
                    await RecipeCommentScreen(ratingData: recipeData!.rating, recipeDetail: recipeData).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));
                    init();
                  },
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                ).paddingSymmetric(horizontal: 16)
              ],
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (widget.recipe != null) {
          finish(context, widget.recipe!);
          return true;
        } else {
          finish(context);
          return true;
        }
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }
}
