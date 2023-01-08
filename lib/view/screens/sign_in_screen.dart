// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:live_chat_app/core/product/constant/app_icons.dart';
import 'package:live_chat_app/data/user_repository.dart';
import 'package:live_chat_app/provider/viewModel/user_view_model.dart';
import 'package:live_chat_app/view/widgets/button/login_button.dart';
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
        actions: [
          Text(
            UserViewModel.appMode == AppMode.DEBUG ? 'DEBUG MOD ' : 'RELEASE MOD',
            textAlign: TextAlign.center,
          ),
          Switch(
            value: _userViewModel.appModeState,
            activeColor: const Color.fromARGB(255, 209, 162, 161),
            onChanged: (value) {
              _userViewModel.changeAppMode(value);
            },
          ),
        ],
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
              buttonText: 'Gmail ile Giriş Yap',
              buttonColor: Colors.white,
              onPressed: () async {
                await _userViewModel.signInWithGmail();
              },
              buttonIcon: Image.asset(AppIcons.gmail),
              textColor: Colors.black87,
            ),
            LoginButton(
              buttonText: 'Facebook ile Oturum Aç',
              buttonColor: const Color(0xFF334D92),
              onPressed: () {},
              buttonIcon: Image.asset(AppIcons.facebook),
            ),
            LoginButton(
              buttonText: 'Email ve Şifre ile Giriş Yap',
              buttonColor: Colors.purple,
              onPressed: () {},
              buttonIcon: Image.asset(AppIcons.mail),
              textColor: Colors.white,
            ),
            LoginButton(
              buttonText: 'Misafir Girişi',
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
