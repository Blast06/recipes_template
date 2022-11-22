class RecipeBookMarkResponse {
  String? message;

  RecipeBookMarkResponse({this.message});

  factory RecipeBookMarkResponse.fromJson(Map<String, dynamic> json) {
    return RecipeBookMarkResponse(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
