// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/ui/pages/profile_page.dart';
import 'package:live_chat_app/ui/pages/users_page.dart';
import 'package:live_chat_app/ui/widgets/bottom_navi/my_custom_bottom_navi.dart';
import 'package:live_chat_app/ui/widgets/bottom_navi/tab_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.userModel});

  UserModel? userModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItemEnum _currentTab = TabItemEnum.USERS;

  Map<TabItemEnum, Widget> get pageAll => {
        TabItemEnum.USERS: const UsersPage(),
        TabItemEnum.PROFILE: const ProfilePage(),
      };

  final GlobalKey<NavigatorState> usersNavState = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileNavState = GlobalKey<NavigatorState>();

  Map<TabItemEnum, GlobalKey<NavigatorState>> get navigatorKeys => {
        TabItemEnum.USERS: usersNavState,
        TabItemEnum.PROFILE: profileNavState,
      };

  @override
  Widget build(BuildContext context) {
    //final _userViewModel = Provider.of<UserViewModel>(context);
    return WillPopScope(
      onWillPop: () async => await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: MyCustomBottomNavigator(
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        createdPage: pageAll,
        onSelectedTab: (selectedTab) {
          if (selectedTab == _currentTab) {
            if (navigatorKeys[selectedTab]!.currentState != null) {
              navigatorKeys[selectedTab]!.currentState!.popUntil((route) => route.isFirst);
            }
          } else {
            setState(() {
              _currentTab = selectedTab;
            });
          }
        },
      ),
    );
  }
}
/* Center(
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
              CircleAvatar(
                  foregroundImage: userModel!.photoUrl != null ? NetworkImage(userModel!.photoUrl!) : null,
                  maxRadius: 50),
              const Spacer(flex: 1),
              Text(
                'Mail : ${userModel!.email ?? ''}',
                style: Theme.of(context).textTheme.headline5,
              ),
              const Spacer(flex: 1),
              Text('Numara: ${userModel!.phoneNumber ?? 'boş'}'),
              const Spacer(flex: 5)
            ],
          ),
        ),
      ), */