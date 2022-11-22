import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/RecipeComponentWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailMobileScreen.dart';
import 'package:recipe_app/screen/recipe/RecipeDetailWebScreen.dart';

class RecipeItemGridWidget extends StatefulWidget {
  final RecipeModel e;
  final Function(int) onPopupMenuSelected;
  final List<PopupMenuItem<int>>? popMenuList;
  final int spanCount;

  RecipeItemGridWidget(this.e, {required this.onPopupMenuSelected, this.popMenuList, this.spanCount = 2});

  @override
  RecipeItemGridWidgetState createState() => RecipeItemGridWidgetState();
}

class RecipeItemGridWidgetState extends State<RecipeItemGridWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RecipeComponentWidget(
      recipeModel: widget.e,
      spanCount: widget.spanCount,
      widgetData: PopupMenuButton(
        offset: Offset(0, 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(defaultRadius)),
        padding: EdgeInsets.only(bottom: 16),
        onSelected: (int val) async {
          if (appStore.isDemoAdmin) {
            snackBar(context, title: language!.demoUserMsg);
          } else {
            widget.onPopupMenuSelected.call(val);
          }
        },
        itemBuilder: (_) {
          return widget.popMenuList!;
        },
        icon: Icon(Icons.more_vert, color: black),
      ),
    ).onTap(() {
      kIsWeb
          ? RecipeDetailWebScreen(
              recipeID: widget.e.id,
              recipe: widget.e,
            ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide, duration: Duration(milliseconds: 300))
          : RecipeDetailMobileScreen(recipeID: widget.e.id, recipe: widget.e).launch(context, duration: Duration(milliseconds: 300));
    });
  }
}
