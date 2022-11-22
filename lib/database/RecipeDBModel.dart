import 'package:recipe_app/database/RecipeDataProvider.dart';

class RecipeDBModel {
  int? id;
  String? title;
  String? recipeImg;
  String? createAt;
  int? userId;

  RecipeDBModel({this.id, this.recipeImg, this.title, this.userId, this.createAt});

  factory RecipeDBModel.fromMap(Map<String, dynamic> json) {
    return RecipeDBModel(
      id: json[KEY_RECIPE_ID],
      recipeImg: json[KEY_RECIPE_TITLE],
      title: json[KEY_RECIPE_IMG],
      createAt: json[KEY_RECIPE_CREATE_AT],
      userId: json[KEY_USER_ID],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data[KEY_RECIPE_ID] = this.id;
    data[KEY_RECIPE_TITLE] = this.recipeImg;
    data[KEY_RECIPE_IMG] = this.title;
    data[KEY_RECIPE_CREATE_AT] = this.createAt;
    data[KEY_USER_ID] = this.userId;

    return data;
  }
}
