import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/models/RecipePaginationModel.dart';

class RecipeBookMarkModel {
  List<RecipeModel>? data;
  RecipePaginationModel? pagination;

  RecipeBookMarkModel({this.data, this.pagination});

  factory RecipeBookMarkModel.fromJson(Map<String, dynamic> json) {
    return RecipeBookMarkModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => RecipeModel.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? RecipePaginationModel.fromJson(json['pagination']) : null,
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