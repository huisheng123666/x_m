class User {
  final String userName;
  final String? token;
  final int userId;

  User({required this.userName, this.token = '', required this.userId});

  factory User.formatJson(Map<String, dynamic> data) {
    return User(
      userName: data['userName'],
      token: data['token'] ?? '',
      userId: data['userId'],
    );
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['userName'] = userName;
    m['token'] = token;
    m['userId'] = userId;

    return m;
  }
}
