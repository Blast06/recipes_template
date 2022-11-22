class RecipeUtensilsModel {
  int? recipe_id;
  int? step_id;
  List<StepUtensil>? step_utensils;

  RecipeUtensilsModel({this.recipe_id, this.step_id, this.step_utensils});

  factory RecipeUtensilsModel.fromJson(Map<String, dynamic> json) {
    return RecipeUtensilsModel(
      recipe_id: json['recipe_id'],
      step_id: json['step_id'],
      step_utensils: json['step_utensils'] != null ? (json['step_utensils'] as List).map((i) => StepUtensil.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipe_id'] = this.recipe_id;
    data['step_id'] = this.step_id;
    if (this.step_utensils != null) {
      data['step_utensils'] = this.step_utensils!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StepUtensil {
  String? amount;
  int? id;
  String? name;
  int? sequence;
  String? special_use;
  int? step_id;

  StepUtensil({this.amount, this.id, this.name, this.sequence, this.special_use, this.step_id});

  factory StepUtensil.fromJson(Map<String, dynamic> json) {
    return StepUtensil(
      amount: json['amount'],
      id: json['id'],
      name: json['name'],
      sequence: json['sequence'],
      special_use: json['special_use'],
      step_id: json['step_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['id'] = this.id;
    data['name'] = this.name;
    data['sequence'] = this.sequence;
    data['special_use'] = this.special_use;
    data['step_id'] = this.step_id;
    return data;
  }
}
