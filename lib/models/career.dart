class Career {
  final int id;
  final String title;
  final int industryId;
  final String shortDescription;
  final String detailedDescription;
  final double salaryMin;
  final double salaryMax;
  final String currency;
  final int createdBy;
  final int createdAt;

  Career({
    required this.id,
    required this.title,
    required this.industryId,
    required this.shortDescription,
    required this.detailedDescription,
    required this.salaryMin,
    required this.salaryMax,
    required this.currency,
    required this.createdBy,
    required this.createdAt,
  });

  Career.fromJson(Map<dynamic, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        industryId = json["industry_id"] as int,
        shortDescription = json["short_description"] as String,
        detailedDescription = json["detailed_description"] as String,
        salaryMin = json["salary_min"] as double,
        salaryMax = json["salary_max"] as double,
        currency = json["currency"] as String,
        createdBy = json["created_by"] as int,
        createdAt = json["created_at"] as int;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'industry_id': industryId,
        'short_description': shortDescription,
        'detailed_description': detailedDescription,
        'salary_min': salaryMin,
        'salary_max': salaryMax,
        'currency': currency,
        'created_by': createdBy,
        'created_at': createdAt,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'industry_id': industryId,
        'short_description': shortDescription,
        'detailed_description': detailedDescription,
        'salary_min': salaryMin,
        'salary_max': salaryMax,
        'currency': currency,
        'created_by': createdBy,
        'created_at': createdAt,
      };
}
