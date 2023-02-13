import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/talk/talk_page.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';

class FutureUsersWidget extends StatefulWidget {
  FutureUsersWidget({super.key, required this.userViewModel, this.isTalks = true});
  final UserViewModel userViewModel;
  bool isTalks;

  @override
  State<FutureUsersWidget> createState() => _FutureUsersWidgetState();
}

class _FutureUsersWidgetState extends State<FutureUsersWidget> {
  late final UserViewModel _userViewModel;
  late final bool _isTalks;

  @override
  void initState() {
    super.initState();
    _userViewModel = widget.userViewModel;
    _isTalks = widget.isTalks;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: _userViewModel.getChattedUsers(_userViewModel.userModel!.userID.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<UserModel>? users = snapshot.data;
              print('Konuşulan user sayısı ==========>> ${users!.length}');
              return _buildListBuilder(context, users, _userViewModel);
            } else {
              return const Center(child: Text('Kayıtlı kullanıcı yoktur.'));
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  ListView _buildListBuilder(BuildContext context, List<UserModel>? users, UserViewModel userViewModel) {
    return ListView.builder(
      itemCount: users!.length,
      itemBuilder: (context, index) {
        if (userViewModel.userModel!.userID != users[index].userID) {
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
        onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => TalkPage(chatUser: users[index], currentUser: _userViewModel.userModel!),
          ),
        ),
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
