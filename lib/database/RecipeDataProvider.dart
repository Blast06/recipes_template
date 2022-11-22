import 'package:recipe_app/database/IngredientsDataProvider.dart';
import 'package:recipe_app/database/RecipeDBModel.dart';
import 'package:recipe_app/main.dart';

//region Keys
const TABLE_RECIPE = 'recipe';

const KEY_RECIPE_ID = 'recipe_id';
const KEY_RECIPE_TITLE = 'title';
const KEY_RECIPE_IMG = 'img';
const KEY_RECIPE_CREATE_AT = 'create_at';
const KEY_USER_ID = 'user_id';
//endregion

Future<List<RecipeDBModel>> getRecipeList() async {
  var recipeListData = await database.query(TABLE_RECIPE, orderBy: KEY_RECIPE_TITLE, where: '$KEY_USER_ID = ${appStore.userId}');

  return recipeListData.map((c) => RecipeDBModel.fromMap(c)).toList();
}

Future<void> removeRecipeById(int id) async {
  await database.delete(TABLE_RECIPE, where: '$KEY_RECIPE_ID = ?', whereArgs: [id]);

  await removeRecipeIngredientId(id);
}

Future<int> updateRecipe(RecipeDBModel recipeDBModel) async =>
    await database.update(TABLE_RECIPE, recipeDBModel.toMap(), where: '$KEY_RECIPE_ID${recipeDBModel.id}');

Future<bool> isRecipeExists(int recipeId) async {
  var res = await database.query(TABLE_RECIPE, where: '$KEY_RECIPE_ID = $recipeId AND $KEY_USER_ID = ${appStore.userId}');

  return res.length == 1;
}

Future<void> addRecipeLocalData(RecipeDBModel dbModel) async {
  await database.insert(TABLE_RECIPE, dbModel.toMap());
}
