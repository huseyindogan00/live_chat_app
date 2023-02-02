import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/talk/talk_page.dart';
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
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<UserModel>? users = snapshot.data;
                return _buildListBuilder(context, users, _userViewModel);
              } else {
                return const Center(child: Text('Kayıtlı kullanıcı yoktur.'));
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: _userViewModel.getAllUsers(),
        ),
      ),
    );
  }

  ListView _buildListBuilder(BuildContext context, List<UserModel>? users, UserViewModel _userViewModel) {
    return ListView.builder(
      itemCount: users!.length,
      itemBuilder: (context, index) {
        if (_userViewModel.userModel!.userID != users[index].userID) {
          return _buildUserCard(context, users, index);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Card _buildUserCard(BuildContext context, List<UserModel> users, int index) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => TalkPage(chatUser: users[index], currentUser: _userViewModel.userModel!),
        )),
        child: ListTile(
          leading: users[index].photoUrl != null ? _buildProfilePhoto(users, index) : _buildDefaultProfilePhoto(),
          title: Text(users[index].userName.toString()),
          subtitle: Text(users[index].email.toString()),
        ),
      ),
    );
  }

  CircleAvatar _buildDefaultProfilePhoto() => CircleAvatar(
        maxRadius: 25,
        backgroundImage: AssetImage(ImageConstPath.defaultProfilePhoto),
      );

  CircleAvatar _buildProfilePhoto(List<UserModel> users, int index) {
    return CircleAvatar(
      backgroundImage: NetworkImage(users[index].photoUrl!),
      maxRadius: 25,
    );
  }
}
