import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeComponentWidget extends StatefulWidget {
  final RecipeModel? recipeModel;
  final Widget? widgetData;
  final int spanCount;
  final bool isFromDashboard;

  RecipeComponentWidget({this.recipeModel, this.widgetData, this.spanCount = 2, this.isFromDashboard = false});

  @override
  RecipeComponentWidgetState createState() => RecipeComponentWidgetState();
}

class RecipeComponentWidgetState extends State<RecipeComponentWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFromDashboard) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    commonCachedNetworkImage(
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      widget.recipeModel!.user_profile_image.validate(),
                    ).cornerRadiusWithClipRRect(30),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.recipeModel!.user_name.validate()}", style: boldTextStyle()),
                        2.height,
                        Text(DateTime.parse(widget.recipeModel!.created_at.validate()).timeAgo, style: secondaryTextStyle(size: 12)),
                      ],
                    ).expand(),
                    widget.widgetData.paddingTop(16),
                  ],
                ).paddingSymmetric(horizontal: 16),
                8.height,
                widget.recipeModel!.recipe_image_gallery.validate().isNotEmpty
                    ? Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          commonCachedNetworkImage(
                            widget.recipeModel!.recipe_image_gallery.validate().first.url.validate(),
                            fit: BoxFit.cover,
                            height: 350,
                            radius: 0,
                            width: context.width(),
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), gradient: gradientDecoration()),
                            width: context.width(),
                            padding: EdgeInsets.all(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(defaultRadius),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: glassBoxDecoration(),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          8.width,
                                          Text(
                                            "${widget.recipeModel!.title.validate()}",
                                            style: boldTextStyle(color: black, size: 18),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ).expand(),
                                          16.width,
                                          RatingBarWidget(
                                            onRatingChanged: null,
                                            disable: true,
                                            size: 16,
                                            activeColor: black,
                                            inActiveColor: Colors.black38,
                                            rating: widget.recipeModel!.total_rating.validate().toDouble(),
                                          )
                                        ],
                                      ),
                                      16.height,
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          8.width,
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              iconWidget(icon: Icons.favorite_border, countText: widget.recipeModel!.like_count.toString()),
                                              16.width,
                                              iconWidget(icon: Icons.rate_review_outlined, countText: widget.recipeModel!.total_review.toString()),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : widget.recipeModel!.recipeImageWidget(context.width()),
                16.height,
                Wrap(
                  runSpacing: 16,
                  spacing: 8,
                  children: [
                    recipeContainWidget(
                      context,
                      recipeDataText: '${stringToMin(widget.recipeModel!.preparationTime.validate())} min',
                      recipeDetailImage: "images/ic_timer.png",
                    ),
                    recipeContainWidget(
                      context,
                      recipeDataText: '${widget.recipeModel!.portionUnit.toString().validate()} ${widget.recipeModel!.portionType.validate()}',
                      recipeDetailImage: "images/ic_user.png",
                    ),
                    recipeContainWidget(
                      context,
                      recipeDataText: '${widget.recipeModel!.cuisine.validate()}',
                      recipeDetailImage: "images/ic_cuisine.png",
                    ),
                    recipeContainWidget(
                      context,
                      recipeDataText: '${widget.recipeModel!.dish_type.validate()}',
                      recipeDetailImage: "images/ic_dish.png",
                    ),
                  ],
                ),
                16.height,
              ],
            ),
          ),
          Divider(height: 0),
        ],
      );
    }
    return Container(
      width: context.width() / widget.spanCount - 24,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.recipeModel!.recipe_image_gallery.validate().isNotEmpty
              ? commonCachedNetworkImage(
                  widget.recipeModel!.recipe_image_gallery![0].url,
                  fit: BoxFit.cover,
                  height: 200,
                  width: context.width() / widget.spanCount - 24,
                ).cornerRadiusWithClipRRect(defaultRadius)
              : widget.recipeModel!.recipeImageWidget(context.width() / 2 - 24),
          Container(
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
                            widget.recipeModel!.title.validate(),
                            style: boldTextStyle(color: black, size: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ).expand(flex: 4),
                          widget.widgetData.expand(),
                        ],
                      ),
                      8.height,
                      Row(
                        children: [
                          Text('${stringToMin(widget.recipeModel!.preparationTime.validate())} min', style: secondaryTextStyle(color: black)).fit(),
                          4.width,
                          Container(width: 1, height: 15, color: Colors.grey),
                          4.width,
                          Text(
                            '${widget.recipeModel!.portionUnit.toString().validate()} ${widget.recipeModel!.portionType.validate()}',
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
    );
  }
}
