import 'package:recipe_app/models/RecipePaginationModel.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';

class RecipeStepModelList {
  List<RecipeStepModel>? data;
  RecipePaginationModel? pagination;

  RecipeStepModelList({this.data, this.pagination});

  factory RecipeStepModelList.fromJson(Map<String, dynamic> json) {
    return RecipeStepModelList(
      data: json['data'] != null ? (json['data'] as List).map((i) => RecipeStepModel.fromJson(i)).toList() : [],
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
