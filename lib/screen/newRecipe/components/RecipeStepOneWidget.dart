import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/BuildImageWidget.dart';
import 'package:recipe_app/components/RecipeImageWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeStepOneWidget extends StatefulWidget {
  final bool? mIsUpdate;

  RecipeStepOneWidget({this.mIsUpdate});

  @override
  RecipeStepOneWidgetState createState() => RecipeStepOneWidgetState();
}

class RecipeStepOneWidgetState extends State<RecipeStepOneWidget> {
  TextEditingController recipeController = TextEditingController();
  PageController pageController = PageController();

  FocusNode nameFocus = FocusNode();

  bool mIsUpdate = false;

  int currentPage = 0;

  XFile? image;
  String? recipeImage;
  String? recipeImageId;

  List<ImageModel>? imageList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.mIsUpdate.validate();

    if (mIsUpdate) {
      recipeController.text = newRecipeModel!.title!;
      if (newRecipeModel!.recipe_image!.isNotEmpty) {
        recipeImage = newRecipeModel!.recipe_image![0].url.validate();
      }
      if (newRecipeModel!.recipe_image!.isNotEmpty) {
        recipeImageId = newRecipeModel!.recipe_image![0].id.validate().toString();
      }
      imageList = newRecipeModel!.recipe_image_gallery.validate();

      setState(() {});
    }

    setState(() {});
  }

  Future getImage() async {
    if (isWeb) {
      getImageWeb();
    } else {
      image = null;
      image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (image != null) {
        newRecipeModel!.recipeFile = File(image!.path.validate());
        setState(() {});
      }
    }
  }

  void getImageWeb() async {
    List<Uint8List> recipeImageList = [];

    xFileImage = await ImagePicker().pickMultiImage();

    if (xFileImage != null) {
      xFileImage!.forEach((element) async {
        recipeImageList.add(await element.readAsBytes());
      });

      newRecipeModel!.fileBytes = recipeImageList;
    }
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: context.cardColor,
        height: context.height(),
        width: context.width(),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  createRecipeWidget(title: language!.step1Title, width: context.width()),
                  16.height,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language!.nameYourRecipe, style: boldTextStyle()),
                      AppTextField(
                        controller: recipeController,
                        focus: nameFocus,
                        maxLength: 55,
                        textFieldType: TextFieldType.NAME,
                        decoration: inputDecorationRecipe(context, hintTextName: language!.egVegetarian),
                        onChanged: (s) {
                          newRecipeModel!.title = s.trim();
                        },
                      ),
                      16.height,
                      Text(language!.addRecipePhoto, style: boldTextStyle()),
                      8.height,
                      isWeb
                          ? RecipeImageWidget(
                              mIsUpdate: mIsUpdate,
                              imageList: imageList,
                              recipeImage: recipeImage,
                            )
                          : BuildImageWidget(
                              imageId: recipeImageId,
                              mIsUpdate: mIsUpdate,
                              imageList: imageList,
                              recipeImage: recipeImage,
                              listFiles: recipeFiles,
                              type: Types.recipe_image,
                            ),
                    ],
                  ).paddingOnly(left: 16, right: 16),
                ],
              ),
            ).expand(),
            AppButton(
              width: context.width(),
              color: primaryColor,
              shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
              child: Text(language!.next, style: boldTextStyle(color: white)),
              onTap: () {
                hideKeyboard(context);
                if (recipeController.text.isEmpty) {
                  context.requestFocus(nameFocus);
                  snackBar(context, title: language!.pleaseEnterRecipeName);
                } else {
                  LiveStream().emit(streamNewRecipePageChange, 1);
                }
              },
            ).paddingAll(8),
          ],
        ),
      ),
    );
  }
}
