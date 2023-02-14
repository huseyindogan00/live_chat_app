import 'package:flutter/material.dart';
import 'package:live_chat_app/ui/components/common/future_users_widget.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class MyTalksPage extends StatefulWidget {
  const MyTalksPage({super.key});

  @override
  State<MyTalksPage> createState() => _MyTalksPageState();
}

class _MyTalksPageState extends State<MyTalksPage> {
  late UserViewModel _userViewModel;
  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sohbetler'),
      ),
      body: FutureUsersWidget(userViewModel: _userViewModel, isTalks: true),
    );
  }
}
