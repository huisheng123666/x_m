import 'package:x_m/models/user.dart';

class CommentModel {
  final String text;
  final User user;
  final String createTime;

  CommentModel(
      {required this.text, required this.user, required this.createTime});

  factory CommentModel.formatJson(Map<String, dynamic> data) {
    return CommentModel(
        text: data['text'],
        user: User.formatJson(data['user']),
        createTime: data['createTime']);
  }

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['text'] = text;
    m['user'] = user.toJSONEncodable();
    m['createTime'] = createTime;

    return m;
  }
}
