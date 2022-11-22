import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/BuildImageWidget.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/components/StepIngredientsWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/models/RecipeUtensilsModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/recipe/AddUtensilScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

// ignore: must_be_immutable
class RecipeStepScreen extends StatefulWidget {
  final int? totalStep;
  final int? stepIndex;
  RecipeStepModel? recipeStepModel;

  RecipeStepScreen({this.totalStep, this.recipeStepModel, this.stepIndex});

  @override
  RecipeStepScreenState createState() => RecipeStepScreenState();
}

class RecipeStepScreenState extends State<RecipeStepScreen> {
  TextEditingController ingredientsUseController = TextEditingController();
  TextEditingController stepDescriptionController = TextEditingController();

  PageController pageController = PageController();

  int currentPage = 0;

  String? stepImage;
  String? stepImageID;

  bool mISUpdate = false;

  String ingredientUsedId = '';
  List<StepUtensil> utensilData = [];

  List<RecipeUtensilsModel> utensilData1 = [];
  List<File>? stepImageFiles = [];

  RecipeStepModel? recipeStepModel;
  String? recipeStepImageWeb;
  XFile? image;
  Uint8List? recipeStepWeb;

  List<Uint8List> recipeImageList = [];

  List<ImageModel>? imageList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mISUpdate = widget.recipeStepModel != null;

    if (mISUpdate) {
      stepDescriptionController.text = widget.recipeStepModel!.description.validate();
      utensilData = widget.recipeStepModel!.utensil.validate();

      if (widget.recipeStepModel!.recipe_step_image!.isNotEmpty) {
        stepImageID = widget.recipeStepModel!.recipe_step_image![0].id.validate().toString();
        stepImage = widget.recipeStepModel!.recipe_step_image![0].url.validate();
        recipeStepImageWeb = widget.recipeStepModel!.recipe_step_image![0].url.validate();
        setState(() {});
      }

      List<String> ingredientsList = widget.recipeStepModel!.ingredient_used_id.validate().split(',');

      String ingredients = '';
      newRecipeModel!.ingredients.validate().forEach((element) {
        if (ingredientsList.contains(widget.recipeStepModel!.ingredient_used_id.validate())) {
          if (ingredients.isEmpty) {
            ingredients = element.name.validate();
          } else {
            ingredients += ', ${element.name.validate()}';
          }
        }
      });
      log(ingredients);

      ingredientsUseController.text = ingredients;
    } else {
      widget.recipeStepModel = RecipeStepModel();
    }
  }

  Future getImage() async {
    if (isWeb) {
      getImageWeb();
    } else {
      image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (image != null) {
        widget.recipeStepModel!.stepImage = File(image!.path);
        setState(() {});
      }
    }
  }

  void getImageWeb() async {
    xFileImage = await ImagePicker().pickMultiImage();

    if (xFileImage != null) {
      xFileImage!.forEach((element) async {
        recipeImageList.add(await element.readAsBytes());
      });
    }

    setState(() {});
  }

  recipeImageWidget() {
    if (xFileImage != null && !mISUpdate) {
      return Container(
        height: context.height() * 0.4,
        width: context.width(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              children: xFileImage!.map((e) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.network(e.path, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                    IconButton(
                      onPressed: () {
                        xFileImage!.remove(e);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete, color: context.iconColor),
                    ),
                  ],
                );
              }).toList(),
            ),
            DotIndicator(
              indicatorColor: white,
              pageController: pageController,
              pages: xFileImage.validate(),
              unselectedIndicatorColor: Colors.black12,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ],
        ),
      ).onTap(() async {
        getImage();
        setState(() {});
      });
    } else {
      if (mISUpdate) {
        if (widget.recipeStepModel!.step_image_gallery.validate().isNotEmpty) {
          return Container(
            height: context.height() * 0.4,
            width: context.width(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  controller: pageController,
                  children: [
                    ...widget.recipeStepModel!.step_image_gallery!.map((e) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          commonCachedNetworkImage(e.url, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                          IconButton(
                              onPressed: () {
                                showConfirmDialogCustom(
                                  context,
                                  dialogType: DialogType.DELETE,
                                  title: language!.deleteImageTitle,
                                  onAccept: (context) {
                                    finish(context);

                                    Map req = {'id': e.id, 'type': Types.step_image_gallery};

                                    appStore.setLoading(true);
                                    deleteRecipeImage(req).then((value) {
                                      toast(language!.deletedRecipeSuccessfully);
                                      // snackBar(context, title: language!.deletedRecipeSuccessfully);
                                      appStore.setLoading(false);
                                    }).catchError((error) {
                                      log(error);
                                      appStore.setLoading(false);
                                    });
                                  },
                                );
                              },
                              icon: Icon(Icons.delete, color: context.iconColor))
                        ],
                      );
                    }).toList(),
                    if (xFileImage.validate().isNotEmpty)
                      ...xFileImage!.map((e) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.network(e.path, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                            IconButton(
                              onPressed: () {
                                xFileImage!.remove(e);
                                setState(() {});
                              },
                              icon: Icon(Icons.delete, color: context.iconColor),
                            ),
                          ],
                        );
                      }).toList(),
                  ],
                ),
                DotIndicator(
                  indicatorColor: white,
                  pageController: pageController,
                  pages: [...widget.recipeStepModel!.step_image_gallery.validate(), ...xFileImage.validate()],
                  unselectedIndicatorColor: Colors.black12,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
              ],
            ),
          ).onTap(() async {
            getImage();
            setState(() {});
          });
        } else if (recipeStepImageWeb!.isNotEmpty) {
          if (xFileImage.validate().isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                commonCachedNetworkImage(recipeStepImageWeb.validate(), fit: BoxFit.cover, height: 150, width: 150).cornerRadiusWithClipRRect(defaultRadius),
                8.height,
                TextButton(
                  onPressed: () async {
                    getImage();
                  },
                  child: Text(language!.changeImage),
                )
              ],
            );
          } else {
            return Container(
              height: context.height() * 0.4,
              width: context.width(),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView(
                    controller: pageController,
                    children: xFileImage!.map((e) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.network(e.path, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                          IconButton(
                            onPressed: () {
                              xFileImage!.remove(e);
                              setState(() {});
                            },
                            icon: Icon(Icons.delete, color: context.iconColor),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  DotIndicator(
                    indicatorColor: white,
                    pageController: pageController,
                    pages: xFileImage.validate(),
                    unselectedIndicatorColor: Colors.black12,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                  ),
                ],
              ),
            ).onTap(() async {
              getImage();
              setState(() {});
            });
          }
        }
      } else {
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: primaryColor),
                backgroundColor: Color(0xFFFAF5F0),
                borderRadius: radius(defaultRadius),
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt_outlined, size: 26, color: primaryColor),
                  16.height,
                  Text(
                    'Upload a photo for \n this step',
                    style: primaryTextStyle(size: 14, color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).onTap(() {
                getImage();
              }),
            ),
          ],
        );
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        'Step ${widget.stepIndex} of ${widget.totalStep}',
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await showConfirmDialogCustom(context, title: language!.deleteThisStep, positiveText: language!.delete, negativeText: language!.cancel, dialogType: DialogType.DELETE, primaryColor: primaryColor, onAccept: (x) {
                Map req = {
                  'id': widget.recipeStepModel!.id,
                };

                deleteStep(req).then((value) {
                  snackBar(context, title: language!.deleteThisRecipeStep);
                  finish(context, true);
                }).catchError((error) {
                  appStore.setLoading(false);
                  toast(error.toString());
                });
              });
            },
            icon: Icon(Icons.delete, color: context.iconColor, size: 30),
          ).visible(mISUpdate),
          IconButton(
            onPressed: () async {
              appStore.setLoading(true);
              recipeStepModel = RecipeStepModel();
              recipeStepModel!
                ..description = stepDescriptionController.text.trim()
                ..ingredient_used_id = ingredientUsedId.toString();
              //  ..recipe_step_image = widget.recipeStepModel!.stepImage == null ? stepImage : widget.recipeStepModel!.stepImage!.path.validate()

              await addStepData(
                recipeStepWeb: recipeStepWeb != null ? recipeStepWeb : null,
                description: stepDescriptionController.text.trim(),
                file: widget.recipeStepModel!.stepImage != null ? File(widget.recipeStepModel!.stepImage!.path.validate()) : null,
                ingredientUseId: ingredientUsedId.toString(),
                recipeId: mISUpdate ? widget.recipeStepModel!.recipe_id : newRecipeModel!.id,
                id: mISUpdate ? widget.recipeStepModel!.id : -1,
                stepImageFiles: stepImageFiles,
                stepImagesWab: recipeImageList,
              ).then((value) {
                RecipeUtensilsModel recipeStep = RecipeUtensilsModel();

                recipeStep.recipe_id = newRecipeModel!.id.validate();
                recipeStep.step_id = value.validate();
                recipeStep.step_utensils = utensilData.toList();

                addUtensilData(recipeStep.toJson()).then((v) {
                  recipeStepModel!
                    ..recipe_id = newRecipeModel!.id.validate()
                    ..id = value.validate()
                    ..utensil = utensilData.toList();

                  finish(context, recipeStepModel);
                  appStore.setLoading(false);
                }).catchError((error) {
                  appStore.setLoading(false);
                  log(error.toString());
                });
              }).catchError((error) {
                log(error.toString());
              });
            },
            icon: Icon(Icons.done, color: context.iconColor, size: 30),
          ),
        ],
        backWidget: IconButton(
          onPressed: () {
            finish(context);
          },
          icon: Icon(Icons.clear, color: context.iconColor),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: FixSizedBox(
              maxWidth: kIsWeb ? null : context.width(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(language!.stepPhoto, style: boldTextStyle()),
                  8.height,
                  isWeb
                      ? recipeImageWidget()
                      : BuildImageWidget(
                          imageId: stepImageID,
                          mIsUpdate: mISUpdate,
                          type: Types.step_image_gallery,
                          recipeImage: stepImage,
                          listFiles: stepImageFiles,
                          imageList: widget.recipeStepModel!.step_image_gallery.validate(),
                        ),
                  16.height,
                  Text(language!.stepDescription, style: boldTextStyle()),
                  16.height,
                  AppTextField(
                    controller: stepDescriptionController,
                    maxLines: 15,
                    textFieldType: TextFieldType.OTHER,
                    decoration: inputDecorationRecipe(context, hintTextName: language!.egOriginalRecipe),
                    maxLength: null,
                  ),
                  8.height,
                  Text(language!.ingredientUsed, style: boldTextStyle()),
                  AppTextField(
                    controller: ingredientsUseController,
                    readOnly: true,
                    textFieldType: TextFieldType.OTHER,
                    decoration: inputDecorationRecipe(context, hintTextName: language!.clickYourList),
                    onTap: () async {
                      List<RecipeIngredientsModel>? utiData = [];

                      utiData = isWeb
                          ? await showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: Container(
                                    height: 300,
                                    width: 300,
                                    child: StepIngredientsWidget(listData: utiData, ingredientRecipeId: mISUpdate ? widget.recipeStepModel!.recipe_id : newRecipeModel!.id),
                                  ),
                                );
                              })
                          : await StepIngredientsWidget(listData: utiData, ingredientRecipeId: mISUpdate ? widget.recipeStepModel!.recipe_id : newRecipeModel!.id)
                              .launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                      if (utiData != null) {
                        String idList = '';
                        String data = '';

                        for (var i in utiData) {
                          if (data.isEmpty) {
                            data = i.name! + ',';
                            idList = i.id!.toString() + ',';
                          } else {
                            data = data + i.name! + ',';
                            idList = idList + i.id!.toString() + ',';
                          }
                        }

                        data = data.substring(0, data.length - 1);
                        idList = idList.substring(0, idList.length - 1);
                        ingredientsUseController.text = data;

                        ingredientUsedId = idList;
                      }
                    },
                  ),
                  16.height,
                  Text(language!.utensil, style: boldTextStyle()),
                  ...utensilData.map((e) {
                    return Container(
                      margin: EdgeInsets.only(top: 16),
                      width: context.width(),
                      padding: EdgeInsets.all(16),
                      decoration: boxDecorationWithShadow(backgroundColor: context.cardColor, borderRadius: BorderRadius.circular(defaultRadius)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.edit, color: context.iconColor).onTap(() async {
                                StepUtensil? res = isWeb
                                    ? await showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            content: Container(
                                              height: 300,
                                              width: 300,
                                              child: AddUtensilScreen(model: e),
                                            ),
                                          );
                                        })
                                    : await AddUtensilScreen(model: e).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                                if (res != null) {
                                  e.special_use = res.special_use;
                                  e.name = res.name;
                                  e.amount = res.amount;

                                  setState(() {});
                                }
                              }),
                              16.width,
                              Icon(Icons.delete, color: context.iconColor).onTap(() async {
                                await showConfirmDialogCustom(context, dialogType: DialogType.DELETE, positiveText: language!.delete, negativeText: language!.cancel, primaryColor: primaryColor, onAccept: (c) {
                                  utensilData.removeAt(utensilData.indexOf(e));
                                  setState(() {});
                                });
                              }),
                            ],
                          ),
                          8.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(language!.utensil, style: secondaryTextStyle(color: primaryColor)),
                                  8.height,
                                  Text(e.name.validate(), style: secondaryTextStyle()),
                                  8.height,
                                  Text(language!.amount, style: secondaryTextStyle(color: primaryColor)),
                                  8.height,
                                  Text(e.amount.toString(), style: primaryTextStyle())
                                ],
                              ),
                              Column(
                                children: [
                                  Text(language!.specialUse, style: secondaryTextStyle(color: primaryColor)),
                                  8.height,
                                  Text(e.special_use.validate(), style: secondaryTextStyle()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  16.height,
                  addStepWidget(title: language!.addAUtensil, context: context).onTap(() async {
                    StepUtensil? stepUtensilData = isWeb
                        ? await showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                content: Container(
                                  height: 300,
                                  width: 300,
                                  child: AddUtensilScreen(),
                                ),
                              );
                            })
                        : await AddUtensilScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

                    if (stepUtensilData != null) {
                      if (!utensilData.contains(stepUtensilData)) {
                        utensilData.add(stepUtensilData);
                      }
                      setState(() {});
                    }
                  })
                ],
              ),
            ),
          ),
          Observer(builder: (_) => Loader().visible(appStore.isLoader))
        ],
      ),
    );
  }
}
