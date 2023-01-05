import 'package:flutter/material.dart';
import 'package:live_chat_app/product/constant/app_icons.dart';
import 'package:live_chat_app/widgets/button/login_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              buttonText: 'Gmail ile Giriş Yap',
              buttonColor: Colors.white,
              onPressed: () {},
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
                textColor: Colors.white)
          ],
        ),
      ),
    );
  }
}
