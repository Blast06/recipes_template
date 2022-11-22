import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/newRecipe/components/RecipeStepFiveWidget.dart';
import 'package:recipe_app/screen/newRecipe/components/RecipeStepFourWidget.dart';
import 'package:recipe_app/screen/newRecipe/components/RecipeStepOneWidget.dart';
import 'package:recipe_app/screen/newRecipe/components/RecipeStepSecondWidget.dart';
import 'package:recipe_app/screen/newRecipe/components/RecipeStepThreeWidget.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class NewRecipeScreen extends StatefulWidget {
  final RecipeModel? recipe;

  NewRecipeScreen({this.recipe});

  @override
  NewRecipeScreenState createState() => NewRecipeScreenState();
}

class NewRecipeScreenState extends State<NewRecipeScreen> {
  PageController pageController = PageController(initialPage: 0, keepPage: true);

  List<Widget> recipeList = [];

  int currentPage = 0;

  bool mIsUpdate = false;
  bool mIsAdding = false;

  @override
  void initState() {
    mIsUpdate = widget.recipe != null;

    if (mIsUpdate) {
      newRecipeModel = widget.recipe;

      getRecipeDetailData(recipeID: widget.recipe!.id).then((value) {
        newRecipeModel = value.recipes;
        newRecipeModel!.steps = value.recipes!.steps;
      }).catchError((e) {
        toast(e.toString());
      });
    } else {
      if (newRecipeModel == null) {
        newRecipeModel = RecipeModel();
      }
    }

    super.initState();
    init();
  }

  Future<void> init() async {
    recipeList = [
      RecipeStepOneWidget(mIsUpdate: mIsUpdate),
      RecipeStepSecondWidget(mIsUpdate: mIsUpdate),
      RecipeStepThreeWidget(mIsUpdate: mIsUpdate),
      RecipeStepFourWidget(mIsUpdate: mIsUpdate),
      RecipeStepFiveWidget(mIsUpdate: mIsUpdate),
    ];

    LiveStream().on(streamNewRecipePageChange, (v) {
      pageController.jumpTo(1);

      if (currentPage == 2 && !mIsAdding) {
        mIsAdding = true;

        addRecipe();
      }

      setState(() {});
      currentPage++;
    });
  }

  Future<void> addRecipe() async {
    await addUpdateRecipeData(
      id: mIsUpdate
          ? newRecipeModel!.id
          : (newRecipeModel != null && newRecipeModel!.id != null)
              ? newRecipeModel!.id
              : -1,
      file: newRecipeModel!.recipeFile != null ? File(newRecipeModel!.recipeFile!.path.validate()) : null,
    ).then((value) {
      mIsAdding = false;

      newRecipeModel!.id = value;
    }).catchError((error) {
      mIsAdding = false;

      log('${error.toString()}');
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(streamNewRecipePageChange);
    newRecipeModel = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (newRecipeModel != null && newRecipeModel!.title.validate().isEmpty) {
          return Future.value(true);
        } else {
          if (currentPage < recipeList.length - 4) {
            return Future.value(true);
          }
          currentPage--;
          setState(() {});
          pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.linear);

          return Future.value(false);
        }
      },
      child: Scaffold(
        backgroundColor: context.scaffoldBackgroundColor,
        appBar: appBarWidget(
          mIsUpdate ? language!.recipeUpdate : language!.newRecipe,
          backWidget: isWeb
              ? IconButton(
                  onPressed: () {
                    if (currentPage > 0) {
                      currentPage--;
                      pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.linear);
                      setState(() {});
                    } else if (currentPage == 0) {
                      mIsUpdate ? finish(context) : LiveStream().emit(streamRefreshRecipeIndex);
                    }
                  },
                  icon: Icon(Icons.arrow_back, color: context.iconColor),
                )
              : null,
          elevation: 0,
          actions: [
            isWeb
                ? IconButton(
                    onPressed: () async {
                      showConfirmDialogCustom(context, title: language!.yourRecipeIsNotSavedYet, negativeText: language!.cancel, positiveText: language!.okGoBack, onAccept: (c) {
                        mIsUpdate ? finish(context) : LiveStream().emit(streamRefreshRecipeIndex);
                        newRecipeModel = null;
                        recipeFiles.clear();
                      }, dialogType: DialogType.DELETE, primaryColor: primaryColor);
                    },
                    icon: Icon(Icons.close, color: context.iconColor),
                  )
                : IconButton(
                    onPressed: () {
                      showConfirmDialogCustom(context, title: language!.yourRecipeIsNotSavedYet, negativeText: language!.cancel, positiveText: language!.okGoBack, onAccept: (c) {
                        newRecipeModel = null;
                        recipeFiles.clear();
                        finish(context);
                      }, dialogType: DialogType.DELETE, primaryColor: primaryColor);
                    },
                    icon: Icon(Icons.close, color: context.iconColor),
                  )
          ],
          bottom: PreferredSize(
            child: StepProgressIndicator(
              padding: 4,
              size: 6,
              totalSteps: recipeList.length,
              currentStep: currentPage + 1,
              selectedColor: primaryColor.withOpacity(0.5),
              unselectedColor: viewLineColor,
              roundedEdges: radiusCircular(),
            ).paddingOnly(bottom: 4),
            preferredSize: Size(context.width(), 10),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: FixSizedBox(
          maxWidth: kIsWeb ? null : context.width(),
          child: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            itemCount: recipeList.length,
            itemBuilder: (_, index) => IndexedStack(
              children: recipeList,
              index: currentPage,
            ),
          ),
        ),
      ),
    );
  }
}
