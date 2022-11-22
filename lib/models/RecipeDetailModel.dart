import 'package:recipe_app/models/RecipeModel.dart';
import 'package:recipe_app/models/RecipeRatingModel.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';

class RecipeDetailModel {
  List<RecipeRatingModel>? rating;
  RecipeModel? recipes;
  List<RecipeStepModel>? steps;
  RecipeRatingModel? user_rating;

  RecipeDetailModel({this.rating, this.recipes, this.steps, this.user_rating});

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
      rating: json['rating'] != null ? (json['rating'] as List).map((i) => RecipeRatingModel.fromJson(i)).toList() : null,
      recipes: json['recipes'] != null ? RecipeModel.fromJson(json['recipes']) : null,
      steps: json['steps'] != null ? (json['steps'] as List).map((i) => RecipeStepModel.fromJson(i)).toList() : null,
      user_rating: json['user_rating'] != null ? RecipeRatingModel.fromJson(json['user_rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rating != null) {
      data['rating'] = this.rating!.map((v) => v.toJson()).toList();
    }
    if (this.recipes != null) {
      data['recipes'] = this.recipes!.toJson();
    }
    if (this.steps != null) {
      data['steps'] = this.steps!.map((v) => v.toJson()).toList();
    }
    if (this.user_rating != null) {
      data['user_rating'] = this.user_rating!.toJson();
    }
    return data;
  }
}

class Step {
  String? description;
  int? id;
  String? ingredient_used_id;
  int? recipe_id;
  List<Utensil>? utensil;
  String? recipe_step_image;

  Step({this.description, this.id, this.ingredient_used_id, this.recipe_id, this.utensil, this.recipe_step_image});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      description: json['description'],
      id: json['id'],
      ingredient_used_id: json['ingredient_used_id'],
      recipe_id: json['recipe_id'],
      utensil: json['utensil'] != null ? (json['utensil'] as List).map((i) => Utensil.fromJson(i)).toList() : null,
      recipe_step_image: json['recipe_step_image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['ingredient_used_id'] = this.ingredient_used_id;
    data['recipe_id'] = this.recipe_id;
    data['recipe_step_image'] = this.recipe_step_image;
    if (this.utensil != null) {
      data['utensil'] = this.utensil!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Utensil {
  String? amount;
  String? created_at;
  int? id;
  String? name;
  int? recipe_id;
  int? sequence;
  String? special_use;
  int? step_id;
  String? updated_at;

  Utensil({this.amount, this.created_at, this.id, this.name, this.recipe_id, this.sequence, this.special_use, this.step_id, this.updated_at});

  factory Utensil.fromJson(Map<String, dynamic> json) {
    return Utensil(
      amount: json['amount'],
      created_at: json['created_at'],
      id: json['id'],
      name: json['name'],
      recipe_id: json['recipe_id'],
      sequence: json['sequence'],
      special_use: json['special_use'],
      step_id: json['step_id'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['name'] = this.name;
    data['recipe_id'] = this.recipe_id;
    data['sequence'] = this.sequence;
    data['special_use'] = this.special_use;
    data['step_id'] = this.step_id;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

class Ingredient {
  String? amount;
  String? created_at;
  int? id;
  String? name;
  int? recipe_id;
  String? special_use;
  String? unit;
  String? updated_at;

  ///Local Variable
  bool? mISCheck;

  Ingredient({this.amount, this.created_at, this.id, this.name, this.recipe_id, this.special_use, this.unit, this.updated_at, this.mISCheck = false});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      amount: json['amount'],
      created_at: json['created_at'],
      id: json['id'],
      name: json['name'],
      recipe_id: json['recipe_id'],
      special_use: json['special_use'],
      unit: json['unit'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['name'] = this.name;
    data['recipe_id'] = this.recipe_id;
    data['special_use'] = this.special_use;
    data['unit'] = this.unit;
    data['updated_at'] = this.updated_at;
    return data;
  }
}
