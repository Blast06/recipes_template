class LoginResponse {
  UserData? userData;

  LoginResponse({this.userData});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userData: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['data'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? api_token;
  String? bio;
  String? created_at;
  String? dob;
  String? email;
  String? email_verified_at;
  String? gender;
  int? id;
  String? name;
  String? player_id;
  String? profile_image;
  int? status;
  String? updated_at;
  String? user_type;
 // String? username;

  UserData({
    this.api_token,
    this.bio,
    this.created_at,
    this.dob,
    this.email,
    this.email_verified_at,
    this.gender,
    this.id,
    this.name,
    this.player_id,
    this.profile_image,
    this.status,
    this.updated_at,
    this.user_type,
    //this.username,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      api_token: json['api_token'],
      bio: json['bio'],
      created_at: json['created_at'],
      dob: json['dob'],
      email: json['email'],
      email_verified_at: json['email_verified_at'],
      gender: json['gender'],
      id: json['id'],
      name: json['name'],
      player_id: json['player_id'],
      profile_image: json['profile_image'],
      status: json['status'],
      updated_at: json['updated_at'],
      user_type: json['user_type'],
     // username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = this.api_token;
    data['bio'] = this.bio;
    data['created_at'] = this.created_at;
    data['dob'] = this.dob;
    data['email'] = this.email;
    data['email_verified_at'] = this.email_verified_at;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['name'] = this.name;
    data['player_id'] = this.player_id;
    data['profile_image'] = this.profile_image;
    data['status'] = this.status;
    data['updated_at'] = this.updated_at;
    data['user_type'] = this.user_type;
    //data['username'] = this.username;
    return data;
  }
}
