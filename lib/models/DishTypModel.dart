import 'package:recipe_app/models/RecipePaginationModel.dart';

class DishTypModel {
  List<DishTypeData>? data;
  RecipePaginationModel? pagination;

  DishTypModel({this.data, this.pagination});

  factory DishTypModel.fromJson(Map<String, dynamic> json) {
    return DishTypModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => DishTypeData.fromJson(i)).toList() : [],
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

class DishTypeData {
  String? categoryImage;
  int? id;
  String? name;
  int? status;

  //LOCAL
  bool? isSelected;

  DishTypeData({this.categoryImage, this.id, this.name, this.status, this.isSelected = false});

  factory DishTypeData.fromJson(Map<String, dynamic> json) {
    return DishTypeData(
      categoryImage: json['category_image'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_image'] = this.categoryImage;
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
