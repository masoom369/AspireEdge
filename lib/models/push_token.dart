class PushToken {
  final int id;
  final int userId;
  final String token;
  final String platform;

  PushToken({
    required this.id,
    required this.userId,
    required this.token,
    required this.platform,
  });

  PushToken.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        userId = json["user_id"] as int,
        token = json["token"] as String,
        platform = json["platform"] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'token': token,
        'platform': platform,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'token': token,
        'platform': platform,
      };
}
