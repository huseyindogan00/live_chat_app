// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:live_chat_app/view/screens/home_screen.dart';
import 'package:live_chat_app/view/screens/sign_in_screen.dart';
import 'package:live_chat_app/provider/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.state == ViewState.Idle) {
      if (_userViewModel.userModel == null) {
        return const SignInScreen();
      } else {
        return HomeScreen(userModel: _userViewModel.userModel);
      }
    } else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
