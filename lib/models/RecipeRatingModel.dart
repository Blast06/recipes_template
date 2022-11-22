class RecipeRatingModel {
  int? id;
  dynamic rating;
  int? recipe_id;
  String? review;
  int? user_id;
  String? profile_image;
  String? username;

  RecipeRatingModel({this.id, this.rating, this.recipe_id, this.review, this.user_id, this.profile_image, this.username});

  factory RecipeRatingModel.fromJson(Map<String, dynamic> json) {
    return RecipeRatingModel(
      id: json['id'],
      rating: json['rating'],
      recipe_id: json['recipe_id'],
      review: json['review'],
      user_id: json['user_id'],
      profile_image: json['profile_image'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['recipe_id'] = this.recipe_id;
    data['review'] = this.review;
    data['user_id'] = this.user_id;
    data['profile_image'] = this.profile_image;
    data['username'] = this.username;
    return data;
  }
}
