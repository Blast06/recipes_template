import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/components/EmptyWidget.dart';
import 'package:recipe_app/database/RecipeDBModel.dart';
import 'package:recipe_app/database/RecipeDataProvider.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/recipe/RecipeIngredientTodoList.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Constants.dart';
import 'package:recipe_app/utils/Widgets.dart';

class ShoppingListFragment extends StatefulWidget {
  final int? resId;
  final bool mIShow;

  ShoppingListFragment({this.resId, this.mIShow = false});

  @override
  ShoppingListFragmentState createState() => ShoppingListFragmentState();
}

class ShoppingListFragmentState extends State<ShoppingListFragment> {
  int? selectedId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    LiveStream().on(streamRefreshToDo, (v) {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
        await 2.seconds.delay;
        init();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: widget.mIShow
            ? appBarWidget(language!.shoppingList, color: appStore.isDarkMode ? scaffoldSecondaryDark : white, titleTextStyle: boldTextStyle(size: 20), elevation: 0)
            : appBarWidget(language!.shoppingList, showBack: false, color: appStore.isDarkMode ? scaffoldSecondaryDark : white, titleTextStyle: boldTextStyle(size: 20), elevation: 0),
        body: FutureBuilder<List<RecipeDBModel>>(
          future: getRecipeList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return EmptyWidget(title: language!.emptyShoppingList);
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  RecipeDBModel data = snapshot.data![index];
                  return data.userId == getIntAsync(USER_ID)
                      ? ListTile(
                          contentPadding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                          title: Text(data.title!, style: boldTextStyle()),
                          leading: commonCachedNetworkImage(
                            data.recipeImg,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 60,
                          ).cornerRadiusWithClipRRect(defaultRadius),
                          onTap: () async {
                            bool? res = await RecipeIngredientTodoList(
                              recipeId: data.id,
                              recipeImg: data.recipeImg,
                              recipeTitle: data.title,
                            ).launch(
                              context,
                              pageRouteAnimation: PageRouteAnimation.Slide,
                              duration: Duration(milliseconds: 300),
                            );
                            res ?? setState(() {});
                          },
                          onLongPress: () async {
                            await showConfirmDialogCustom(
                              context,
                              dialogType: DialogType.DELETE,
                              primaryColor: primaryColor,
                              title: language!.removeThisRecipe,
                              onAccept: (c) async {
                                await removeRecipeById(data.id!);
                                setState(() {});
                              },
                            );
                          },
                        )
                      : SizedBox();
                },
                separatorBuilder: (_, index) => Divider(),
              );
            }
            return snapWidgetHelper(snapshot);
          },
        ),
      ),
    );
  }
}
