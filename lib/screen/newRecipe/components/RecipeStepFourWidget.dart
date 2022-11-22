import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/IngredientItemWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/recipe/AddIngredientScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeStepFourWidget extends StatefulWidget {
  final bool? mIsUpdate;

  RecipeStepFourWidget({this.mIsUpdate});

  @override
  RecipeStepFourWidgetState createState() => RecipeStepFourWidgetState();
}

class RecipeStepFourWidgetState extends State<RecipeStepFourWidget> {
  ScrollController scrollController = ScrollController();

  int totalPage = 1;
  int current = 1;
  int mPage = 1;

  bool mISLastPage = false;
  bool mIsUpdate = false;
  bool mIsPageLoading = false;

  List<String>? data;
  String data1 = '';

  List<RecipeIngredientsModel> ingredients = [];

  @override
  void initState() {
    super.initState();
    init();

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (mISLastPage) {
          mIsPageLoading = true;
          mPage++;

          setState(() {});
        }
        init();
      }
    });
  }

  Future<void> init() async {
    mIsPageLoading = true;
    setState(() {});

    await getIngredients(page: mPage, recipeId: newRecipeModel!.id).then((value) {
      mIsPageLoading = false;

      mISLastPage = value.data!.length != value.pagination!.per_page!;

      totalPage = value.pagination!.totalPages!;
      current = value.pagination!.currentPage!;

      if (mPage == 1) {
        ingredients.clear();
      }

      ingredients.addAll(value.data!);

      setState(() {});
    }).catchError((error) {
      mIsPageLoading = false;
      setState(() {});

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
    return Stack(
      children: [
        Container(
          color: context.cardColor,
          child: Column(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    createRecipeWidget(title: language!.step4Title, width: context.width()),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language!.addIngredient, style: boldTextStyle()),
                        16.height,
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ingredients.length,
                          itemBuilder: (_, index) => IngredientItemWidget(ingredients[index], onDelete: () {
                            mPage = 1;
                            init();
                          }),
                        ),
                        addStepWidget(title: language!.addAnIngredient, context: context).onTap(
                          () async {
                            var data = isWeb
                                ? await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: Container(
                                          height: 500,
                                          width: 500,
                                          child: AddIngredientScreen(),
                                        ),
                                      );
                                    })
                                : await AddIngredientScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                            /// Bool = Deleted
                            /// Ingredient Model = Added
                            if (data != null && data is RecipeIngredientsModel) {
                              if (!ingredients.contains(data)) {
                                ingredients.add(data);
                                init();
                              }
                            }
                          },
                          highlightColor: primaryColor.withOpacity(0.1),
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
                  if (ingredients.isEmpty) {
                    return snackBar(context, title: language!.pleaseEnterTheValue);
                  } else {
                    LiveStream().emit(streamNewRecipePageChange, 4);
                  }
                },
              ).paddingAll(8),
            ],
          ),
        ),
        Loader().visible(mIsPageLoading),
      ],
    );
  }
}
