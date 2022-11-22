import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

String toSlug(String text) {
  return text.toLowerCase().replaceAll(' ', '_');
}

String timeFunction(int t) {
  return '${(t ~/ 60).toString().padLeft(2, '0')}:${(t % 60).toString().padLeft(2, '0')}';
}

String stringToMin(String t) {
  if (t.isEmpty) return '0';

  List<String> list = t.split(":");
  String time = (((int.parse(list[0])) * 60) + ((int.parse(list[1])))).toString();
  return time;
}

class TabIndicator extends Decoration {
  final BoxPainter painter = TabPainter();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => painter;
}

class TabPainter extends BoxPainter {
  Paint? _paint;

  TabPainter() {
    _paint = Paint()..color = primaryColor;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Size size = Size(configuration.size!.width, 3);
    Offset _offset = Offset(offset.dx, offset.dy + 32);
    final Rect rect = _offset & size;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        bottomRight: Radius.circular(0),
        bottomLeft: Radius.circular(0),
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      _paint!,
    );
  }
}

Future<void> addLikeDisLike(int recipeId, BuildContext context, int like) async {
  Map req = {
    'recipe_id': recipeId,
    'user_id': appStore.userId,
  };

  /// like == 1 - Unlike
  /// like == 0 - Like
  if (like == 1) {
    await addLike(req).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  } else {
    await removeLike(req).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}

Future<void> addBookMarkData(int recipeId, BuildContext context, int bookMark) async {
  Map req = {
    'recipe_id': recipeId,
    'user_id': appStore.userId,
  };
  if (bookMark == 1) {
    await addBookMark(req).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  } else {
    await removeBookMark(req).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}

Future<void> launchUrl(String url, {bool forceWebView = false}) async {
  await launch(url, forceWebView: forceWebView, enableJavaScript: true).catchError((e) {
    log(e);
    toast('Invalid URL: $url');
  });
}

String storeBaseURL() => isAndroid ? playStoreBaseURL : appStoreBaseUrl;

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'images/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'images/flag/ic_france.png'),
  ];
}

String? get fontFamilyGloria => GoogleFonts.gloriaHallelujah().fontFamily;

BoxDecoration glassBoxDecoration() {
  return BoxDecoration(boxShadow: [
    BoxShadow(
      color: Colors.white.withAlpha(100),
      blurRadius: 10.0,
      spreadRadius: 0.0,
    ),
  ], color: Colors.white.withAlpha(100), border: Border.all(color: Colors.white10.withAlpha(80)), borderRadius: BorderRadius.circular(8));
}

Gradient gradientDecoration() {
  return LinearGradient(
    colors: [Colors.transparent, Colors.black54],
    end: Alignment.bottomCenter,
    begin: Alignment.topCenter,
    stops: [0.0, 1.0],
    //tileMode: TileMode.repeated,
  );
}

Future<void> recipeStatusChange({int? status}) {
  return addUpdateRecipeData(id: newRecipeModel!.id).then((value) {
    newRecipeModel!.status = status;
  }).catchError((e) {
    log(e);
  });
}

Future<List<File>> getMultipleFile() async {
  FilePickerResult? filePickerResult;
  List<File> imgList = [];
  filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);

  if (filePickerResult != null) {
    imgList = filePickerResult.paths.map((path) => File(path!)).toList();
  }
  return imgList;
}
