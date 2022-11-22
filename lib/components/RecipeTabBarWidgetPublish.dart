import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/MyRecipeWidget.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/network/RestApis.dart';
import 'package:recipe_app/screen/newRecipe/NewRecipeScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';

class RecipeTabBarWidgetPublish extends StatefulWidget {
  final int spanCount;

  RecipeTabBarWidgetPublish({this.spanCount = 2});

  @override
  RecipeTabBarWidgetPublishState createState() => RecipeTabBarWidgetPublishState();
}

class RecipeTabBarWidgetPublishState extends State<RecipeTabBarWidgetPublish> with AutomaticKeepAliveClientMixin<RecipeTabBarWidgetPublish> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(streamRefreshRecipeData, (v) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(streamRefreshRecipeData);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        MyRecipeWidget(
          spanCount: widget.spanCount,
          popMenuList: [
            PopupMenuItem(child: Text(language!.edit, style: primaryTextStyle()), value: 1),
            PopupMenuItem(child: Text(language!.delete, style: primaryTextStyle()), value: 2),
            PopupMenuItem(child: Text(language!.unpublished, style: primaryTextStyle()), value: 3),
          ],
          status: 1,
          onTap: (val, data) async {
            if (val == 1) {
              NewRecipeScreen(recipe: data)
                  .launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300))
                  .then((value) {
                init();
                LiveStream().emit(streamRefreshRecipe);
              }).catchError((e) {
                toast(e.toString());
              });
            } else if (val == 2) {
              Map req = {
                'id': data.id,
              };
              appStore.setLoading(true);
              await showConfirmDialogCustom(context,
                  dialogType: DialogType.DELETE,
                  positiveText: language!.delete,
                  negativeText: language!.cancel,
                  title: language!.deleteThisRecipe,
                  primaryColor: primaryColor, onAccept: (c) {
                deleteRecipe(req).then((value) {
                  init();
                  LiveStream().emit(streamRefreshRecipe);

                  snackBar(context, title: language!.deletedRecipeSuccessfully);
                }).catchError((error) {
                  toast(error.toString());
                });
              });
              appStore.setLoading(false);
            } else if (val == 3) {
              newRecipeModel = data;
              newRecipeModel!.status = 0;
              appStore.setLoading(true);
              await showConfirmDialogCustom(context,
                  title: language!.unpublishedThisRecipe,
                  dialogType: DialogType.DELETE,
                  positiveText: language!.yes,
                  negativeText: language!.no,
                  primaryColor: primaryColor, onAccept: (BuildContext context) {
                addUpdateRecipeData(status: newRecipeModel!.status = 0, id: data.id).then((value) {
                  LiveStream().emit(streamRefreshUnPublished);
                  snackBar(context, title: language!.recipeUnPublishedSucessfully);
                  setState(() {});
                }).catchError((error) {
                  log(error);
                });
                appStore.setLoading(false);
              });
            }
          },
        ),
        Loader().visible(appStore.isLoader)
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
