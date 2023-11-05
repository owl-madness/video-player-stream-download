import 'package:flutter/cupertino.dart';
import 'package:video_player_stream_download/model/data_model.dart';
import 'package:video_player_stream_download/model/video_model.dart';
import 'package:video_player_stream_download/repository/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreProvider extends ChangeNotifier {
  Future<bool> initSharedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.containsKey(AppConstants.userModelString)) {
        // AppConstants.loggedUser = userModelFromJson(
        //     sharedPreferences.getString(AppConstants.userModelString));
      }
      if (sharedPreferences
          .containsKey(AppConstants.avialbleVideosListString)) {
        // AppConstants.availableVideos = videomodelFromJson(
        //     sharedPreferences.getString(AppConstants.avialbleVideosListString));
      } else {
        // declare videos

        List<VideoModel> tempList = [];
        int index = 0;
        VideoCategory.data = VideoCategory.fromJson(AppConstants.jsonMap);
        if (VideoCategory.data != null) {
          print('Category Name: ${VideoCategory.data!.name}');
          for (var category in VideoCategory.data!.categories!) {
            print('Category Name: ${category.name}');
            for (var video in category.videos!) {
              print('Video Title: ${video.title}');
              tempList.add(
                VideoModel(
                  id: index,
                  url: video.sources?[0] ?? '',
                  isDownloaded: false,
                  localPathDirectory:  null,
                  title: video.title ??'',
                ),
              );
              index++;
            }
          }
        }

        print('tempList length---- ${tempList.length}');

        AppConstants.availableVideos = [
          VideoModel(
              id: 1,
              isDownloaded: false,
              localPathDirectory: null,
              url:
                  'https://drive.google.com/u/2/uc?id=1z-xRG-llBx1FszFwWY0ql9bAVyc9fSDe',
              title: 'earth'),
          VideoModel(
              id: 2,
              isDownloaded: false,
              localPathDirectory: null,
              url:
                  'https://drive.google.com/u/2/uc?id=1SlqiA7ls01VjIikhDWtE4JsxhKcJz5wf',
              title: 'butterfly'),
          VideoModel(
              id: 3,
              isDownloaded: false,
              localPathDirectory: null,
              url:
                  'https://drive.google.com/u/2/uc?id=1nMkJGFwxS3zIsX4VfdJrt8kq4UMRtCE3',
              title: 'dandelion'),
        ];
        print(
            'AppConstants.availableVideos length ${AppConstants.availableVideos.length}');
        sharedPreferences.setString(AppConstants.avialbleVideosListString,
            videoModelToJson(AppConstants.availableVideos));

        print('avlble videoosss ${AppConstants.availableVideos}');

        print('videoModelToJson(AppConstants.availableVideos) ${videoModelToJson(AppConstants.availableVideos)}');

        print('prefes avlVideos ${sharedPreferences.getString(AppConstants.avialbleVideosListString)}');
      }
    } catch (e) {
      print(e.toString());
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }
}
