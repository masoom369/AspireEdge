class Resource {
  final String id;
  final String name;
  final String type;

  Resource({required this.id, required this.name, required this.type});

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  @override
  String toString() => 'Resource(id: $id, name: $name, type: $type)';
}
