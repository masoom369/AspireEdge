class ResourceType {
  final String id;
  final String type;

  ResourceType({required this.id, required this.type});

  factory ResourceType.fromJson(Map<String, dynamic> json) {
    return ResourceType(
      id: json['id'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }

  @override
  String toString() => 'ResourceType(id: $id, type: $type)';
}
