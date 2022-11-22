import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/screen/recipe/AddIngredientScreen.dart';
import 'package:recipe_app/utils/Colors.dart';

class IngredientItemWidget extends StatefulWidget {
  final RecipeIngredientsModel recipe;
  final VoidCallback onDelete;

  IngredientItemWidget(this.recipe, {required this.onDelete});

  @override
  IngredientItemWidgetState createState() => IngredientItemWidgetState();
}

class IngredientItemWidgetState extends State<IngredientItemWidget> {
  RecipeIngredientsModel? data;

  @override
  void initState() {
    data = widget.recipe;
    super.initState();
    init();
  }

  void init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return SizedBox();

    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 16),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: context.width(),
      decoration: BoxDecoration(
        border: Border.all(color: dividerColor),
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language!.ingredients, style: boldTextStyle()),
              8.height,
              Text(data!.name.validate(), style: primaryTextStyle(), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              8.height,
              Text(language!.specialUse, style: boldTextStyle()),
              8.height,
              Text(data!.special_use.validate(), style: primaryTextStyle()),
            ],
          ).expand(),
          8.width,
          Container(height: context.height() * 0.1, width: 1, color: dividerColor),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language!.amount, style: boldTextStyle()),
              8.height,
              Text(data!.amount.validate(), style: primaryTextStyle(), textAlign: TextAlign.center),
              8.height,
              Text(language!.unit, style: boldTextStyle()),
              8.height,
              Text(data!.unit.validate(), style: primaryTextStyle()),
            ],
          ).expand(),
        ],
      ),
    ).onTap(() async {
      var res = isWeb
          ? await showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  content: Container(
                    height: 500,
                    width: 500,
                    child: AddIngredientScreen(recipeIngredientsModel: data),
                  ),
                );
              })
          : await AddIngredientScreen(recipeIngredientsModel: data).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: Duration(milliseconds: 300));

      /// Bool = Deleted
      /// Ingredient Model = Added
      if (res is bool && res) {
        widget.onDelete.call();
      } else if (res is RecipeIngredientsModel) {
        data = res;
        setState(() {});
      }
    }, highlightColor: context.cardColor, splashColor: context.cardColor);
  }
}
