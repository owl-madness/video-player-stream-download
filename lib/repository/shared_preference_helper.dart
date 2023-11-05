import 'package:flutter/cupertino.dart';
import 'package:video_player_stream_download/controller/profile/profile_provider.dart';
import 'package:video_player_stream_download/model/user_model.dart';
import 'package:video_player_stream_download/model/video_model.dart';
import 'package:video_player_stream_download/repository/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  // late SharedPreferences pref;
  static String userLoggedStateKey = 'LOGGED_STATE';
  static String darkModeKey = 'DARK_MODE';
  static String userNameKey = 'USER_NAME';
  static String userEmailKey = 'USER_EMAIL';
  static String userDobKey = 'USER_DOB';

  initSharedPref(BuildContext context) async {
    debugPrint("init shrd ");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var name = pref.getString(userNameKey) ?? '';
    var email = pref.getString(userEmailKey) ?? '';
    var dob = pref.getString(userDobKey) ?? '';
    var darkMode = pref.getBool(darkModeKey) ?? false;

    Provider.of<ProfileProvider>(context, listen: false)
      ..userNameController.text = name
      ..userEmailController.text = email
      ..userDobController.text = dob
      ..name = name
      ..email = email
      ..dob = dob
      ..darkModeEnabled = darkMode;
    debugPrint("finish init shrd");
    return pref;
  }

  fetchVideoLibrary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AppConstants.availableVideos = videoModelFromJson( prefs.getString(AppConstants.avialbleVideosListString));
  }

  changeDarkMode(bool darkMode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(darkModeKey, darkMode);
  }

  changeUserLoggedState(bool loggedState) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(userLoggedStateKey, loggedState);
  }

  saveUserDetails(UserData userData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(userNameKey, userData.firstName);
    pref.setString(userEmailKey, userData.email);
    pref.setString(userDobKey, userData.dob ?? '');
  }

  Future<bool> removeSharedData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.clear();
  }
}
