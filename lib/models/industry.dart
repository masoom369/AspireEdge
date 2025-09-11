class Industry {
  final String id;
  final String name;

  Industry({required this.id, required this.name});

  factory Industry.fromJson(Map<String, dynamic> json) {
    return Industry(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Industry(id: $id, name: $name)';
}
