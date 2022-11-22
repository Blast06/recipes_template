class RecipePaginationModel {
  int? currentPage;
  int? from;
  String? next_page;
  var per_page;
  String? previous_page;
  int? to;
  int? totalPages;
  int? total_items;

  RecipePaginationModel({this.currentPage, this.from, this.next_page, this.per_page, this.previous_page, this.to, this.totalPages, this.total_items});

  factory RecipePaginationModel.fromJson(Map<String, dynamic> json) {
    return RecipePaginationModel(
      currentPage: json['currentPage'],
      from: json['from'],
      next_page: json['next_page'],
      per_page: json['per_page'],
      previous_page: json['previous_page'],
      to: json['to'],
      totalPages: json['totalPages'],
      total_items: json['total_items'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['from'] = this.from;
    data['next_page'] = this.next_page;
    data['per_page'] = this.per_page;
    data['previous_page'] = this.previous_page;
    data['to'] = this.to;
    data['totalPages'] = this.totalPages;
    data['total_items'] = this.total_items;
    return data;
  }
}
