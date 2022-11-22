import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/RecipeCuisineWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/admin/RecipeAddTypeScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeStepThreeWidget extends StatefulWidget {
  final bool? mIsUpdate;

  RecipeStepThreeWidget({this.mIsUpdate});

  @override
  RecipeStepThreeWidgetState createState() => RecipeStepThreeWidgetState();
}

class RecipeStepThreeWidgetState extends State<RecipeStepThreeWidget> {
  TextEditingController dishController = TextEditingController();
  TextEditingController cuisineController = TextEditingController();

  bool mIsUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.mIsUpdate.validate();
    if (mIsUpdate) {
      dishController.text = newRecipeModel!.dish_type.validate();
      cuisineController.text = newRecipeModel!.cuisine.validate();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.cardColor,
      height: context.height(),
      width: context.width(),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                createRecipeWidget(title: language!.step3Title, width: context.width()),
                16.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language!.dishType, style: boldTextStyle()),
                    AppTextField(
                      controller: dishController,
                      textFieldType: TextFieldType.OTHER,
                      decoration: inputDecorationRecipe(context, hintTextName: language!.egBreakfast),
                      autoFocus: false,
                      readOnly: true,
                      onTap: () async {
                        List<String>? list = [];
                        if (dishController.text.isNotEmpty) list = dishController.text.split(',');
                        list = isWeb
                            ? await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Container(
                                      height: 500,
                                      width: 500,
                                      child: RecipeAddTypeScreen(typeList: list),
                                    ),
                                  );
                                },
                              )
                            : await RecipeAddTypeScreen(typeList: list).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                        if (list.validate().isNotEmpty) {
                          String dishType = '';
                          for (var i in list!) {
                            if (dishType.isEmpty) {
                              dishType = i + ',';
                            } else {
                              dishType = dishType + i + ',';
                            }
                          }

                          dishType = dishType.substring(0, dishType.length - 1);
                          dishController.text = dishType;
                          newRecipeModel!.dish_type = dishType;

                          setState(() {});
                        }
                      },
                    ),
                    32.height,
                    Text(language!.cuisine, style: boldTextStyle()),
                    AppTextField(
                      controller: cuisineController,
                      textFieldType: TextFieldType.OTHER,
                      decoration: inputDecorationRecipe(context, hintTextName: language!.egChinese),
                      autoFocus: false,
                      readOnly: true,
                      onTap: () async {
                        List<String>? list1 = [];
                        if (cuisineController.text.isNotEmpty) list1 = cuisineController.text.split(',');
                        list1 = isWeb
                            ? await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Container(
                                      height: 500,
                                      width: 500,
                                      child: RecipeCuisineWidget(cuisineList: list1),
                                    ),
                                  );
                                })
                            : await RecipeCuisineWidget(cuisineList: list1).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                        if (list1 != null) {
                          String cuisine = '';
                          for (var i in list1) {
                            if (cuisine.isEmpty) {
                              cuisine = i + ',';
                            } else {
                              cuisine = cuisine + i + ',';
                            }
                          }
                          cuisine = cuisine.substring(0, cuisine.length - 1);
                          cuisineController.text = cuisine;
                          newRecipeModel!.cuisine = cuisine;
                          setState(() {});
                        }
                      },
                    ),
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
            onTap: () {
              if (dishController.text.trim().isEmpty) {
                return snackBar(context, title: language!.pleaseEnterDishType);
              } else if (cuisineController.text.trim().isEmpty) {
                return snackBar(context, title: language!.pleaseEnterCuisine);
              } else {
                LiveStream().emit(streamNewRecipePageChange, 3);
              }
            },
          ).paddingAll(8),
        ],
      ),
    );
  }
}
