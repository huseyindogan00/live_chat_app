import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/ui/components/common/future_users_widget.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});
  late UserViewModel _userViewModel;

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcılar'),
        centerTitle: true,
      ),
      body: FutureUsersWidget(userViewModel: _userViewModel, isTalks: false),
    );
  }
}
