import 'dart:io';

import 'package:recipe_app/models/ImageModel.dart';
import 'package:recipe_app/models/RecipeUtensilsModel.dart';

class RecipeStepModel {
  String? description;
  int? id;
  List<ImageModel>? recipe_step_image;
  String? ingredient_used_id;
  String? media_link;
  int? recipe_id;
  List<StepUtensil>? utensil;
  List<ImageModel>? step_image_gallery;
  int? attachment_count;

  //Local
  File? stepImage;

  RecipeStepModel({
    this.description,
    this.id,
    this.recipe_step_image,
    this.ingredient_used_id,
    this.media_link,
    this.recipe_id,
    this.utensil,
    this.step_image_gallery,
    this.attachment_count,
  });

  factory RecipeStepModel.fromJson(Map<String, dynamic> json) {
    return RecipeStepModel(
      description: json['description'],
      id: json['id'],
      recipe_step_image: json['recipe_step_image'] != null ? (json['recipe_step_image'] as List).map((e) => ImageModel.fromJson(e)).toList() : [],
      ingredient_used_id: json['ingredient_used_id'],
      media_link: json['media_link'],
      recipe_id: json['recipe_id'],
      attachment_count: json['attachment_count'],
      utensil: json['utensil'] != null ? (json['utensil'] as List).map((i) => StepUtensil.fromJson(i)).toList() : [],
      step_image_gallery:
          json['step_image_gallery'] != null ? (json['step_image_gallery'] as List).map((e) => ImageModel.fromJson(e)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['recipe_step_image'] = this.recipe_step_image!.map((e) => e.toJson());
    data['ingredient_used_id'] = this.ingredient_used_id;
    data['media_link'] = this.media_link;
    data['recipe_id'] = this.recipe_id;
    data['attachment_count'] = this.attachment_count;
    data['utensil'] = this.utensil;
    if (this.step_image_gallery != null) {
      data['step_image_gallery'] = this.step_image_gallery!.map((e) => e.toJson());
    }
    return data;
  }
}
