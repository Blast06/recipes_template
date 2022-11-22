import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

// ignore: must_be_immutable
class RecipeImageWidget extends StatefulWidget {
  bool mIsUpdate;
  List<ImageModel>? imageList;
  String? recipeImage;

  RecipeImageWidget({this.imageList, required this.mIsUpdate, this.recipeImage});

  @override
  State<RecipeImageWidget> createState() => _RecipeImageWidgetState();
}

class _RecipeImageWidgetState extends State<RecipeImageWidget> {
  PageController pageController = PageController();
  int currentPage = 0;

  List<ImageModel>? imageList;

  @override
  void initState() {
    imageList = widget.imageList;
    super.initState();
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
  Widget build(BuildContext context) {
    if (xFileImage != null && !widget.mIsUpdate) {
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
                    Image.network(
                      e.path,
                      height: context.height() * 0.4,
                      width: context.width(),
                      fit: BoxFit.cover,
                    ).cornerRadiusWithClipRRect(defaultRadius),
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
        getImageWeb();
        setState(() {});
      });
    } else {
      if (imageList.validate().isNotEmpty) {
        return Container(
          height: context.height() * 0.4,
          width: context.width(),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView(
                controller: pageController,
                children: [
                  ...imageList!.map((e) {
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
                                  Map req = {'id': e.id, 'type': Types.recipe_image};

                                  deleteRecipeImage(req).then((value) {
                                    imageList!.remove(e);
                                    setState(() {});

                                    toast(language!.deletedRecipeSuccessfully);
                                  }).catchError((error) {
                                    log(error);
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
                pages: [...imageList.validate(), ...xFileImage.validate()],
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
          getImageWeb();
          setState(() {});
        });
      } else if (newRecipeModel!.recipe_image.validate().isNotEmpty) {
        if (xFileImage.validate().isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commonCachedNetworkImage(widget.recipeImage.validate(), fit: BoxFit.cover, height: 150, width: 150).cornerRadiusWithClipRRect(defaultRadius),
              8.height,
              TextButton(
                onPressed: () async {
                  getImageWeb();
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
            getImageWeb();
            setState(() {});
          });
        }
      } else {
        return Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: boxDecorationWithRoundedCorners(border: Border.all(color: primaryColor), backgroundColor: Color(0xFFFAF5F0), borderRadius: radius(defaultRadius)),
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
                getImageWeb();
              }),
            ),
          ],
        );
      }
    }
  }
}
