import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_player_stream_download/controller/auth/auth_provider.dart';
import 'package:video_player_stream_download/controller/home/home_provider.dart';
import 'package:video_player_stream_download/controller/profile/profile_provider.dart';
import 'package:video_player_stream_download/repository/shared_preference_helper.dart';
import 'package:video_player_stream_download/view/auth/auth_page.dart';
import 'package:video_player_stream_download/view/home/home_page.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDAKaexDB9GYj1mdzhhju9ro5ueb4I10FM',
        appId: '1:751459616120:android:71e79cbd3ea40f45a2748d',
        messagingSenderId: '751459616120',
        projectId: 'phone-firebase-a6ea2'),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false)
        .checkUserLogged(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ProfileProvider profileProvider, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: profileProvider.darkModeEnabled
            ? ThemeData.dark()
            : ThemeData.light(useMaterial3: true),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          if (Provider.of<ProfileProvider>(context, listen: false)
              .isUserLoggedIn) {
            // Provider.of<HomeProvider>(context, listen: false)
            //     .initialiseVideoData(context);
            return const HomePage();
          } else {
            return const AuthenticationPage();
          }
        }));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: Center(
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/video_player_logo.png',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomWidgets.stoppedAnimationProgress(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
