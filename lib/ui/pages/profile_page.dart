import 'package:flutter/material.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            onPressed: () => doExit(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Profil sayfası'),
      ),
    );
  }

  Future<bool> doExit(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
}
