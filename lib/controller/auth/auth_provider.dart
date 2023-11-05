import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_stream_download/controller/home/home_provider.dart';
import 'package:video_player_stream_download/controller/profile/profile_provider.dart';
import 'package:video_player_stream_download/model/data_model.dart';
import 'package:video_player_stream_download/model/user_model.dart';
import 'package:video_player_stream_download/model/video_model.dart';
import 'package:video_player_stream_download/repository/app_constants.dart';
import 'package:video_player_stream_download/view/auth/auth_page.dart';
import 'package:video_player_stream_download/view/home/home_page.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final phoneTextController = TextEditingController();
  final otpTextController = TextEditingController();
  var view = PageMode.phone;
  bool resendOtp = false;
  String resendButtonText = "Resend OTP";
  late Timer timer;
  var counter = 20;
  bool mounted = false;
  String _verificationId = '';
  PhoneAuthCredential? credential;

  FirebaseAuth auth = FirebaseAuth.instance;

  enteredSubmitButton(BuildContext context) {
    if (view == PageMode.phone) {
      if (phoneTextController.text.trim().length == 10) {
        view = PageMode.otp;
        resendOtp = true;
        notifyListeners();
        firebaseOTPRequest(context);
      } else {
        CustomWidgets.showSnackBar('Enter correct number', context);
      }
    } else {
      verifyOTP(context);
    }
  }

  void resendOTPPressed(BuildContext context) {
    if (phoneTextController.text.trim().length == 10) {
      debugPrint("OTP resend");
      // enteredSubmitButton(context);
      firebaseOTPRequest(context);
      resendOtp = false;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        resendButtonText = 'Resend in ${(counter - timer.tick).toString()}';
        notifyListeners();
        if (timer.tick == 20) {
          resendButtonText = "Resend OTP";
          resendOtp = true;
          notifyListeners();
          timer.cancel();
        }
      });
      notifyListeners();
    } else {
      CustomWidgets.showSnackBar('Enter correct number', context);
    }
  }

  void firebaseOTPRequest(BuildContext context) async {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 ${phoneTextController.text.trim()}',
      verificationCompleted: (phoneAuthCredential) =>
          _verificationCompleted(phoneAuthCredential, context),
      verificationFailed: (error) {
        CustomWidgets.showSnackBar(error.message ?? "Error", context);
      },
      codeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        CustomWidgets.showSnackBar("code sent", context);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (mounted) {
          CustomWidgets.showSnackBar("Timeout!", context);
        }
      },
    );
  }

  void verifyOTP(BuildContext context) async {
    if (otpTextController.text.trim().isEmpty) {
      CustomWidgets.showSnackBar('Enter OTP', context);
    } else {
      try {
        CustomWidgets.showSnackBar('Validating...', context);
        debugPrint('Trying..');
        credential = PhoneAuthProvider.credential(
            verificationId: _verificationId,
            smsCode: otpTextController.text.trim());
        // final UserCredential user =
        //     await auth.signInWithCredential(credential!);

        // print('user ${user.additionalUserInfo?.providerId}');

        FirebaseAuth.instance.signInWithCredential(credential!).then((value) async {
          User? user = value.user;
          if (user != null) {
            CustomWidgets.showSnackBar('Logging in...', context);
            // Provider.of<HomeProvider>(context, listen: false).initialiseVideoData(context);


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
            AppConstants.availableVideos = tempList;


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
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString(AppConstants.avialbleVideosListString,
                videoModelToJson(AppConstants.availableVideos));

            Provider.of<ProfileProvider>(context, listen: false)
                .userLoginStateChanged(true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        });

        // if (user.user?.uid != null) {
        //   AppConstants.loggedUser = UserModel(
        //       auth: Auth(
        //         accessToken: user.user!.uid.toString(),
        //         refreshToken: '',
        //       ),
        //       userData: UserData(
        //         phoneNumber: user.user!.phoneNumber!,
        //         email: user.user!.email!,
        //         firstName: user.user!.displayName!,
        //         imageURL: user.user!.photoURL!,
        //         userId: 0,
        //         lastName: '',
        //         gender: 0,
        //       ));
        //   if (mounted) {
        //     // setState(() {
        //     //   showLoader = false;
        //     // });
        //     CustomWidgets.showSnackBar("Logging in...", context);
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const HomePage(),
        //         ));
        //     // await AuthBloc().login(AppConstants.loggedUser, context);
        //   }
        // }
      } catch (e) {
        print('error : $e');
        CustomWidgets.showSnackBar("OTP is wrong!", context);
      }
    }
  }

  void _verificationCompleted(
      PhoneAuthCredential credential, BuildContext context) async {
    CustomWidgets.showSnackBar("Verifying...", context);

    final UserCredential user = await auth.signInWithCredential(credential);
    if (user.user?.uid != null) {
      AppConstants.loggedUser = UserModel(
          auth: Auth(
            accessToken: user.credential!.token.toString(),
            refreshToken: '',
          ),
          userData: UserData(
            phoneNumber: user.user?.phoneNumber ?? '',
            email: user.user?.email ?? '',
            firstName: user.user?.displayName ?? '',
            imageURL: user.user?.photoURL ?? '',
            userId: 0,
            lastName: '',
            gender: 0,
          ));
      // if (mounted) {
      //   setState(() {
      //     showLoader = false;
      //   });
      //   CustomWidgets.showSnackbar("Logging in...", context);
      //   await AuthBloc().login(AppConstants.loggedUser, context);
      // }
    }
  }
}
