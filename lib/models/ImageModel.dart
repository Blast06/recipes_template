class ImageModel {
  int? id;
  String? url;

  ImageModel({this.id, this.url});

  ImageModel.fromJson(dynamic json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['url'] = url;
    return map;
  }
}