class ResourceTag {
  final String id;
  final String name;

  ResourceTag({required this.id, required this.name});

  factory ResourceTag.fromJson(Map<String, dynamic> json) {
    return ResourceTag(
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
  String toString() => 'ResourceTag(id: $id, name: $name)';
}
