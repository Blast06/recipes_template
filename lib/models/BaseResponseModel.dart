class BaseResponseModel {
  String? message;
  int? stepId;
  int? ingredientId;

  BaseResponseModel({this.message, this.stepId, this.ingredientId});

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      message: json['message'],
      stepId: json['step_id'],
      ingredientId: json['ingredient_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['step_id'] = this.stepId;
    data['ingredient_id'] = this.ingredientId;
    return data;
  }
}
