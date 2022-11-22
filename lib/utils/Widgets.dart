import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/ScaleImageWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/utils/Colors.dart';

InputDecoration buildInputDecoration(String name, {Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
      hintText: name,
      hintStyle: primaryTextStyle(size: 18),
      isDense: true,
      counterText: "",
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      filled: true,
      fillColor: appStore.isDarkMode ? appButtonColorDark : Colors.white,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: new BorderRadius.circular(defaultRadius), borderSide: BorderSide.none));
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
  bool? isScaled = true,
}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
  } else if (url.validate().startsWith('http')) {
    return kIsWeb
        ? ScaleImageWidget(
            height: height,
            width: width,
            isScaleImage: isScaled,
            child: CachedNetworkImage(
              imageUrl: url!,
              fit: fit,
              alignment: alignment as Alignment? ?? Alignment.center,
              errorWidget: (_, s, d) {
                return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
              },
              placeholder: (_, s) {
                if (!usePlaceholderIfUrlEmpty) return SizedBox();
                return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
              },
            ),
          )
        : CachedNetworkImage(
            imageUrl: url!,
            fit: fit,
            height: height,
            width: width,
            alignment: alignment as Alignment? ?? Alignment.center,
            errorWidget: (_, s, d) {
              return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
            },
            placeholder: (_, s) {
              if (!usePlaceholderIfUrlEmpty) return SizedBox();
              return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment, radius: radius);
            },
          );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, double? radius}) {
  return Image.asset('images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center).cornerRadiusWithClipRRect(radius ?? defaultRadius);
}

InputDecoration inputDecorationRecipe(BuildContext context, {String? labelTextName, String? hintTextName, double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: labelTextName,
    hintText: hintTextName,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: gray.withOpacity(0.1),
  );
}

Widget createRecipeTime({String? title, String? subTitle, String? time, Function()? onTap, required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title!, style: boldTextStyle()),
          8.height,
          Text(subTitle!, style: secondaryTextStyle()),
        ],
      ).expand(),
      32.width,
      InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius), color: context.cardColor),
          child: Text(time!, style: primaryTextStyle()),
        ),
      )
    ],
  ).paddingOnly(top: 16, left: 16, right: 16);
}

Widget createRecipeWidget({String? title, double? width}) {
  return Container(
    width: width,
    color: Colors.amberAccent.withOpacity(0.3),
    padding: EdgeInsets.all(16),
    child: Text(title.validate(), style: primaryTextStyle()),
  );
}

Route createRoute({Widget? widget}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget!,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Widget addStepWidget({String? title, required BuildContext context}) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(border: Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add, color: context.iconColor),
        8.width,
        Text(title!, style: primaryTextStyle()),
      ],
    ),
  );
}

Widget cookingTimeWidget({required BuildContext context, double? percentage, Color? color, String? title, String? subtitle, double? spanCount}) {
  if (title.validate().toInt() == 0) return SizedBox();

  return Column(
    children: [
      Container(
        width: spanCount,
        decoration: BoxDecoration(
          color: context.cardColor,
          border: Border.all(color: appStore.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300),
          borderRadius: radius(defaultRadius),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.access_time_rounded, color: context.primaryColor),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${title.validate()}', style: boldTextStyle()),
                Text(' min', style: boldTextStyle(size: 14)),
              ],
            ).fit(),
          ],
        ),
      ),
      20.height,
      Text(subtitle.validate(), style: primaryTextStyle()),
    ],
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Widget addImg({BuildContext? context, String? image, Function(File)? onFileSelected, String? id, String? type}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: context!.height() * 0.4,
        width: context.width(),
        decoration: BoxDecoration(border: image.validate().isNotEmpty ? Border() : Border.all(color: primaryColor), borderRadius: BorderRadius.circular(defaultRadius), color: containerColor.withOpacity(0.3)),
        child: image.validate().isNotEmpty
            ? commonCachedNetworkImage(image, fit: BoxFit.cover, width: context.width()).cornerRadiusWithClipRRect(defaultRadius)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 30, color: primaryColor),
                  16.width,
                  Text('Upload a final of\nyour dish now', style: primaryTextStyle(color: primaryColor)),
                ],
              ),
      ),
      6.height,
      Text('Tap to on image to change', style: secondaryTextStyle()),
    ],
  );
}

Widget iconWidget({IconData? icon, String? countText}) {
  return Row(
    children: [
      Icon(icon, size: 20),
      8.width,
      Text(countText.validate(), style: primaryTextStyle()).fit(),
    ],
  );
}

Widget recipeContainWidget(BuildContext context, {String? recipeDetailImage, String? recipeDataText}) {
  return SizedBox(
    width: context.width() / 2 - 36,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(recipeDetailImage.validate(), height: 16, width: 16),
        8.width,
        Text(recipeDataText.validate(), style: primaryTextStyle()).expand(),
      ],
    ),
  );
}

Widget recipeDataWidget({String? titleText, String? titleData}) {
  return Row(
    children: [
      Text("${titleText.validate()} :", style: primaryTextStyle()).fit(),
      8.width,
      Text(titleData.validate(), style: primaryTextStyle()).fit(),
    ],
  );
}

/* IconButton(
                      onPressed: () {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.DELETE,
                          title: 'Are You Sure Want To Remove This Image',
                          onAccept: (context) {
                            finish(context);
                            LiveStream().emit(streamRefreshRecipeIndex, '');
                            LiveStream().emit(streamRefreshRecipeData, '');

                            Map req = {'id': id, 'type': type};

                            deleteRecipeImage(req).then((value) {
                              snackBar(context, title: language!.deletedRecipeSuccessfully);
                            }).catchError((error) {
                              log(error);
                            });
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: context.iconColor))*/
