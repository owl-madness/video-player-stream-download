import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:video_player_stream_download/model/video_model.dart';
import 'package:video_player_stream_download/repository/app_constants.dart';
import 'package:video_player_stream_download/repository/shared_preference_helper.dart';
import 'package:video_player_stream_download/repository/video_repository.dart';
import 'package:video_player_stream_download/utilities/encryption.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class HomeProvider extends ChangeNotifier {
  VideoPlayerController videoPlayerController =
      VideoPlayerController.networkUrl(Uri.parse(AppConstants.availableVideos[0].url));
  int index = 0;
  bool downloadLoader = false;
  late String deCryptFilePath;

  Stream<String> get downloadStatus => _downloadStatus.stream;

  UniqueKey urlKey = UniqueKey();

  final StreamController<String> _downloadStatus =
      StreamController<String>.broadcast();

  attachVideoTOPlayer(BuildContext context) async {
    try {
      if (AppConstants.availableVideos.isNotEmpty) {
        if (AppConstants.availableVideos[index].isDownloaded) {
          deCryptFilePath = await EncryptData.decryptFile(
              AppConstants.availableVideos[index].localPathDirectory!,
              '${AppConstants.availableVideos[index].title}.mp4');
          videoPlayerController =
              VideoPlayerController.file(File(deCryptFilePath))
                ..initialize().then((_) {
                  // setState(() {});
                }).onError((error, stackTrace) => CustomWidgets.showSnackBar(
                    "Issue with loading video from local storage", context));
        } else {
          videoPlayerController = VideoPlayerController.networkUrl(
              Uri.parse(AppConstants.availableVideos[index].url ?? ''))
            ..initialize().then((_) {
              // setState(() {});
            }).onError((error, stackTrace) {
              print('video player error : $error');
              return CustomWidgets.showSnackBar(
                  "Issue with streaming video", context);
            });
        }
      } else {
        debugPrint("availableVideos.isEmpty");
      }
      // setState(() {
      //   _urlKey = UniqueKey();
      // });
    } catch (e) {
      CustomWidgets.showSnackBar(e.toString(), context);
    }
    notifyListeners();
  }

  playPrevVideo(BuildContext context) async {
    index -= 1;
    videoPlayerController.pause();
    videoPlayerController.dispose();
    await attachVideoTOPlayer(context);
    notifyListeners();
  }

  void delete(BuildContext context) async {
    try {
      File(AppConstants.availableVideos[index].localPathDirectory!).delete();
      CustomWidgets.showSnackBar("Deleted from local storage", context);
      // setState(() {
      AppConstants.availableVideos[index].isDownloaded = false;
      AppConstants.availableVideos[index].localPathDirectory = null;
      notifyListeners();
      await updateVideoLibrary();
    } catch (e) {
      CustomWidgets.showSnackBar("Delete task failed", context);
    }
    notifyListeners();
  }

  downloadFile(String url, String filename) async {
    try {
      _downloadStatus.sink.add("");
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();

      print('storage status ${await Permission.storage.status} ');

      if (await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        print('dwnload1');
        Directory? appDocDir = await getExternalStorageDirectory();
        print('dwnload2');
        final VideoRepository repository = VideoRepository();
        print('dwnload3 $url');
        print('pathname ${appDocDir?.path}/$filename}');
        await repository.downloadFile(url, '${appDocDir?.path}/$filename',
            (String text) {
          _downloadStatus.sink.add(text);
        });
        print('dwnload4');
        _downloadStatus.sink.add("Encrypting file...");
        print('dwnload5');
        return EncryptData.encryptFile('${appDocDir?.path}/$filename');
      } else {
        _downloadStatus.sink.addError("File access permission denied");
      }
    } catch (e) {
      _downloadStatus.sink.addError(e.toString());
      return null;
    }
    notifyListeners();
  }

  download(BuildContext context) async {
    downloadLoader = true;
    final String? downloadedPath = await downloadFile(
        AppConstants.availableVideos[index].url,
        "${AppConstants.availableVideos[index].url}.mp4");

    downloadLoader = false;
    if (downloadedPath != null) {
      AppConstants.availableVideos[index].isDownloaded = true;
      AppConstants.availableVideos[index].localPathDirectory = downloadedPath;
      //update path string in local storage
      await updateVideoLibrary();
      await attachVideoTOPlayer(context);
    }
    notifyListeners();
  }

  playNextVideo(BuildContext context) async {
    index += 1;
    videoPlayerController.pause();
    videoPlayerController.dispose();
    await attachVideoTOPlayer(context);
    notifyListeners();
  }

  updateVideoLibrary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.avialbleVideosListString,
        videoModelToJson(AppConstants.availableVideos));
    notifyListeners();
  }

  void initialiseVideoData(BuildContext context) async {
    attachVideoTOPlayer(context);
    SharedPrefHelper().fetchVideoLibrary();
    notifyListeners();
    // AppConstants.availableVideos = [
    //   VideoModel(
    //       id: 1,
    //       isDownloaded: false,
    //       localPathDirectory: null,
    //       url:
    //       'https://drive.google.com/u/2/uc?id=1z-xRG-llBx1FszFwWY0ql9bAVyc9fSDe',
    //       title: 'earth'),
    //   VideoModel(
    //       id: 2,
    //       isDownloaded: false,
    //       localPathDirectory: null,
    //       url:
    //       'https://drive.google.com/u/2/uc?id=1SlqiA7ls01VjIikhDWtE4JsxhKcJz5wf',
    //       title: 'butterfly'),
    //   VideoModel(
    //       id: 3,
    //       isDownloaded: false,
    //       localPathDirectory: null,
    //       url:
    //       'https://drive.google.com/u/2/uc?id=1nMkJGFwxS3zIsX4VfdJrt8kq4UMRtCE3',
    //       title: 'dandelion'),
    // ];
    // videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     // setState(() {});
    //   });
    notifyListeners();
    // var deCryptFilePath = await EncryptData.decryptFile(
    //     AppConstants.availableVideos[index].localPathDirectory!,
    //     '${AppConstants.availableVideos[index].title}.mp4');

    // videoPlayerController = VideoPlayerController.file(File(deCryptFilePath))
    //   ..initialize();
  }
}
