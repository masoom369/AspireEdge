class PushToken {
  final String id;
  final String token;

  PushToken({required this.id, required this.token});

  factory PushToken.fromJson(Map<String, dynamic> json) {
    return PushToken(
      id: json['id'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
    };
  }

  @override
  String toString() => 'PushToken(id: $id, token: $token)';
}
