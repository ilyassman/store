class UserModel {
  late String userId, email, name, pic;
  late int type;

  UserModel(
      {required this.userId,
      required this.email,
      required this.name,
      required this.pic,
      required this.type});

  UserModel.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    userId = map['userId'] ?? '';
    email = map['email'] ?? '';
    name = map['name'] ?? '';
    pic = map['pic'] ?? '';
    type = map['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'pic': pic,
      'type': type,
    };
  }
}
