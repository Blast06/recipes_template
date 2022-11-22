import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDetailModel.dart';
import 'package:recipe_app/models/RecipeRatingModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/auth/SignInScreen.dart';
import 'package:recipe_app/screen/user/ReviewScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeCommentScreen extends StatefulWidget {
  final List<RecipeRatingModel>? ratingData;
  final RecipeDetailModel? recipeDetail;

  RecipeCommentScreen({this.ratingData, this.recipeDetail});

  @override
  RecipeCommentScreenState createState() => RecipeCommentScreenState();
}

class RecipeCommentScreenState extends State<RecipeCommentScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void addComment() async {
    if (appStore.isLoggedIn) {
      await ReviewScreen(
        recipeId: widget.recipeDetail!.recipes!.id,
        recipeRatingModel: widget.recipeDetail!.user_rating,
        img: widget.recipeDetail!.recipes!.recipe_image!.isNotEmpty ? widget.recipeDetail!.recipes!.recipe_image![0].url : null,
        title: widget.recipeDetail!.recipes!.title,
        imageList: widget.recipeDetail!.recipes!.recipe_image_gallery,
        mIsLastPage: true,
      ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));
    } else {
      SignInScreen().launch(context, duration: Duration(milliseconds: 300));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : appBarWidget(language!.review, elevation: 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: FixSizedBox(
          maxWidth: kIsWeb ? null : context.width(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb) ...[
                Row(
                  children: [
                    Text(language!.comments, style: boldTextStyle(size: 24)).expand(),
                    IconButton(
                      onPressed: () {
                        addComment();
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
                Divider(),
              ],
              widget.ratingData!.isNotEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.ratingData!.map((e) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(border: Border.all(color: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.grey.shade300), borderRadius: BorderRadius.circular(defaultRadius)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !e.profile_image.isEmptyOrNull
                                  ? commonCachedNetworkImage(e.profile_image, fit: BoxFit.cover, height: 35, width: 35).cornerRadiusWithClipRRect(70)
                                  : Container(
                                      decoration: boxDecorationRoundedWithShadow(10, backgroundColor: goldenRod),
                                      height: 35,
                                      width: 35,
                                      child: Text(
                                        e.username!.substring(0, 1).toUpperCase(),
                                        style: boldTextStyle(color: white),
                                        textAlign: TextAlign.center,
                                      ).center(),
                                    ),
                              8.width,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(e.username!, style: boldTextStyle(size: 14)).expand(),
                                      RatingBarWidget(
                                        onRatingChanged: (v) {
                                          //
                                        },
                                        size: 15,
                                        rating: e.rating.toDouble(),
                                        disable: true,
                                        activeColor: primaryColor,
                                      )
                                    ],
                                  ),
                                  4.height,
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(e.review!, style: primaryTextStyle()).expand(),
                                      IconButton(
                                        onPressed: () async {
                                          await showConfirmDialogCustom(
                                            context,
                                            title: language!.doYouDeleteYourRating,
                                            primaryColor: primaryColor,
                                            positiveText: language!.delete,
                                            negativeText: language!.cancel,
                                            onAccept: (c) {
                                              Map req = {
                                                'id': e.id,
                                              };
                                              deleteRating(req).then((value) {
                                                snackBar(context, title: language!.ratingDeletedSuccessfully);
                                                finish(context);
                                              }).catchError((error) {
                                                log(error);
                                              });
                                            },
                                            dialogType: DialogType.DELETE,
                                          );
                                        },
                                        icon: Icon(Icons.delete, size: 18, color: context.iconColor),
                                      ).visible(e.user_id == appStore.userId),
                                    ],
                                  ),
                                ],
                              ).expand()
                            ],
                          ),
                        ).onTap(() async {
                          if (appStore.isLoggedIn) {
                            if (e.user_id == appStore.userId) {
                              await ReviewScreen(
                                recipeId: widget.recipeDetail!.recipes!.id,
                                recipeRatingModel: widget.recipeDetail!.user_rating,
                                img: widget.recipeDetail!.recipes!.recipe_image![0].url,
                                imageList: widget.recipeDetail!.recipes!.recipe_image_gallery,
                                title: widget.recipeDetail!.recipes!.title,
                                mIsLastPage: true,
                              ).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));
                            }
                          } else {
                            SignInScreen().launch(context, duration: Duration(milliseconds: 300));
                          }
                        }, highlightColor: Colors.transparent, hoverColor: Colors.transparent, splashColor: Colors.transparent);
                      }).toList(),
                    ).paddingOnly(bottom: 65)
                  : Container(height: context.height() * 0.7, child: EmptyWidget(title: language!.noComments)),
            ],
          ),
        ),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              backgroundColor: context.cardColor,
              child: Icon(Icons.add, color: context.iconColor),
              onPressed: () async {
                addComment();
              },
            ),
    );
  }
}
