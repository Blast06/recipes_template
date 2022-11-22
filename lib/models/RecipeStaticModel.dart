import 'package:recipe_app/models/RecipePaginationModel.dart';

class RecipeStaticModel {
  List<CuisineData>? data;
  RecipePaginationModel? pagination;

  RecipeStaticModel({this.data, this.pagination});

  factory RecipeStaticModel.fromJson(Map<String, dynamic> json) {
    return RecipeStaticModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => CuisineData.fromJson(i)).toList() : null,
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

class CuisineData {
  int? id;
  String? label;
  String? type;
  String? value;

  bool isSelected = false;

  ///Local Variable

  bool? mISCheck = false;

  CuisineData({this.id, this.label, this.type, this.value, this.mISCheck = false});

  factory CuisineData.fromJson(Map<String, dynamic> json) {
    return CuisineData(
      id: json['id'],
      label: json['label'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
