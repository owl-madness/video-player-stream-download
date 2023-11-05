import 'dart:convert';

List<VideoModel> videoModelFromJson(String? str) =>
    List<VideoModel>.from(json.decode(str!).map((x) => VideoModel.fromJson(x)));

String videoModelToJson(List<VideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
  VideoModel(
      {required this.id,
      required this.url,
      required this.isDownloaded,
      required this.localPathDirectory,
      required this.title});

  final int id;
  final String url;
  bool isDownloaded;
  String? localPathDirectory;
  final String title;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["id"],
        url: json["url"],
        title: json["title"],
        isDownloaded: json["isDownloaded"],
        localPathDirectory: json["localPathDirectory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "title": title,
        "isDownloaded": isDownloaded,
        "localPathDirectory": localPathDirectory,
      };
}
