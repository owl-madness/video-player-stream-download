import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player_stream_download/model/user_model.dart';
import 'package:video_player_stream_download/repository/app_constants.dart';
import 'package:video_player_stream_download/view/auth/auth_page.dart';
import 'package:video_player_stream_download/view/home/home_page.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckProvider extends ChangeNotifier {
  Future<void> setUserToken(UserModel model) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString(AppConstants.TOKEN, model.auth.accessToken);
    AppConstants.loggedUser = model;
    preferences.setString(AppConstants.userModelString, userModelToJson(model));
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.remove(AppConstants.userModelString);
    AppConstants.loggedUser = UserModel(
        userData: UserData(
            userId: 0,
            firstName: '',
            lastName: '',
            email: '',
            phoneNumber: '',
            gender: 0,
            imageURL: ''),
        auth: Auth(accessToken: '', refreshToken: ''));
    AppConstants.navigatorKey.currentState
        ?.pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticationPage(),));
  }

  Future<void> login(UserModel response, BuildContext context) async {
    try {
      await setUserToken(response);
      AppConstants.navigatorKey.currentState
          ?.pushReplacement(MaterialPageRoute(builder: (context) => const HomePage(),));
    } catch (e) {
      CustomWidgets.showSnackBar(e.toString(), context);
    }
  }

  dispose() {}

  Future<bool> checkTokenExists() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      // return preferences.containsKey(AppConstants.TOKEN);
      if (preferences.containsKey(AppConstants.userModelString)) {
        AppConstants.loggedUser = userModelFromJson(
            preferences.getString(AppConstants.userModelString));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}