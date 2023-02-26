import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/components/common/future_users_widget.dart';
import 'package:live_chat_app/ui/viewmodel/all_users_view_model.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});
  late UserViewModel _userViewModel;
  late AllUsersViewModel _allUsersViewModel;

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);
    _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcılar'),
        centerTitle: true,
        actions: [
          FloatingActionButton.small(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.face_retouching_natural_rounded),
            onPressed: () => _allUsersViewModel.fetchUserWithPagination(),
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: FutureUsersWidget(userViewModel: _userViewModel, isTalks: false),
    );
  }
}
