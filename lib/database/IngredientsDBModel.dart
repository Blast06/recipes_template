import 'package:recipe_app/database/IngredientsDataProvider.dart';
import 'package:recipe_app/database/RecipeDataProvider.dart';

class IngredientsDBModel {
  int? ingredientId;
  int? recipeId;
  String? name;
  String? amount;
  String? unit;
  int? status;
  String? createdAt;

  IngredientsDBModel({this.ingredientId, this.recipeId, this.name, this.amount, this.unit, this.status, this.createdAt});

  factory IngredientsDBModel.fromMap(Map<String, dynamic> json) {
    return IngredientsDBModel(
      ingredientId: json[KEY_INGREDIENT_ID],
      recipeId: json[KEY_RECIPE_ID],
      name: json[KEY_INGREDIENT_TITLE],
      amount: json[KEY_INGREDIENT_AMOUNT],
      unit: json[KEY_INGREDIENT_UNIT],
      status: json[KEY_INGREDIENT_STATUS],
      createdAt: json[KEY_INGREDIENT_CREATED_AT],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data[KEY_INGREDIENT_ID] = this.ingredientId;
    data[KEY_RECIPE_ID] = this.recipeId;
    data[KEY_INGREDIENT_TITLE] = this.name;
    data[KEY_INGREDIENT_AMOUNT] = this.amount;
    data[KEY_INGREDIENT_UNIT] = this.unit;
    data[KEY_INGREDIENT_STATUS] = this.status;
    data[KEY_INGREDIENT_CREATED_AT] = this.createdAt;

    return data;
  }
}
