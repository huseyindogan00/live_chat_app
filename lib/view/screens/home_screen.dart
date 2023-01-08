// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:live_chat_app/models/user_model.dart';
import 'package:live_chat_app/provider/viewModel/user_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.userModel});

  UserModel? userModel;
  //final AuthBase authBaseService = locator<FirebaseAuthService>();

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () => _userViewModel.signOut()),
      appBar: AppBar(
        title: const Text('Anasayfa'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Hoşgeldiniz\n${userModel!.name ?? ''}',
                style: Theme.of(context).textTheme.headline4,
              ),
              CircleAvatar(foregroundImage: userModel!.photoUrl != null ? NetworkImage(userModel!.photoUrl!) : null),
              const Spacer(flex: 1),
              Text(
                'Mail : ${userModel!.gmail ?? ''}',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Spacer(flex: 1),
              Text('Numara: ${userModel!.phoneNumber ?? 'boş'}'),
              const Spacer(flex: 5)
            ],
          ),
        ),
      ),
    );
  }
}
