import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/FixSizedBox.dart';
import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

import '../main.dart';

class AddSliderWidget extends StatefulWidget {
  final SliderData? data;

  AddSliderWidget({required this.data});

  @override
  _AddSliderWidgetState createState() => _AddSliderWidgetState();
}

class _AddSliderWidgetState extends State<AddSliderWidget> {
  TextEditingController titleCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  XFile? selectedImage;
  String? sliderImageWeb;
  Uint8List? sliderWebImg;

  bool mISUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mISUpdate = widget.data != null;
    if (mISUpdate) {
      titleCont.text = widget.data!.title.validate();
      descriptionCont.text = widget.data!.description.validate();
      setState(() {});
    }
  }

  Future getImage() async {
    if (isWeb) {
      getImageWeb();
    } else {
      selectedImage = null;
      selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);

      setState(() {});
    }
  }

  void getImageWeb() async {
    selectedImage = null;
    selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      sliderWebImg = await selectedImage!.readAsBytes();
    }
    setState(() {});
  }

  void submit() async {
    if (!mISUpdate && selectedImage == null) {
      snackBar(context, title: language!.pleaseSelectImage);
    } else {
      appStore.setLoading(true);

      await addSliderData(
        imageWeb: sliderWebImg,
        file: selectedImage != null ? File(selectedImage!.path.validate()) : null,
        title: titleCont.text.trim(),
        description: descriptionCont.text.trim(),
        category: RecipeTypeCategoryData,
        id: mISUpdate ? widget.data!.id : -1,
      ).then((value) {
        appStore.setLoading(false);
        toast(mISUpdate ? language!.sliderHasBeenUpdatedSuccessfully : language!.sliderHasBeenSaveSuccessfully);

        LiveStream().emit(streamRefreshSlider, selectedImage);

        finish(context);
      }).catchError((error) {
        appStore.setLoading(false);
        toast(error.toString());
      });
    }
  }

  recipeImageWidget() {
    if (selectedImage != null) {
      return Column(
        children: [
          Image.network(selectedImage!.path, width: 150, height: 150).cornerRadiusWithClipRRect(defaultRadius),
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
      if (mISUpdate) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonCachedNetworkImage(
              sliderImageWeb.validate(),
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ).cornerRadiusWithClipRRect(defaultRadius),
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
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: boxDecorationWithRoundedCorners(
                border: Border.all(color: primaryColor),
                backgroundColor: Color(0xFFFAF5F0),
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: FixSizedBox(
            maxWidth: kIsWeb ? null : context.width(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isWeb
                    ? recipeImageWidget()
                    : selectedImage != null || mISUpdate
                        ? Column(
                            children: [
                              mISUpdate && selectedImage == null
                                  ? commonCachedNetworkImage(widget.data!.slider_image!, height: 250, width: context.width(), fit: BoxFit.cover)
                                  : Image.file(
                                      File(selectedImage!.path),
                                      height: 250,
                                      width: context.width(),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ).cornerRadiusWithClipRRect(defaultRadius),
                              TextButton(
                                onPressed: () {
                                  getImage();
                                },
                                child: Text(language!.changeImage, style: secondaryTextStyle()),
                              )
                            ],
                          )
                        : addImg(context: context, image: newRecipeModel != null ? newRecipeModel!.recipe_image![0].url.validate() : '').onTap(
                            () {
                              getImage();
                            },
                          ),
                16.height,
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: titleCont,
                  decoration: inputDecorationRecipe(context, labelTextName: language!.title),
                  maxLength: 25,
                ),
                8.height,
                AppTextField(
                  textFieldType: TextFieldType.NAME,
                  controller: descriptionCont,
                  decoration: inputDecorationRecipe(context, labelTextName: language!.description),
                  maxLength: 30,
                ),
                16.height,
                AppButton(
                  text: language!.save,
                  textStyle: boldTextStyle(color: white),
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    if (appStore.isDemoAdmin) {
                      snackBar(context, title: language!.demoUserMsg);
                    } else {
                      submit();
                    }
                  },
                  shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
                )
              ],
            ),
          ),
        ),
        Observer(builder: (_) => Loader().visible(appStore.isLoader)),
      ],
    );
  }
}
