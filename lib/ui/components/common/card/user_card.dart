import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/talk/talk_page.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key, required this.users});

  UserModel users;
  late UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {
    userViewModel = Provider.of<UserViewModel>(context);
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => TalkPage(chatUser: users, currentUser: userViewModel.userModel!),
          ),
        ),
        child: ListTile(
          leading: users.photoUrl != null ? _buildProfilePhoto(users) : _buildDefaultProfilePhoto(),
          title: Text(users.email.toString()),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(users.userName.toString()),
              users.lastMessageTimeToString != null && users.lastMessageTimeToString!.isNotEmpty
                  ? Text(users.lastMessageTimeToString.toString())
                  : const Text('süre alınamadı'),
            ],
          ),
        ),
      ),
    );
  }

  CircleAvatar _buildDefaultProfilePhoto() => CircleAvatar(
        maxRadius: 25,
        backgroundImage: AssetImage(ImageConstPath.defaultProfilePhoto),
      );

  CircleAvatar _buildProfilePhoto(UserModel users) {
    return CircleAvatar(
      backgroundImage: NetworkImage(users.photoUrl!),
      maxRadius: 25,
    );
  }
}
