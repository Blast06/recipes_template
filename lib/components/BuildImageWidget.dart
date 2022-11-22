import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Common.dart';
import 'package:recipe_app/utils/Widgets.dart';

import '../main.dart';

// ignore: must_be_immutable
class BuildImageWidget extends StatefulWidget {
  bool mIsUpdate;
  List<ImageModel>? imageList;
  String? recipeImage;
  List<File>? listFiles;
  String type;
  String? imageId;

  BuildImageWidget({required this.mIsUpdate, this.imageList, this.recipeImage, this.listFiles, required this.type, this.imageId});

  @override
  State<BuildImageWidget> createState() => _BuildImageWidgetState();
}

class _BuildImageWidgetState extends State<BuildImageWidget> {
  PageController pageController = PageController();
  List<ImageModel>? imageList;

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    imageList = widget.imageList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listFiles!.isNotEmpty && widget.mIsUpdate == false) {
      return Container(
        height: context.height() * 0.4,
        width: context.width(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              children: widget.listFiles!.map((e) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(e, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                    IconButton(
                      onPressed: () {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.DELETE,
                          title: language!.deleteImageTitle,
                          positiveText: language!.delete,
                          negativeText: language!.cancel,
                          onAccept: (context) async {
                            widget.listFiles!.remove(e);
                            setState(() {});
                          },
                        );
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
              pages: widget.listFiles!.validate(),
              unselectedIndicatorColor: Colors.grey,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
            ),
          ],
        ),
      ).onTap(() async {
        widget.listFiles!.addAll(await getMultipleFile());
        setState(() {});
      });
    } else {
      if (imageList!.isNotEmpty) {
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
                                positiveText: language!.delete,
                                negativeText: language!.cancel,
                                onAccept: (context) async {
                                  Map req = {'id': e.id, 'type': widget.type};

                                  await deleteRecipeImage(req).then((value) {
                                    imageList!.remove(e);
                                    setState(() {});

                                    toast(language!.deletedRecipeSuccessfully);
                                  }).catchError((error) {
                                    log('Error : $error');
                                  });
                                },
                              );
                            },
                            icon: Icon(Icons.delete, color: context.iconColor))
                      ],
                    );
                  }).toList(),
                  if (widget.listFiles!.isNotEmpty)
                    ...widget.listFiles!.map((e) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(e, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                          IconButton(
                            onPressed: () {
                              showConfirmDialogCustom(
                                context,
                                dialogType: DialogType.DELETE,
                                title: language!.deleteImageTitle,
                                onAccept: (context) async {
                                  widget.listFiles!.remove(e);
                                  setState(() {});
                                },
                              );
                            },
                            icon: Icon(Icons.delete, color: context.iconColor),
                          ),
                        ],
                      );
                    }).toList(),
                ],
              ),
              if (imageList!.length > 1)
                DotIndicator(
                  indicatorColor: white,
                  pageController: pageController,
                  pages: [...imageList.validate(), ...widget.listFiles!.validate()],
                  unselectedIndicatorColor: Colors.grey,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
            ],
          ),
        ).onTap(() async {
          widget.listFiles!.addAll(await getMultipleFile());
          setState(() {});
        });
      } else if (widget.recipeImage.validate().isNotEmpty) {
        if (widget.listFiles!.isEmpty) {
          return addImg(
            id: widget.imageId,
            context: context,
            image: newRecipeModel != null ? widget.recipeImage : '',
            type: widget.type,
          ).onTap(() async {
            widget.listFiles!.addAll(await getMultipleFile());
            setState(() {});
          });
        } else {
          return Container(
            height: context.height() * 0.4,
            width: context.width(),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView(
                  controller: pageController,
                  children: widget.listFiles!.map((e) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(e, height: context.height() * 0.4, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(defaultRadius),
                        IconButton(
                          onPressed: () {
                            showConfirmDialogCustom(
                              context,
                              dialogType: DialogType.DELETE,
                              title: language!.deleteImageTitle,
                              onAccept: (context) async {
                                widget.listFiles!.remove(e);
                                setState(() {});
                              },
                            );
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
                  pages: widget.listFiles!.validate(),
                  unselectedIndicatorColor: Colors.grey,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                ),
              ],
            ),
          );
        }
      } else {
        return Container(
          height: context.height() * 0.4,
          width: context.width(),
          decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius), color: containerColor.withOpacity(0.3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt_outlined, size: 30, color: primaryColor),
              16.width,
              Text('Upload a final of\nyour dish now', style: primaryTextStyle(color: primaryColor)),
            ],
          ),
        ).onTap(() async {
          widget.listFiles!.addAll(await getMultipleFile());
          setState(() {});
        });
      }
    }
  }
}
