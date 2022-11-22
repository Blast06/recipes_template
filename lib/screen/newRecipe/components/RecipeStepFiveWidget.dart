import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/recipe/RecipeStepScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

import '../../../main.dart';

class RecipeStepFiveWidget extends StatefulWidget {
  final bool? mIsUpdate;

  RecipeStepFiveWidget({this.mIsUpdate});

  @override
  RecipeStepFiveWidgetState createState() => RecipeStepFiveWidgetState();
}

class RecipeStepFiveWidgetState extends State<RecipeStepFiveWidget> {
  ScrollController scrollController = ScrollController();

  int current = 1;
  int totalPage = 1;
  int mPage = 1;

  bool mIsLastPage = false;
  bool mIsUpdate = false;

  String? imageStep;

  List<RecipeStepModel> stepData = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    mIsUpdate = widget.mIsUpdate.validate();

    init();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (mIsLastPage) {
          mPage++;

          setState(() {});
        }
        init();
      }
    });
  }

  Future<void> init() async {
    appStore.setLoading(true);
    setState(() {});

    await getRecipeStepModel(page: mPage, recipeID: newRecipeModel!.id.validate()).then((value) {
      appStore.setLoading(false);
      setState(() {});
      mIsLastPage = value.data!.length != value.pagination!.per_page;

      totalPage = value.pagination!.totalPages!;
      current = value.pagination!.currentPage!;

      if (mPage == 1) {
        stepData.clear();
      }
      stepData.addAll(value.data!.reversed);

      setState(() {});
    }).catchError((error) {
      appStore.setLoading(false);
      setState(() {});
      log(error);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget getImage(RecipeStepModel e) {
    if (e.step_image_gallery!.isNotEmpty) {
      return commonCachedNetworkImage(
        e.step_image_gallery![0].url,
        fit: BoxFit.cover,
        height: 70,
        width: 70,
      ).cornerRadiusWithClipRRect(defaultRadius);
    } else {
      if (e.recipe_step_image!.isNotEmpty) {
        return commonCachedNetworkImage(
          e.recipe_step_image![0].url.validate(),
          fit: BoxFit.cover,
          height: 70,
          width: 70,
        ).cornerRadiusWithClipRRect(defaultRadius);
      } else {
        return Image.asset(
          'images/placeholder.jpg',
          fit: BoxFit.cover,
          height: 70,
          width: 70,
        ).cornerRadiusWithClipRRect(defaultRadius);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: context.cardColor,
          child: Column(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    createRecipeWidget(title: language!.step4Title, width: context.width()),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language!.steps, style: boldTextStyle()),
                        16.height,
                        Column(
                          children: stepData.map((e) {
                            int value = stepData.indexOf(e);
                            index = value + 1;
                            setState(() {});
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              width: context.width(),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: dividerColor),
                                color: context.cardColor,
                                borderRadius: BorderRadius.circular(defaultRadius),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getImage(e),
                                  8.width,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Step ${value + 1}', style: boldTextStyle(size: 20)),
                                      4.height,
                                      Text(e.description.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                                    ],
                                  ).expand()
                                ],
                              ),
                            ).onTap(() async {
                              await RecipeStepScreen(recipeStepModel: e, stepIndex: value + 1, totalStep: index).launch(context).then((value) async {
                                await init();
                                setState(() {});
                              });
                              init();
                              setState(() {});
                            }, splashColor: context.scaffoldBackgroundColor, highlightColor: context.scaffoldBackgroundColor);
                          }).toList(),
                        ),
                        16.height,
                        addStepWidget(title: language!.addAStep, context: context).onTap(() async {
                          var step = await RecipeStepScreen(totalStep: index + 1, stepIndex: index + 1).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                          if (step != null && step is RecipeStepModel) {
                            init();
                          }
                        }, highlightColor: primaryColor.withOpacity(0.1))
                      ],
                    ).paddingOnly(left: 16, right: 16)
                  ],
                ),
              ).expand(),
              AppButton(
                width: context.width(),
                color: primaryColor,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                child: Text(language!.next, style: boldTextStyle(color: white)),
                onTap: () async {
                  if (appStore.isDemoAdmin) {
                    snackBar(context, title: language!.demoUserMsg);
                  } else {
                    await showConfirmDialogCustom(
                      context,
                      primaryColor: primaryColor,
                      title: language!.recipePublish,
                      positiveText: language!.publish,
                      negativeText: language!.saveDraft,
                      onCancel: (c) async {
                        await addUpdateRecipeData(status: 0, id: newRecipeModel!.id).then((value) {
                          LiveStream().emit(streamRefreshRecipeData, '');
                          newRecipeModel = null;
                          if (mIsUpdate || isMobile) {
                            pop();
                          } else {
                            LiveStream().emit(streamRefreshRecipeIndex, '');
                          }
                        }).catchError((e) {
                          log(e);
                        });
                      },
                      onAccept: (c) async {
                        appStore.setLoading(true);
                        await addUpdateRecipeData(status: 1, id: newRecipeModel!.id).then((value) {
                          appStore.setLoading(false);
                          LiveStream().emit(streamRefreshRecipeData, '');
                          newRecipeModel = null;
                          if (mIsUpdate || isMobile) {
                            finish(context);
                          } else {
                            LiveStream().emit(streamRefreshRecipeIndex, '');
                          }
                        }).catchError((e) {
                          log(e);
                          appStore.setLoading(false);
                        });
                      },
                    );
                  }
                },
              ).paddingAll(8),
            ],
          ),
        ),
        Loader().visible(appStore.isLoader)
      ],
    );
  }
}
