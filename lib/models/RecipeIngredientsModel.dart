class RecipeIngredientsModel {
  String? amount;
  int? id;
  String? name;
  int? recipe_id;
  String? special_use;
  String? unit;

  ///Local variable
  bool? mISCheck;

  RecipeIngredientsModel({this.amount, this.id, this.name, this.recipe_id, this.special_use, this.unit, this.mISCheck = false});

  factory RecipeIngredientsModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientsModel(
      amount: json['amount'],
      id: json['id'],
      name: json['name'],
      recipe_id: json['recipe_id'],
      special_use: json['special_use'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['id'] = this.id;
    data['name'] = this.name;
    data['recipe_id'] = this.recipe_id;
    data['special_use'] = this.special_use;
    data['unit'] = this.unit;
    return data;
  }
}
