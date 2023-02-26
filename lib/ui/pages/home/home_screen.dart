// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:live_chat_app/data/models/user_model.dart';
import 'package:live_chat_app/data/services/firebase_notification_service.dart';
import 'package:live_chat_app/ui/components/common/bottom_navi/tab_item.dart';
import 'package:live_chat_app/ui/components/common/platform_sensitive_alert_dialog.dart';
import 'package:live_chat_app/ui/pages/profile/profile_page.dart';
import 'package:live_chat_app/ui/pages/talk/my_talks_page.dart';
import 'package:live_chat_app/ui/pages/users/users_page.dart';
import 'package:live_chat_app/ui/components/common/bottom_navi/my_custom_bottom_navi.dart';
import 'package:live_chat_app/ui/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.userModel});

  UserModel? userModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItemEnum _currentTab = TabItemEnum.USERS;

  Map<TabItemEnum, Widget> get pageAll => {
        TabItemEnum.USERS: UsersPage(),
        TabItemEnum.TALKS: const MyTalksPage(),
        TabItemEnum.PROFILE: const ProfilePage(),
      };

  final GlobalKey<NavigatorState> usersNavState = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> profileNavState = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> talksNavState = GlobalKey<NavigatorState>();

  Map<TabItemEnum, GlobalKey<NavigatorState>> get navigatorKeys => {
        TabItemEnum.USERS: usersNavState,
        TabItemEnum.PROFILE: profileNavState,
        TabItemEnum.TALKS: talksNavState,
      };

  final notificationServise = FirebaseNotificationService();

  @override
  void initState() {
    super.initState();
    notificationServise.connectNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      PlatformSensitiveAlertDialog(
        content: event.data['message'].toString(),
        title: event.data['title'] + event.data['name'],
        doneButtonTitle: 'Tamam',
      ).show(context);
    });
  }

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

Future<void> firebaseMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Arka planda bildiirim yakalandı ${message.data['name']}');
}
