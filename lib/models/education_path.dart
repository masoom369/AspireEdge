class EducationPath {
  final String id;
  final String name;

  EducationPath({required this.id, required this.name});

  factory EducationPath.fromJson(Map<String, dynamic> json) {
    return EducationPath(
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
  String toString() => 'EducationPath(id: $id, name: $name)';
}
