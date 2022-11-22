import 'package:recipe_app/models/RecipeDashboardModel.dart';
import 'package:recipe_app/models/RecipePaginationModel.dart';

class RecipeSliderModel {
  List<SliderData>? data;
  RecipePaginationModel? pagination;

  RecipeSliderModel({this.data, this.pagination});

  factory RecipeSliderModel.fromJson(Map<String, dynamic> json) {
    return RecipeSliderModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => SliderData.fromJson(i)).toList() : null,
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
