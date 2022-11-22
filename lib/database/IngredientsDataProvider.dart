import 'package:recipe_app/database/IngredientsDBModel.dart';
import 'package:recipe_app/database/RecipeDataProvider.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/models/RecipeDetailModel.dart';

//region Keys
const TABLE_INGREDIENTS = 'ingredients';

const KEY_INGREDIENT_ID = 'id';
const KEY_INGREDIENT_TITLE = 'name';
const KEY_INGREDIENT_AMOUNT = 'amount';
const KEY_INGREDIENT_UNIT = 'unit';
const KEY_INGREDIENT_STATUS = 'status';
const KEY_INGREDIENT_CREATED_AT = 'created_at';
//endregion

Future<List<Ingredient>> getIngredient() async {
  var shopping = await database.query(TABLE_INGREDIENTS, orderBy: 'title');

  List<Ingredient>? shoppingList = (shopping.isNotEmpty ? shopping.map((c) => Ingredient.fromJson(c)).toList() : []).cast<Ingredient>();
  return shoppingList;
}

Future<void> addIngredientsLocalDB(List<IngredientsDBModel> ingredientsModel) async {
  ingredientsModel.forEach((element) {
    addIngredient(element);
  });
}

Future<int> addIngredient(IngredientsDBModel ingredientsModel) async {
  return await database.insert(TABLE_INGREDIENTS, ingredientsModel.toMap());
}

Future<List<IngredientsDBModel>> getIngredientList(int repId) async {
  var ingredientsDBModel = await database.query(TABLE_INGREDIENTS, where: "$KEY_RECIPE_ID=?", whereArgs: [repId]);
  return ingredientsDBModel.map((c) => IngredientsDBModel.fromMap(c)).toList();
}

Future<int> removeRecipeIngredientId(int id) async {
  return await database.delete(TABLE_INGREDIENTS, where: '$KEY_RECIPE_ID = ?', whereArgs: [id]);
}

Future<int> updateRecipeIngredient({int? ingredientID, int? status}) async {
  return await database.update(TABLE_INGREDIENTS, {"$KEY_INGREDIENT_STATUS": status}, where: "$KEY_INGREDIENT_ID = ?", whereArgs: [ingredientID]);
}
