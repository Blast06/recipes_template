import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/models/RecipeStepModel.dart';
import 'package:recipe_app/utils/Widgets.dart';

import 'RecipeDetailModel.dart';

class RecipeModel {
  String? bakingTime;
  String? cuisine;
  String? difficulty;
  String? dish_type;
  List<ImageModel>? recipe_image;
  String? portionType;
  int? portionUnit;
  String? preparationTime;
  String? restingTime;
  int? status;
  String? title;
  String? user_name;
  String? user_profile_image;
  String? created_at;
  int? user_id;
  int? id;
  int? bookmarkId;
  List<ImageModel>? recipe_image_gallery;

  int? is_bookmark;
  int? is_like;
  num? total_rating;
  int? total_review;
  int? like_count;
  int? attachment_count;

  //Local
  List<Ingredient>? ingredients;
  List<RecipeStepModel>? steps;

  File? recipeFile;
  int? totalLike;
  List<Uint8List>? fileBytes;
  Uint8List? fileByte;

  Widget recipeImageWidget(double? width) {
    if (recipe_image!.isEmpty) {
      return Image.asset(
        'images/placeholder.jpg',
        fit: BoxFit.cover,
        height: 200,
        width: width,
      ).cornerRadiusWithClipRRect(defaultRadius);
    } else {
      return commonCachedNetworkImage(
        recipe_image![0].url.validate(),
        fit: BoxFit.cover,
        height: 200,
        width: width,
      ).cornerRadiusWithClipRRect(defaultRadius);
    }
  }

  RecipeModel({
    this.bakingTime,
    this.cuisine,
    this.difficulty,
    this.dish_type,
    this.recipe_image,
    this.portionType,
    this.portionUnit,
    this.preparationTime,
    this.restingTime,
    this.status,
    this.title,
    this.user_id,
    this.user_name,
    this.user_profile_image,
    this.id,
    this.is_bookmark,
    this.created_at,
    this.ingredients,
    this.is_like,
    this.total_rating,
    this.total_review,
    this.like_count,
    this.recipeFile,
    this.totalLike,
    this.bookmarkId,
    this.recipe_image_gallery,
    this.attachment_count,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      bakingTime: json['baking_time'],
      cuisine: json['cuisine'],
      difficulty: json['difficulty'],
      dish_type: json['dish_type'],
      recipe_image: json['recipe_image'] != null ? (json['recipe_image'] as List).map((e) => ImageModel.fromJson(e)).toList() : [],
      portionType: json['portion_type'],
      portionUnit: json['portion_unit'],
      preparationTime: json['preparation_time'],
      restingTime: json['resting_time'],
      status: json['status'],
      title: json['title'],
      user_id: json['user_id'],
      user_name: json['user_name'],
      user_profile_image: json['user_profile_image'],
      id: json['id'],
      ingredients: json['ingredients'] != null ? (json['ingredients'] as List).map((i) => Ingredient.fromJson(i)).toList() : null,
      is_bookmark: json['is_bookmark'],
      is_like: json['is_like'],
      total_rating: json['total_rating'],
      total_review: json['total_review'],
      like_count: json['like_count'],
      created_at: json['created_at'],
      bookmarkId: json['bookmark_id'],
      recipe_image_gallery: json['recipe_image_gallery'] != null ? (json['recipe_image_gallery'] as List).map((e) => ImageModel.fromJson(e)).toList() : [],
      attachment_count: json['attachment_count'],
    );
  }

  //      map['menu_image'] = menuImage?.map((v) => v.toJson()).toList();
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baking_time'] = this.bakingTime;
    data['difficulty'] = this.difficulty;
    data['recipe_image'] = this.recipe_image!.map((e) => e.toJson());
    data['portion_type'] = this.portionType;
    data['portion_unit'] = this.portionUnit;
    data['preparation_time'] = this.preparationTime;
    data['resting_time'] = this.restingTime;
    data['status'] = this.status;
    data['title'] = this.title;
    data['user_name'] = this.user_name;
    data['created_at'] = this.created_at;
    data['user_profile_image'] = this.user_profile_image;
    data['user_id'] = this.user_id;
    data['cuisine'] = this.cuisine;
    data['dish_type'] = this.dish_type;
    data['id'] = this.id;
    data['is_bookmark'] = this.is_bookmark;
    data['is_like'] = this.is_like;
    data['total_rating'] = this.total_rating;
    data['total_review'] = this.total_review;
    data['like_count'] = this.like_count;
    data['bookmark_id'] = this.bookmarkId;
    data['attachment_count'] = this.attachment_count;
    if (this.ingredients != null) {
      data['ingredients'] = this.ingredients!.map((v) => v.toJson()).toList();
    }
    if (this.recipe_image_gallery != null) {
      data['recipe_image_gallery'] = this.recipe_image_gallery!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
