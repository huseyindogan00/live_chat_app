// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:live_chat_app/ui/pages/sign_in/email_login_and_register.dart';
import 'package:live_chat_app/core/constant/app_icons.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:live_chat_app/ui/components/common/button/login_button.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Live Chat'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Oturum Aç',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LoginButton(
              buttonTextWidget: const Text(
                'Gmail ile Giriş Yap',
                style: TextStyle(color: Colors.black),
              ),
              buttonColor: Colors.white,
              onPressed: () async {
                await _userViewModel.signInWithGmail();
              },
              buttonIcon: Image.asset(AppIcons.gmail),
              textColor: Colors.black87,
            ),
            LoginButton(
              buttonTextWidget: const Text('Facebook ile Oturum Aç'),
              buttonColor: const Color(0xFF334D92),
              onPressed: () => null,
              //await _userViewModel.signInWithFacebook();
              buttonIcon: Image.asset(AppIcons.facebook),
            ),
            LoginButton(
              buttonTextWidget: const Text('Email ve Şifre ile Giriş Yap'),
              buttonColor: Colors.purple,
              onPressed: () async {
                bool? result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (context) => const EmailLoginAndRegister(),
                  ),
                );
              },
              buttonIcon: Image.asset(AppIcons.mail),
              textColor: Colors.white,
            ),
            LoginButton(
              buttonTextWidget: const Text('Misafir Girişi'),
              buttonColor: Colors.teal,
              buttonIcon: const Icon(Icons.supervised_user_circle_rounded),
              onPressed: () async {
                await _userViewModel.signInAnonymously();
              },
            )
          ],
        ),
      ),
    );
  }
}
