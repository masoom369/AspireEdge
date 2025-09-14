class Career {
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String salaryRange;
  final EducationPath educationPath;
  final String imageBase64; // 👈 NEW FIELD
  final String industry;   // 👈 NEW FIELD

  Career({
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.salaryRange,
    required this.educationPath,
    this.imageBase64 = "", // Default to empty string
    required this.industry,  // NEW PARAMETER
  });

  factory Career.fromJson(Map<String, dynamic> json) {
    return Career(
      title: json['title'] as String,
      description: json['description'] as String,
      requiredSkills: _parseStringList(json['requiredSkills']),
      salaryRange: json['salaryRange'] as String,
      educationPath: EducationPath.fromJson(
        json['educationPath'] as Map<String, dynamic>,
      ),
      imageBase64: json['imageBase64'] as String? ?? "", // 👈 Parse from JSON
      industry: json['industry'] as String, // 👈 Parse industry
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'requiredSkills': requiredSkills,
      'salaryRange': salaryRange,
      'educationPath': educationPath.toJson(),
      'imageBase64': imageBase64, // 👈 Include in serialization
      'industry': industry,     // 👈 Include industry in serialization
    };
  }

  @override
  String toString() =>
      'Career(title: $title, description: $description, requiredSkills: $requiredSkills, salaryRange: $salaryRange, educationPath: $educationPath, imageBase64: ${imageBase64.isNotEmpty ? "(has image)" : "(no image)"}, industry: $industry)';
}

List<String> _parseStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) return value.cast<String>();
  if (value is Map<String, dynamic>) {
    final List<String> result = [];
    value.forEach((_, v) {
      if (v is String) result.add(v);
    });
    return result;
  }
  return [];
}

class EducationPath {
  final List<String> recommendedDegrees;
  final List<String> certifications;

  EducationPath({
    required this.recommendedDegrees,
    required this.certifications,
  });

  factory EducationPath.fromJson(Map<String, dynamic> json) {
    return EducationPath(
      recommendedDegrees: _parseStringList(json['recommendedDegrees']),
      certifications: _parseStringList(json['certifications']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendedDegrees': recommendedDegrees,
      'certifications': certifications,
    };
  }

  @override
  String toString() =>
      'EducationPath(recommendedDegrees: $recommendedDegrees, certifications: $certifications)';
}

