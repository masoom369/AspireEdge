

abstract class Resource {
  final String title;
  final String description;

  Resource({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap();
}

class Blog extends Resource {
  Blog({
    required super.title,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() => {
        'type': 'Blog',
        'title': title,
        'description': description,
      };

  factory Blog.fromMap(Map<String, dynamic> map) => Blog(
        title: map['title'],
        description: map['description'],
      );
}

class EBook extends Resource {
  final String link;

  EBook({
    required super.title,
    required super.description,
    required this.link,
  });

  @override
  Map<String, dynamic> toMap() => {
        'type': 'eBook',
        'title': title,
        'description': description,
        'link': link,
      };

  factory EBook.fromMap(Map<String, dynamic> map) => EBook(
        title: map['title'],
        description: map['description'],
        link: map['link'],
      );
}

class Video extends Resource {
  final String link;

  Video({
    required super.title,
    required super.description,
    required this.link,
  });

  @override
  Map<String, dynamic> toMap() => {
        'type': 'Video',
        'title': title,
        'description': description,
        'link': link,
      };

  factory Video.fromMap(Map<String, dynamic> map) => Video(
        title: map['title'],
        description: map['description'],
        link: map['link'],
      );
}

class Gallery extends Resource {
  final List<String> images;

  Gallery({
    required super.title,
    required super.description,
    required this.images,
  });

  @override
  Map<String, dynamic> toMap() => {
        'type': 'Gallery',
        'title': title,
        'description': description,
        'images': images,
      };

  factory Gallery.fromMap(Map<String, dynamic> map) => Gallery(
        title: map['title'],
        description: map['description'],
        images: List<String>.from(map['images'] ?? []),
      );
}
