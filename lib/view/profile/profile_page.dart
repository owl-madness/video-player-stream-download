import 'package:flutter/material.dart';
import 'package:video_player_stream_download/controller/profile/profile_provider.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:video_player_stream_download/widget/def_text_field.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  void initState() {
    Provider.of<ProfileProvider>(context, listen: false).initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ProfileProvider profileProvider, child) => Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            profileProvider.userDobController.clear();
            profileProvider.userEmailController.clear();
            profileProvider.userNameController.clear();
            return true;
          },
          child: SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 60),
                  TextFieldDef(
                    controller: profileProvider.userNameController,
                    label: 'Name',
                  ),
                  const SizedBox(height: 20),
                  TextFieldDef(
                    controller: profileProvider.userEmailController,
                    label: 'Email',
                  ),
                  const SizedBox(height: 20),
                  TextFieldDef(
                    controller: profileProvider.userDobController,
                    readOnly: true,
                    label: 'Date of Birth',
                    suffix: const Icon(Icons.date_range),
                    onTap: () => profileProvider.setDateOfBirth(context),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 60 / 100,
                    child: CustomWidgets.submitButton(
                      'Save',
                      onTap: () => profileProvider.saveUserData(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
