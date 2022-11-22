import 'package:recipe_app/models/RecipeIngredientsModel.dart';
import 'package:recipe_app/models/RecipePaginationModel.dart';

class RecipeIngredientsListModel {
  List<RecipeIngredientsModel>? data;
  RecipePaginationModel? pagination;

  RecipeIngredientsListModel({this.data, this.pagination});

  factory RecipeIngredientsListModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientsListModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => RecipeIngredientsModel.fromJson(i)).toList() : [],
      pagination: RecipePaginationModel.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
