import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player_stream_download/model/user_model.dart';
import 'package:video_player_stream_download/model/video_model.dart';
import 'package:video_player_stream_download/repository/app_constants.dart';
import 'package:video_player_stream_download/repository/shared_preference_helper.dart';
import 'package:video_player_stream_download/view/auth/auth_page.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  var userNameController = TextEditingController();
  var userEmailController = TextEditingController();
  var userDobController = TextEditingController();
  String name = '';
  String email = '';
  String dob = '';
  bool darkModeEnabled = false;
  bool isUserLoggedIn = false;
  DateTime? userDob;

  void setDateOfBirth(BuildContext context) async {
    userDob = await showDatePicker(
      context: context,
      initialDate: userDob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (userDob != null) {
      userDobController.text = DateFormat('dd/MM/yyyy').format(userDob!);
    }
  }

  void initUserData(BuildContext context) {
    SharedPrefHelper().initSharedPref(context);
    userNameController.text = name;
    userEmailController.text = email;
    userDobController.text = dob;
  }

  void saveUserData(BuildContext context) {
    name = userNameController.text.trim();
    email = userEmailController.text.trim();
    dob = userDobController.text.trim();
    notifyListeners();
    UserData userData = UserData(
      userId: 0,
      firstName: userNameController.text.trim(),
      lastName: '',
      email: userEmailController.text.trim(),
      phoneNumber: '',
      gender: 0,
      imageURL: '',
      dob: userDobController.text.trim(),
    );
    SharedPrefHelper().saveUserDetails(userData);
    CustomWidgets.showSnackBar('Saved..', context);
  }

  void checkUserLogged(BuildContext context) async {
    SharedPreferences a = await SharedPrefHelper().initSharedPref(context);
    isUserLoggedIn = a.getBool(SharedPrefHelper.userLoggedStateKey) ?? false;
    if (isUserLoggedIn) {
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
    }
    notifyListeners();
  }

  void userLoginStateChanged(bool loggedState) {
    isUserLoggedIn = loggedState;
    SharedPrefHelper().changeUserLoggedState(true);
    notifyListeners();
  }

  // void saveProfileData(String mName, String mEmail, String mDob) {
  //   name = mName;
  //   email = mEmail;
  //   dob = mDob;
  //   notifyListeners();
  // }

  void logoutUser(BuildContext context) async {
    CustomWidgets.showSnackBar('Logging out...', context);
    SharedPrefHelper().removeSharedData();
    isUserLoggedIn = false;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthenticationPage(),
        ));
    notifyListeners();
  }

  void darkThemeChanged() {
    darkModeEnabled = !darkModeEnabled;
    SharedPrefHelper().changeDarkMode(darkModeEnabled);
    notifyListeners();
  }
}
