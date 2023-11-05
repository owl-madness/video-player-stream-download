import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player_stream_download/controller/auth/auth_provider.dart';
import 'package:video_player_stream_download/widget/custome_widgets.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, AuthProvider authProvider, child) =>
              SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 80 / 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 105,
                    ),
                    Image.asset(
                      'assets/images/video_player_logo.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 43,
                    ),
                    TextField(
                      controller: authProvider.phoneTextController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Phone number",
                        border: OutlineInputBorder(),
                        prefix: Text(
                          "+91",
                          style: TextStyle(color: Color(0xff313056)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (authProvider.view == PageMode.otp)
                      TextField(
                        controller: authProvider.otpTextController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "Enter OTP",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 30),
                    CustomWidgets.submitButton(
                      authProvider.resendButtonText,
                      onTap: authProvider.resendOtp
                          ? () => authProvider.resendOTPPressed(context)
                          : null,
                      bgColor: authProvider.resendOtp ? null : Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    CustomWidgets.submitButton(
                      authProvider.view == PageMode.phone
                          ? 'Send OTP'
                          : "Verify OTP",
                      onTap: () => authProvider.view == PageMode.phone
                          ? authProvider.enteredSubmitButton(context)
                          : authProvider.verifyOTP(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum PageMode { phone, otp }
