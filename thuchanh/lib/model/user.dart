class User {
  String? username;
  String? password;
  String? role;

  User({required this.username, required this.password, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role,
    };
  }
}
