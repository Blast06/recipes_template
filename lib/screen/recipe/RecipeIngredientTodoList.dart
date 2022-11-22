import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/database/IngredientsDBModel.dart';
import 'package:recipe_app/database/IngredientsDataProvider.dart';
import 'package:recipe_app/database/RecipeDataProvider.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/screen/PhotoViewScreen.dart';
import 'package:recipe_app/utils/Colors.dart';
import 'package:recipe_app/utils/Widgets.dart';

class RecipeIngredientTodoList extends StatefulWidget {
  final int? recipeId;
  final String? recipeImg;
  final String? recipeTitle;

  RecipeIngredientTodoList({this.recipeId, this.recipeImg, this.recipeTitle});

  @override
  RecipeIngredientTodoListState createState() => RecipeIngredientTodoListState();
}

class RecipeIngredientTodoListState extends State<RecipeIngredientTodoList> {
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
    return Scaffold(
      appBar: appBarWidget(
        language!.shoppingListTodo,
        actions: [
          IconButton(
            onPressed: () async {
              await showConfirmDialogCustom(
                context,
                primaryColor: primaryColor,
                dialogType: DialogType.DELETE,
                title: language!.removeThisRecipe,
                positiveText: language!.delete,
                negativeText: language!.cancel,
                onAccept: (c) async {
                  await removeRecipeById(widget.recipeId!);

                  finish(context);
                },
              );
            },
            icon: Icon(Icons.delete, color: context.iconColor),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                commonCachedNetworkImage(widget.recipeImg, height: 230, width: context.width(), fit: BoxFit.cover),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: context.width(),
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.repeated,
                      ),
                    ),
                  ).onTap(() {
                    PhotoViewScreen(
                      img: widget.recipeImg,
                      isList: false,
                    ).launch(context, duration: Duration(milliseconds: 300));
                  }),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Text(widget.recipeTitle.validate(), style: boldTextStyle(size: 22, color: whiteColor)),
                ),
              ],
            ),
            FutureBuilder<List<IngredientsDBModel>>(
              future: getIngredientList(widget.recipeId!),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        IngredientsDBModel data = snapshot.data![index];
                        log(data);
                        return Row(
                          children: [
                            Icon(Icons.done, color: data.status == 0 ? context.iconColor : primaryColor).paddingAll(12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name.validate(),
                                  style: primaryTextStyle(
                                    decoration: data.status == 0 ? TextDecoration.none : TextDecoration.lineThrough,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(data.unit.validate(), style: primaryTextStyle()),
                                    8.width,
                                    Text(data.amount.validate(), style: primaryTextStyle()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ).paddingSymmetric(vertical: 8).onTap(() async {
                          await updateRecipeIngredient(status: data.status == 0 ? 1 : 0, ingredientID: data.ingredientId);
                          setState(() {});
                        });
                      },
                      separatorBuilder: (_, index) => Divider(indent: 40, height: 0),
                    );
                  }
                }
                return snapWidgetHelper(snapshot);
              },
            )
          ],
        ),
      ),
    );
  }
}
