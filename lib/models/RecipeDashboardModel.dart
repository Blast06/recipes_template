import 'package:recipe_app/models/RecipeModel.dart';

class RecipeDashboardModel {
  List<Category>? category;
  List<RecipeModel>? latestRecipe;
  List<SliderData>? slider;
  bool? status;

  RecipeDashboardModel({this.category, this.latestRecipe, this.status, this.slider});

  factory RecipeDashboardModel.fromJson(Map<String, dynamic> json) {
    return RecipeDashboardModel(
      category: json['category'] != null ? (json['category'] as List).map((i) => Category.fromJson(i)).toList() : null,
      latestRecipe: json['latestRecipe'] != null ? (json['latestRecipe'] as List).map((i) => RecipeModel.fromJson(i)).toList() : null,
      slider: json['slider'] != null ? (json['slider'] as List).map((i) => SliderData.fromJson(i)).toList() : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.latestRecipe != null) {
      data['latestRecipe'] = this.latestRecipe!.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? category_image;
  int? id;
  String? name;
  int? status;

  Category({this.category_image, this.id, this.name, this.status});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_image: json['category_image'],
      id: json['id'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_image'] = this.category_image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}

class SliderData {
  int? id;
  String? title;
  String? type;
  String? type_id;
  int? status;
  String? description;
  String? type_name;
  String? slider_image;

  ///Local Variable
  bool mISelect;

  SliderData({this.id, this.title, this.type, this.type_id, this.status, this.description, this.type_name, this.slider_image, this.mISelect = false});

  factory SliderData.fromJson(Map<String, dynamic> json) {
    return SliderData(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      type_id: json['type_id'],
      status: json['status'],
      description: json['description'],
      type_name: json['type_name'],
      slider_image: json['slider_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    data['type_id'] = this.type_id;
    data['status'] = this.status;
    data['description'] = this.description;
    data['type_name'] = this.type_name;
    data['slider_image'] = this.slider_image;
    return data;
  }
}
