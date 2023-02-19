import 'package:flutter/material.dart';
import 'package:live_chat_app/core/constant/image/image_const_path.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/talk/talk_page.dart';
import 'package:live_chat_app/ui/viewmodel/user_view_model.dart';

class FutureUsersWidget extends StatefulWidget {
  FutureUsersWidget(
      {super.key, required this.userViewModel, this.isTalks = false});
  final UserViewModel userViewModel;
  bool isTalks;

  @override
  State<FutureUsersWidget> createState() => _FutureUsersWidgetState();
}

class _FutureUsersWidgetState extends State<FutureUsersWidget> {
  late final UserViewModel _userViewModel;
  late final bool _isTalks;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  final GlobalKey<RefreshIndicatorState> _refreshKey2 =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _userViewModel = widget.userViewModel;
    _isTalks = widget.isTalks;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<UserModel>>(
        future: _isTalks
            ? _userViewModel
                .fetchChattedUsers(_userViewModel.userModel!.userID!)
            : _userViewModel.fetchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<UserModel>? users = snapshot.data;
              return _buildUserListBuilder(users);
            } else {
              return _buildIsUserNull(context);
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  RefreshIndicator _buildUserListBuilder(List<UserModel>? users) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        setState(() {});
      },
      child: ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) {
          if (_userViewModel.userModel!.userID != users[index].userID) {
            return _buildUserCard(context, users[index]);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Card _buildUserCard(BuildContext context, UserModel users) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => TalkPage(
                chatUser: users, currentUser: _userViewModel.userModel!),
          ),
        ),
        child: ListTile(
          leading: users.photoUrl != null
              ? _buildProfilePhoto(users)
              : _buildDefaultProfilePhoto(),
          title: Text(users.email.toString()),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(users.userName.toString()),
              users.lastMessageTimeToString == null
                  ? const SizedBox()
                  : Text(users.lastMessageTimeToString.toString()),
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

  // hiç bir kullanıcı bulunamadığında
  RefreshIndicator _buildIsUserNull(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey2,
      onRefresh: () async {
        setState(() {});
      },
      child: Stack(
        children: [
          ListView(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.4),
            const Center(child: Text('Kayıtlı kullanıcı yoktur'))
          ]),
        ],
      ),
    );
  }
}
