class VideoCategory {
  String? name;
  List<Category>? categories;

  VideoCategory({
    this.name,
    this.categories,
  });

  factory VideoCategory.fromJson(Map<String, dynamic> json) => VideoCategory(
    name: json["name"],
    categories: json["categories"] == null
        ? []
        : List<Category>.from((json["categories"] as List<dynamic>)
        .map((x) => Category.fromJson(x as Map<String, dynamic>)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "categories": categories == null
        ? []
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };

  static VideoCategory? data; // Static variable to hold the data
}

class Category {
  String? name;
  List<Video>? videos;

  Category({
    this.name,
    this.videos,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    videos: json["videos"] == null
        ? []
        : List<Video>.from((json["videos"] as List<dynamic>)
        .map((x) => Video.fromJson(x as Map<String, dynamic>))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "videos": videos == null
        ? []
        : List<dynamic>.from(videos!.map((x) => x.toJson())),
  };
}

class Video {
  String? description;
  List<String>? sources;
  String? subtitle;
  String? thumb;
  String? title;

  Video({
    this.description,
    this.sources,
    this.subtitle,
    this.thumb,
    this.title,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    description: json["description"],
    sources: json["sources"] == null
        ? []
        : List<String>.from((json["sources"] as List<dynamic>).map((x) => x as String)),
    subtitle: json["subtitle"],
    thumb: json["thumb"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "sources": sources == null ? [] : List<dynamic>.from(sources!.map((x) => x)),
    "subtitle": subtitle,
    "thumb": thumb,
    "title": title,
  };
}
