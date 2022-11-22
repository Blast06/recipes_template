import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/IngredientSpecialUseWidget.dart';
import 'package:recipe_app/components/IngredientsUnitWidget.dart';
import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/models/RecipeStaticModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

import '../../main.dart';

class AddIngredientScreen extends StatefulWidget {
  final RecipeIngredientsModel? recipeIngredientsModel;

  AddIngredientScreen({this.recipeIngredientsModel});

  @override
  AddIngredientScreenState createState() => AddIngredientScreenState();
}

class AddIngredientScreenState extends State<AddIngredientScreen> {
  ScrollController scrollController = ScrollController();

  RecipeIngredientsModel ingredientsModel = RecipeIngredientsModel();

  TextEditingController ingredientController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController specialController = TextEditingController();

  FocusNode ingredientNode = FocusNode();

  int totalPage = 1;
  int currentPage = 1;
  int mPage = 1;

  bool mIsLastPage = false;
  bool mIsUpdate = false;

  bool mIsSearching = false;
  bool mIsSearchListVisible = false;

  String unit = 'g';
  String specialUseValue = 'for breading';

  List<CuisineData> list = [];
  List<CuisineData> items = [];

  @override
  void initState() {
    super.initState();
    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!mIsLastPage) {
          appStore.setLoading(true);
          mPage++;

          init();
        }
      }
    });
  }

  Future<void> init() async {
    mIsUpdate = widget.recipeIngredientsModel != null;
    if (mIsUpdate) {
      ingredientController.text = widget.recipeIngredientsModel!.name.validate();
      amountController.text = widget.recipeIngredientsModel!.amount.validate();
      unitController.text = widget.recipeIngredientsModel!.unit.validate();
      specialController.text = widget.recipeIngredientsModel!.special_use.validate();

      setState(() {});
    }

    afterBuildCreated(() {
      addCuisineData(page: mPage, type: RecipeTypeIngredients, keyword: '').then((value) {
        appStore.setLoading(false);
        mIsLastPage = value.data!.length != value.pagination!.per_page;

        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;

        if (mPage == 1) {
          list.clear();
        }
        list.addAll(value.data!);

        setState(() {});
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    });
  }

  Future<void> filterSearchResults() async {
    addCuisineData(keyword: ingredientController.text.trim(), type: RecipeTypeIngredients).then((value) {
      List<CuisineData> dummySearchList = [];
      dummySearchList.addAll(value.data!);
      if (ingredientController.text.trim().isNotEmpty) {
        List<CuisineData> dummyListData = [];
        dummySearchList.forEach((item) {
          if (item.label!.toLowerCase().contains(ingredientController.text.trim().toLowerCase())) {
            dummyListData.add(item);
          }
        });
        setState(() {
          items.clear();
          items.addAll(dummyListData);
        });
      } else {
        setState(() {
          items.clear();
          items.addAll(list);
        });
      }
    }).catchError((error) {
      log(error.toString());
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
      appBar: appBarWidget(
        mIsUpdate ? language!.updateIngredients : language!.addIngredient,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await showConfirmDialogCustom(context, primaryColor: primaryColor, positiveText: language!.delete, negativeText: language!.cancel, dialogType: DialogType.DELETE, title: language!.deleteThisIngredient, onAccept: (c) {
                appStore.setLoading(true);
                Map req = {
                  'id': widget.recipeIngredientsModel!.id,
                };
                deleteIngredients(req).then((value) {
                  snackBar(context, title: language!.recipeDeleted);
                  finish(context, true);
                }).catchError(
                  (error) {
                    toast(error);
                  },
                );
              });
              appStore.setLoading(false);
            },
            icon: Icon(Icons.delete, color: context.iconColor).visible(mIsUpdate),
          ).visible(widget.recipeIngredientsModel?.id.validate() != 0),
          IconButton(
            onPressed: () async {
              mIsSearching = false;
              mIsSearchListVisible = true;

              if (ingredientController.text.isEmpty) {
                context.requestFocus(ingredientNode);
              }

              setState(() {});

              int id = 0;
              if (mIsUpdate) {
                id = widget.recipeIngredientsModel!.id.validate();
              } else {
                id = 0;
              }

              ingredientsModel = RecipeIngredientsModel();

              if (amountController.text.isEmpty) {
                snackBar(context, title: language!.pleaseEnterIngredientAmount);
              } else if (unitController.text.isEmpty) {
                snackBar(context, title: language!.pleaseEnterIngredientUnit);
              } else {
                appStore.setLoading(true);

                ingredientsModel
                  ..id = id
                  ..name = ingredientController.text.trim()
                  ..amount = amountController.text.trim()
                  ..unit = unitController.text.trim()
                  ..recipe_id = newRecipeModel!.id
                  ..special_use = specialController.text.trim();
              }

              await addIngredients(ingredientsModel.toJson()).then((value) {
                ingredientsModel.id = value.ingredientId.validate();
                finish(context, ingredientsModel);
                snackBar(context, title: mIsUpdate ? language!.ingredientUpdate : language!.recipeSaved);
              }).catchError((error) {
                log(error);
              });
              appStore.setLoading(false);
            },
            icon: Icon(Icons.done, color: context.iconColor),
          )
        ],
        backWidget: CloseButton(color: context.iconColor),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language!.ingredients, style: boldTextStyle()),
                AppTextField(
                  controller: ingredientController,
                  maxLength: 55,
                  focus: ingredientNode,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecorationRecipe(context, hintTextName: language!.egFlourAndIngredients),
                  onTap: () {
                    mIsSearching = true;
                    mIsSearchListVisible = false;
                    if (mIsUpdate) {
                      mIsSearching = true;
                      setState(() {});
                    }
                  },
                  onChanged: (val) {
                    filterSearchResults();
                  },
                  onFieldSubmitted: (val) {
                    mIsSearching = false;
                    mIsSearchListVisible = true;

                    if (ingredientController.text.isEmpty) {
                      context.requestFocus(ingredientNode);
                    }

                    setState(() {});
                  },
                ),
                16.height,
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      child: Text(list[index].label ?? '', style: primaryTextStyle()),
                    ).onTap(
                      () {
                        ingredientController.text = list[index].label!;

                        mIsSearching = false;
                        mIsSearchListVisible = true;

                        hideKeyboard(context);
                        setState(() {});
                      },
                    );
                  },
                ).visible(!mIsSearchListVisible),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(language!.amount, style: boldTextStyle()),
                            AppTextField(
                              textAlign: TextAlign.center,
                              controller: amountController,
                              textFieldType: TextFieldType.PHONE,
                              decoration: inputDecorationRecipe(context, hintTextName: language!.eg52),
                              maxLength: 5,
                            ),
                          ],
                        ).expand(),
                        16.width,
                        Column(
                          children: [
                            Text(language!.unit, style: boldTextStyle()),
                            AppTextField(
                              textAlign: TextAlign.center,
                              controller: unitController,
                              readOnly: true,
                              textFieldType: TextFieldType.OTHER,
                              decoration: inputDecorationRecipe(context, hintTextName: language!.egCapsule),
                              onTap: () async {
                                String? unitType = isWeb
                                    ? await showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            content: Container(
                                              height: 300,
                                              width: 300,
                                              child: IngredientsUnitWidget(selectValueData: unitController.text),
                                            ),
                                          );
                                        })
                                    : await showModalBottomSheet(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(defaultRadius))),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return IngredientsUnitWidget(selectValueData: unitController.text);
                                        },
                                      );
                                if (unitType != null) {
                                  unit = unitType;
                                  unitController.text = unit;
                                  setState(() {});
                                }
                              },
                            ).paddingOnly(bottom: 22),
                          ],
                        ).expand(),
                      ],
                    ),
                    16.height,
                    Text(language!.specialUse, style: boldTextStyle()),
                    AppTextField(
                      readOnly: true,
                      controller: specialController,
                      textFieldType: TextFieldType.OTHER,
                      decoration: inputDecorationRecipe(context, hintTextName: language!.addIngredientFlour),
                      onTap: () async {
                        String? specialUse = isWeb
                            ? await showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: Container(
                                      height: 300,
                                      width: 300,
                                      child: IngredientSpecialUseWidget(specialUseValueData: specialController.text),
                                    ),
                                  );
                                })
                            : await showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return IngredientSpecialUseWidget(specialUseValueData: specialController.text);
                                },
                              );
                        if (specialUse != null) {
                          specialUseValue = specialUse;
                          specialController.text = specialUseValue;
                          setState(() {});
                        } else {
                          SizedBox();
                        }
                      },
                    ),
                  ],
                ).visible((!mIsSearching && mIsSearchListVisible) || mIsUpdate && !mIsSearching),
              ],
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader))
        ],
      ),
    );
  }
}
