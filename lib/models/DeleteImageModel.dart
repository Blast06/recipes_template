/// status : true
/// message : "Recipe remove successfully"

class DeleteImageModel {
  bool? _status;
  String? _message;

  DeleteImageModel({bool? status, String? message}) {
    _status = status;
    _message = message;
  }

  DeleteImageModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  DeleteImageModel copyWith({bool? status, String? message}) => DeleteImageModel(status: status ?? _status, message: message ?? _message);

  bool? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}
