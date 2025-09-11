class CareerSkill {
  final String id;
  final String name;

  CareerSkill({required this.id, required this.name});

  factory CareerSkill.fromJson(Map<String, dynamic> json) {
    return CareerSkill(
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
  String toString() => 'CareerSkill(id: $id, name: $name)';
}
